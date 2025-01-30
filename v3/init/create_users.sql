-- Create the databases
CREATE DATABASE db1;
CREATE DATABASE db2;

-- Create the users with static passwords
CREATE USER user1 WITH PASSWORD 'staticpassword1';
CREATE USER user2 WITH PASSWORD 'staticpassword2';

-- Grant ownership of databases
GRANT ALL PRIVILEGES ON DATABASE db1 TO user1;
GRANT ALL PRIVILEGES ON DATABASE db2 TO user2;