#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-'EOSQL'
    CREATE USER dex WITH ENCRYPTED PASSWORD 'dex';
    CREATE DATABASE dex;
    GRANT ALL PRIVILEGES ON DATABASE dex TO dex;
    CREATE ROLE "vault-edu" WITH LOGIN ENCRYPTED PASSWORD 'vault-edu';
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "vault-edu";
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-'EOSQL'
    CREATE TABLE books (
        id SERIAL PRIMARY KEY,
        author TEXT NOT NULL,
        name TEXT NOT NULL
    );
    INSERT INTO books (author, name)
    VALUES
        ('Goldratt E.', 'The Goal 1'),
        ('Goldratt E.', 'The Goal 2');
EOSQL
