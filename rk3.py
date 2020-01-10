import pyodbc 
import pandas as pd
conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=(localdb)\ProjectsV13;DATABASE=RK3;UID=rk_user;PWD=rk_user')

cursor = conn.cursor()

fd = open('rk3.sql', 'r')
sqlFile = fd.read()
fd.close()

sqlCommands = sqlFile.split('go;')[:-1]

for command in sqlCommands:
    cursor.execute(command)

df = pd.read_sql_query('select rk3.late(datefromparts(2018, 12, 14))',con=conn)
print(df)

df = pd.read_sql_query('select * from late_in_dep()',con=conn)
print(df)

df = pd.read_sql_query('select * from ave_age_notworking()',con=conn)
print(df)