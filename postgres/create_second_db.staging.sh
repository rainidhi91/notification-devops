#!/bin/bash
set -e

echo "Creating Second DB for postgres.."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER u_notification_fe WITH PASSWORD 'MRGmBs6aE4zpZ7Sk';
    CREATE DATABASE notification_fe OWNER 'u_notification_fe';
    GRANT CONNECT ON DATABASE notification_fe TO u_notification_fe;
    GRANT USAGE ON SCHEMA public TO u_notification_fe;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO u_notification_fe;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO u_notification_fe;
    grant all privileges on database notification_fe to u_notification_fe;
EOSQL
echo "Second database is been created successfully.."

# grant all privileges on database <my_db> to <my_user>
# grant all privileges on all table in schema public to <my_user>
# grant all privileges on all relations in schema public to <my_user>