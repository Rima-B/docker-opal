#!/bin/bash

# Configure some databases for IDs and data
echo "Waiting for Opal to be ready..."
until opal rest -o https://localhost:8443 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m GET /system/databases &> /dev/null
do
	sleep 5
done

echo "Initializing Opal databases..."
sed s/@mongo_host@/$MONGO_PORT_27017_TCP_ADDR/g /opt/opal/data/idsdb.json | \
    sed s/@mongo_port@/$MONGO_PORT_27017_TCP_PORT/g | \
    opal rest -o https://localhost:8443 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /system/databases --content-type "application/json"
sed s/@mongo_host@/$MONGO_PORT_27017_TCP_ADDR/g /opt/opal/data/mongodb.json | \
    sed s/@mongo_port@/$MONGO_PORT_27017_TCP_PORT/g | \
    opal rest -o https://localhost:8443 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /system/databases --content-type "application/json"

echo "Initializing Datashield..."
if [ -n "$RSERVER_PORT_6312_TCP_ADDR" ]
	then
	opal rest -o https://localhost:8443 -u administrator -p $OPAL_ADMINISTRATOR_PASSWORD -m POST /datashield/packages?name=datashield
fi