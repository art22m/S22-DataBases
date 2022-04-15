# create db
# psql - d template1
import psycopg2
import geopy
from geopy.geocoders import Nominatim

# https://stackabuse.com/working-with-postgresql-in-python/
con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="", host="127.0.0.1", port="5432")

geolocator = Nominatim(user_agent="art22m")

print("Database opened successfully")
cur = con.cursor()

cur.callproc('retrieveAddress')
addressList = cur.fetchall()
for address in addressList:
    location = geolocator.geocode(address[1], timeout = None)
    if location:
        cur.execute("UPDATE address SET latitude = {}, longitude = {} WHERE address_id = {}".format(location.latitude, location.longitude, address[0]))
    else:
        cur.execute("UPDATE address SET latitude = 0, longitude = 0 WHERE address_id = {}".format(address[0]))

con.commit()