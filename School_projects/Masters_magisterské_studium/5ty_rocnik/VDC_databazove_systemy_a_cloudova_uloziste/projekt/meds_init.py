import pymysql
import json

with open('db.json', 'r') as f_db:
    db_config = json.load(f_db)

connection = pymysql.connect(
    host=db_config['host'],
    port=db_config['port'],
    user=db_config['user'],
    password=db_config['password'],
    database=db_config['database'],
    cursorclass=pymysql.cursors.DictCursor
)

with connection.cursor() as cursor:
   sql = "SELECT * FROM medicament"
   cursor.execute(sql)
   result = cursor.fetchall()
   print(result)