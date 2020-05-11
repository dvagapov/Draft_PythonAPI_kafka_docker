import os
import json
import unittest
import psycopg2
import os.path

from kafka import KafkaProducer
from kafka.errors import KafkaError
from project import app

class APIUnitTest(unittest.TestCase):
 
    ############################
    #### setup and teardown ####
    ############################
 
    # executed prior to each test
    def setUp(self):
        app.config['TESTING'] = True
        app.config['WTF_CSRF_ENABLED'] = False
        app.config['DEBUG'] = True
        
        self.app = app.test_client()
        self.url_get = "/get_for_current_user"

    # executed after each test
    def tearDown(self):
        pass
 
 
###############
#### tests ####
###############
 
    def test_ping_page(self):
        response = self.app.get('/ping')
        self.assertEqual(response.status_code, 200)
 
    def test_get_without_auth(self):
        response = self.app.get(self.url_get)
        self.assertEqual(response.status_code, 401)
    
    def test_get_with_wrong_token(self):
        headers = dict(AUTHORIZATION='Token tokenWrong')
        response = self.app.get(self.url_get, headers=headers)
        self.assertEqual(response.status_code, 401)
    
    def test_get_empty_data(self):
        headers = dict(AUTHORIZATION='Token tokenTest2')
        response = self.app.get(self.url_get, headers=headers)
        self.assertEqual(response.status_code, 405)
    
    def test_get_data_success(self):
        headers = dict(AUTHORIZATION='Token tokenTest1')
        response = self.app.get(self.url_get, headers=headers)
        self.assertEqual(response.status_code, 200)
    
    def test_kafka_data_success(self):
        # produce data for "User2"
        producer = KafkaProducer(bootstrap_servers=[os.environ.get('KAFKA_BROKER_URI')])
        future = producer.send(os.environ.get('RECOMMENDATIONS_TOPIC'), key=b'', value=b'[(2,1,10),(2,2,5)]')
        
        ## wait data consume 
        try:
            record_metadata = future.get(timeout=10)
            headers = dict(AUTHORIZATION='Token tokenTest2')
            response = self.app.get(self.url_get, headers=headers)
            self.assertEqual(response.status_code, 200)
        except KafkaError:
            self.assertEqual(log.exception(), 'ERR')
            pass

        # DELETE Test data in DB
        try:
            conn = psycopg2.connect(dbname=os.environ.get('PG_DB'), user=os.environ.get('PG_USER'), 
                                    password=os.environ.get('PG_PASS'), host=os.environ.get('PG_HOST'))
            with conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor) as cursor:
                conn.autocommit = True
                ## User_ID = 2 == 'TokenTest2" (test user)
                cursor.execute('DELETE FROM user_product WHERE User_ID = 2')
        except (Exception, psycopg2.Error) as error :
            print(error)

if __name__ == "__main__":
    unittest.main()