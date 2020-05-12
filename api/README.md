## Used libs for API:
	* json
	* sys, os, io, base64
	* unittest
	* signal

	[requirements.txt]
	* Flask==1.1.1
	* Flask-HTTPAuth==3.3.0
	* Flask_restx==0.1.1
	* psycopg2-binary==2.8.4
	* flask-kafka
	* kafka-python

-----
## For developing API
### Before
Create and activate virtual environment with python 3.6+

	* If "virtualenv" not istalled before:
		$ python3 -m pip install --user virtualenv

	* In main folder run below commands:
		$ python3 -m venv api
		$ cd api/
		$ source bin/activate
	
Install the requirements
	$ pip install -r requirements.txt

Run Flask RESTful
	$ export FLASK_APP=project/__init__.py
	$ python manage.py run

### Usage API service
	#### Default token auth
	$ -H 'Authorization: Token tokenTest1'
	
	#### Get 10 Recommendations for current user
	$ curl http://localhost:5000/get_for_current_user -H 'Authorization: Token tokenTest1'
	
### Unittest API
	$ python api.unit.test.py

### Stop API service
For deactivate virtual environment just type:
	$ deactivate
