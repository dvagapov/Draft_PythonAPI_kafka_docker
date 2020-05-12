## Use docker-compose

Start docker-compose
	$ docker-compose up --force-recreate --build 
	
Will run four containers:
	api  - python Flask API
	postgres  - DB postgreSQL 
	broker    - kafka-broker
	zookeeper - zookeeper for kafka-broker

For postgres will also execute pgconfig/init_db.sql. The script contains Schema of DB recommendation with small sample data. 

## Produce data from Different source example
In file "api/produce_data_test.py" I add example of extract and load data into kafka-topic.

### Usage API service
	#### Default token auth
	$ -H 'Authorization: Token tokenTest1'
	
	#### Get 10 Recommendations for current user
	$ curl http://localhost:5000/get_for_current_user -H 'Authorization: Token tokenTest1'
