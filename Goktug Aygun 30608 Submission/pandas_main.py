from matplotlib.gridspec import GridSpec
from mysql.connector import errorcode
import matplotlib.pyplot as plt
import mysql.connector
import pandas as pd
import warnings


warnings.filterwarnings("ignore", category=UserWarning, module="pandas", message = "pandas only supports SQLAlchemy connectable (engine/connection) or database string URI or sqlite3 DBAPI2 connection. Other DBAPI2 objects are not tested. Please consider using SQLAlchemy. ")


def connectionCreator():
    try:
        cnx = mysql.connector.connect(
            user = "root", password = "CS306", database = "cs306-project"
        )
        print("Connection established with the database")
        return cnx
    except mysql.connector.Error as err: 
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your username or your password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
        return None
    else:
        cnx.close()
        return None



mydb = connectionCreator()

fig = plt.figure(constrained_layout=True)
gs = GridSpec(6, 2, figure=fig, hspace=0.05, wspace= 0)
custom_legend = []
country_list = ["PAK", "NGA", "BGD", "CHN", "IND", "RUS"]
for num in range(len(country_list)):
    ax1 = fig.add_subplot(gs[num, 0])
    ax2 = fig.add_subplot(gs[num, 1])

    query = "Select year, deaths_by_outdoor_air_pollution From nature_deaths WHERE iso_code = '{}'".format(country_list[num])
    result_dataframe = pd.read_sql(query, mydb)
    
    ax1.plot(result_dataframe['year'], result_dataframe['deaths_by_outdoor_air_pollution'])
    ax1.legend([country_list[num]], loc="upper left")

    ax1.set_yticklabels(['{:.0f}'.format(x) for x in ax1.get_yticks()])

    query = "Select year, nitrogen_oxide_in_tonnes_NOx, sulphur_dioxide_in_tonnes_SO2, carbon_monoxide_in_tonnes_CO, ammonia_in_tonnes_NH3 From emissions WHERE iso_code = '{}'".format(country_list[num])
    
    result_dataframe = pd.read_sql(query, mydb)

    ax2.plot(result_dataframe['year'], result_dataframe['nitrogen_oxide_in_tonnes_NOx'])
    ax2.plot(result_dataframe['year'], result_dataframe['sulphur_dioxide_in_tonnes_SO2'])
    ax2.plot(result_dataframe['year'], result_dataframe['carbon_monoxide_in_tonnes_CO'])
    ax2.plot(result_dataframe['year'], result_dataframe['ammonia_in_tonnes_NH3'])
    
    ax2.set_yticklabels(['{:.0f}'.format(x) for x in ax2.get_yticks()])
    ax2.set_yscale("log")
    

    custom_legend.append("Nitrogen Oxide (NOx)")
    custom_legend.append("Carbon Monoxide (CO)")
    custom_legend.append("Sulphur Dioxide  (SO2)")
    custom_legend.append("Ammonia (NH)")
    ax2.legend(custom_legend, fontsize = "8", loc = "upper right")
    if num == len(country_list) - 1:
        ax1.set_xlabel("Year")
        ax2.set_xlabel("Year")

    ax1.set_ylabel("Deaths")
    ax2.set_ylabel("Emissions")

fig.suptitle("Death Numbers and Emission Numbers Over Time")
plt.show()

mydb.close()
