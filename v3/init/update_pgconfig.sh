#!/bin/bash

# Path to the PostgreSQL configuration file
PG_CONF="/var/lib/postgresql/data/postgresql.conf"

# Parameters to update
SHARED_BUFFERS="512MB"
WORK_MEM="16MB"
MAX_CONNECTIONS="200"
LISTEN_ADDRESSES="'*'"

echo "Updating postgresql.conf with custom settings..."

# Modify parameters in the configuration file using sed
sed -i "s/^#*shared_buffers = .*/shared_buffers = '$SHARED_BUFFERS'/" $PG_CONF
sed -i "s/^#*work_mem = .*/work_mem = '$WORK_MEM'/" $PG_CONF
sed -i "s/^#*max_connections = .*/max_connections = '$MAX_CONNECTIONS'/" $PG_CONF

# Modify listen_addresses to allow remote connections
sed -i "s/^#*listen_addresses = .*/listen_addresses = $LISTEN_ADDRESSES/" $PG_CONF

echo "Custom PostgreSQL settings applied successfully."