# 24-59162-3-Login-System

##This is a C# Windows Forms application that manages user authentication. It allows new users to register and existing users to log into the system securely using a SQL Server database.

##Process of running the project

##------------------------------------------------------------------------------------------------------------------
##SQL part :
##I I made a new database by using the query : CREATE DATABASE db_users;
##For using the database I apply the second query : USE db_users;
##Then I created table. The query was : CREATE TABLE tbl_users (
    id       INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50)  NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL
); 
##Then insert a user by using the query : INSERT INTO tbl_users (username, password) VALUES ('admin', 'admin123');
##---------------------------------------------------------------------------------------------------------------------

##App configuration part
##We just have to change the data source if The SQL server is not LocalDB

##---------------------------------------------------------------------------------------------------------------------
## Test login part
## For tesing the system I use the username = admin, password = admin123 and it run successfully
##----------------------------------------------------------------------------------------------------------------------
##What I changed and reason behind it 
##Files modification :
##App.config: I defined a centralized connection string (connString) for SQL Server connectivity.

##frmLogin.cs: I refactored the database logic from OleDb to SqlClient and replaced insecure string concatenation with parameterized SQL commands.

##frmRegister.cs: I replaced the OleDb data access with SqlClient and implemented duplicate username verification alongside parameterized data insertion.

##frmDashboard.cs: I updated the btnLogout_Click handler to display a confirmation dialog, close the active dashboard session, and re-instantiate frmLogin.

##Program.cs: I updated the application startup entry point to launch frmLogin instead of frmRegister.

##database.sql: I added a SQL script to enable automated schema generation for the environment.

##Replacing OleDb with SqlClient & The Access Problem

##OleDb Removal: I completely stripped out using System.Data.OleDb; and replaced all those old OleDbConnection and OleDbCommand classes with SqlConnection and SqlCommand from System.Data.SqlClient.

##Architecture & Compatibility: I ditched MS Access mainly because it depends on those outdated 32-bit Jet drivers, which keep crashing on modern 64-bit systems.

##Concurrency & Scalability: I moved away from Access because it's just a file-based setup—it really struggles with multiple users and lacks proper thread safety or transaction handling.

##Enterprise Security: I switched to SQL Server so I can take advantage of real authentication, proper role management, and encrypted connections that are actually ready for production.

##Centralizing Connection Strings in App.config

##Maintainability & DRY Principle: I moved the database credentials out of individual form files like frmLogin.cs and frmRegister.cs because hardcoding them everywhere caused terrible code duplication. By centralizing the connection string in App.config, I can now just pull it into any form using ConfigurationManager.ConnectionStrings["connString"].

##Environment Portability: I set it up this way so that if I ever need to deploy the app to a new server or machine, I can just update a single XML value in App.config instead of rebuilding and recompiling the entire project

##Security: Purpose of @username and @password Parameters

##Preventing SQL Injection (SQLi): I realized that building queries with string concatenation—like "SELECT * FROM users WHERE user = '" + txtUser.Text + "'"—left the app completely wide open to attacks like ' OR '1'='1, which easily bypass authentication.

##Parameterized Execution: I fixed this by using parameters like @username and @password, which forces the database engine to treat whatever the user types as pure text data instead of executable SQL code.

##--------------------------------------------------------------------------------------------------------------------------


