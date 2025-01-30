#!/bin/bash

# Path to pg_hba.conf
PG_HBA="/var/lib/postgresql/data/pg_hba.conf"

# The line to be added if it doesn't exist
LINE="host all all all scram-sha-256"

# Check if the line already exists in the pg_hba.conf file
if ! grep -Fxq "$LINE" "$PG_HBA"; then
 # If the line does not exist, append it to the file
 echo "Modifying pg_hba.conf to allow connections from any IP..."
 echo "$LINE" >> "$PG_HBA"
else
 echo "The line '$LINE' already exists in pg_hba.conf. No changes made."
fi

# Reload the PostgreSQL configuration
echo "Reloading PostgreSQL configuration..."
pg_ctl reload