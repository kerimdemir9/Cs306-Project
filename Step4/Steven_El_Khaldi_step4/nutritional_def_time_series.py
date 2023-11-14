import mysql.connector
from mysql.connector import errorcode
import pandas as pd
import matplotlib.pyplot as plt


def connectionCreator():
    try:
        cnx = mysql.connector.connect(
            user="root", password="", database="306_project"
        )
        print("Connection established with the database")
        return cnx
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
        return None
    else:
        cnx.close()
        return None


# create a connection with database
cnx = connectionCreator()

# query to get the nutritional deficiencies diet deaths period view
query = """SELECT * from nutritional_deficiencies_diet_deaths_period"""

# read the view into a pandas data-frame
df = pd.read_sql(query, cnx)

df.set_index('year', inplace=True)

# Plot the time series
plt.plot(df.index, df['total_deaths_by_nutritional_deficiencies'])
plt.title('Global Total Deaths by Nutritional Deficiencies Time Series')
plt.xlabel('Year')
plt.ylabel('')
plt.ticklabel_format(style='plain')

plt.savefig('nutritional_deficiencies_time_series.png')
cnx.close()
