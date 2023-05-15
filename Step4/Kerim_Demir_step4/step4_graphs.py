import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

connection = mysql.connector.connect(
    user='root', password='Kerim2002', database='306_project')
cursor = connection.cursor()

query1 = ("Select * from smoking_deaths_gt_avg")
query2 = ("Select * from cardiovascular_diseases_gt_avg")

smoking = []
cardiovascular = []

cursor.execute(query1)
for item in cursor:
    smoking.append(item)

cursor.execute(query2)
for item in cursor:
    cardiovascular.append(item)

smoke = pd.DataFrame(smoking, columns=[
                     'name', "year", "deaths_by_smoking", "avg_smoking_deaths_per_year", "total_deaths"])
cardio = pd.DataFrame(cardiovascular, columns=[
                      'name', "year", "deaths_by_cardiovascular_diseases", "avg_cardiovascular_deaths_per_year"])
del smoke["total_deaths"]
del smoke["avg_smoking_deaths_per_year"]
del cardio["avg_cardiovascular_deaths_per_year"]

names = []

queryNamesMin = (
    "Select name from smoking_deaths_gt_avg group by name order by sum(deaths_by_smoking)")
cursor.execute(queryNamesMin)
for item in cursor:
    names.append(item)

top10_1 = []
min10_1 = []
top10_2 = []
min10_2 = []

for i in range(10):
    if i < 5:
        min10_1.append(names[i][0])
        top10_1.append(names[len(names)-i-1][0])
    else:
        min10_2.append(names[i][0])
        top10_2.append(names[len(names)-i-1][0])

df = pd.merge(smoke, cardio, on=['name', 'year'], how='outer')
df = df.fillna(value=np.nan)
joined_df = df.groupby('name')

fig, (ax1, ax2, ax3, ax4) = plt.subplots(4)
ax1.set_title("Min first half")
ax2.set_title("Min second half")
ax3.set_title("Max first half")
ax4.set_title("Max second half")
ax1.set_ylabel("Deaths")
ax2.set_ylabel("Deaths")
ax3.set_ylabel("Deaths")
ax4.set_ylabel("Deaths")
plt.xlabel("Year")
for country, data in joined_df:
    if country in min10_1:
        ax1.scatter(data["year"], data["deaths_by_smoking"],
                    label=f'{country} smoking')
        ax1.scatter(data["year"], data["deaths_by_cardiovascular_diseases"],
                    label=f'{country} cardio')
    elif country in min10_2:
        ax2.scatter(data["year"], data["deaths_by_smoking"],
                    label=f'{country} smoking')
        ax2.scatter(data["year"], data["deaths_by_cardiovascular_diseases"],
                    label=f'{country} cardio')
    elif country in top10_1:
        ax3.scatter(data["year"], data["deaths_by_smoking"],
                    label=f'{country} smoking')
        ax3.scatter(data["year"], data["deaths_by_cardiovascular_diseases"],
                    label=f'{country} cardio')
    elif country in top10_2:
        ax4.scatter(data["year"], data["deaths_by_smoking"],
                    label=f'{country} smoking')
        ax4.scatter(data["year"], data["deaths_by_cardiovascular_diseases"],
                    label=f'{country} cardio')
fig.legend(fontsize="8", loc='upper left')
plt.show()

connection.close()
