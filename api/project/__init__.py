import json
import sys
import os.path
import psycopg2
import psycopg2.extras
import signal

from psycopg2 import sql
from threading import Event

from flask import Flask, make_response, request, g
from flask_restx import Resource, Api, reqparse
from flask_httpauth import HTTPTokenAuth
from flask_kafka import FlaskKafka

app = Flask(__name__)
api = Api(app)
auth = HTTPTokenAuth(scheme='Token')

RECOMMENDATIONS_TOPIC = os.environ.get('RECOMMENDATIONS_TOPIC')
INTERRUPT_EVENT = Event()

kafka = FlaskKafka(INTERRUPT_EVENT,
                 bootstrap_servers=os.environ.get('KAFKA_BROKER_URI'),
                 )

def connect_db():
    conn = psycopg2.connect(dbname=os.environ.get('PG_DB'), user=os.environ.get('PG_USER'), 
                                password=os.environ.get('PG_PASS'), host=os.environ.get('PG_HOST'))
    return conn

# Auth check token
@auth.verify_token
def verify_token(token):
    if not (token):
        return False
    conn = connect_db()
    with conn.cursor() as cursor:
        cursor.execute('SELECT COALESCE( (SELECT User_ID FROM login_user WHERE token = %s LIMIT 1) , 0) a', (token, ))
        user_id = cursor.fetchone()
        if int(user_id[0]) > 0:
            g.current_user = str(user_id[0])
            return True

    return False


# Ping-pong    
@api.route('/ping')
class Ping(Resource):
    def get(self):
        return {
            'status': 'success  ',
            'message': 'pong!'
        }, 200


@api.route('/get_for_current_user')
class Get(Resource):
    '''
        Get JSON of 10 lates recommendations for current user and status 200
        Re
        
        ERR:
            405: Return error msg if not exists any recommendations for current user 
    '''
    @auth.login_required
    def get(self):
        try:
            conn = connect_db()
            with conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor) as cursor:
                cursor.execute('SELECT p.Name Product, ' + 
                                       '               up.Rank ' +
                                       '  FROM user_product up ' +
                                       '     JOIN product p ON p.ID = up.Product_ID '
                                       '  WHERE User_ID = %s ' +
                                       '  ORDER BY TS DESC, Rank ASC ' +
                                       '  LIMIT 10 ', (str(g.current_user), ))
                results = cursor.fetchall()
                if len(results) < 1:
                    response = make_response('ERR. No found products for current user',405);
                else:
                    response = make_response(json.dumps(results), 200)
                return response
        except (Exception, psycopg2.Error) as error :
            response = make_response(error, 410)

def listen_kill_server():
    signal.signal(signal.SIGTERM, kafka.interrupted_process)
    signal.signal(signal.SIGINT, kafka.interrupted_process)
    signal.signal(signal.SIGQUIT, kafka.interrupted_process)
    signal.signal(signal.SIGHUP, kafka.interrupted_process)


@kafka.handle(RECOMMENDATIONS_TOPIC)
def push_from_kafka_to_db(msg):
    """
        Insert data from Kafka-topic to DB
        
        Expected data format
        [
            ('User_ID','Product_ID','Rank'),
            ('User_ID','Product_ID','Rank'),
            ('User_ID','Product_ID','Rank'),
            ...
        ]
        
    """
    try:
        
        with conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor) as cursor:
            conn.autocommit = True
            insert = sql.SQL('INSERT INTO user_product (User_ID, Product_ID, Rank) VALUES {}').format(
                sql.SQL(',').join(map(sql.Literal, list(msg)))
            )
            cursor.execute(insert)
    except (Exception, psycopg2.Error) as error :
            response = make_response(error, 410)

if __name__ == '__main__':
    kafka.run()
    listen_kill_server()
    app.run(debug=True)