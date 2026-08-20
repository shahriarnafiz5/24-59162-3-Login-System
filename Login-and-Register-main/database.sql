CREATE DATABASE db_users;
USE db_users;
CREATE TABLE tbl_users (
    id       INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50)  NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL
);
INSERT INTO tbl_users (username, password) VALUES ('admin', 'admin123');

