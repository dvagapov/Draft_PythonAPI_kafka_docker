import json 
import mysql.connector
import boto3

from kafka import KafkaProducer
from kafka.errors import KafkaError

INTERRUPT_EVENT = Event()

def kafka_producer():
    producer = KafkaProducer(bootstrap_servers=[os.environ.get('KAFKA_BROKER_URI')])
    return producer

def produce_csv(filename, topic = "rec.develop.csv.input"):
    """ 
        Expected data format [num(User_ID),num(Prduct_ID),num(Rank)]       
    """
    producer = kafka_producer()
    with open(filename) as f:
        for line in f:
            future = producer.send(topic, line)

def produce_json(filename, topic = "rec.develop.json.input"):
    """ 
    Produce from JSON-file
    """
    producer = kafka_producer()
    try:
        json.loads('./test_files/produce.json')
        future = producer.send(topic, json)
    except Exception as error :
        print(error)

def produce_mysql(mysqltable, offset, topic = "rec.develop.mysql.input"):
    """ 
        Produce data into kafka topic from MySQL
    """
    producer = kafka_producer()
    try:
        mydb = mysql.connector.connect(
          host="localhost",
          user="yourusername",
          passwd="yourpassword",
          database="mydatabase"
        )

        mycursor = mydb.cursor()

        mycursor.execute("SELECT * FROM {} WHERE ID > {}".format(mysqltable,offset))

        myresult = mycursor.fetchall()

        for x in myresult:
          future = producer.send(topic, json)
    except Exception as error :
        print(error)
    
def produce_mysql(dytable, offset, topic = "rec.develop.mysql.input"):
    """ 
        Produce data into kafka topic from DynamoDB
    """
    producer = kafka_producer()
    try:
        dynamodb = boto3.resource('dynamodb', region_name='us-west-2', endpoint_url="http://localhost:8000")

        table = dynamodb.Table(dytable)

        response = table.query(
            KeyConditionExpression=Key('ID').gr(offset)
        )

        for item in response['Items']:
          future = producer.send(topic, item)
    except Exception as error :
        print(error)

## If input data is not fit to topic == RECOMMENDATIONS_TOPIC
## then need extra ETL python def (or KSQL (kafka)-procedure)