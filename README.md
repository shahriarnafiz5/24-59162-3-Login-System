# 24-59162-3-Login-System

A C# Windows Forms application that manages user authentication. It allows new users to **register** and existing users to **log into** the system securely using a SQL Server database.

---

## 📋 Table of Contents

- [Project Setup](#project-setup)
  - [1. SQL Server Setup](#1-sql-server-setup)
  - [2. App Configuration](#2-app-configuration)
  - [3. Test Login](#3-test-login)
- [What Was Changed and Why](#what-was-changed-and-why)
  - [Files Modified](#files-modified)
  - [Replacing OleDb with SqlClient](#replacing-oledb-with-sqlclient--the-access-problem)
  - [Centralizing Connection Strings](#centralizing-connection-strings-in-appconfig)
  - [Security: Parameterized Queries](#security-preventing-sql-injection)

---

## Project Setup

### 1. SQL Server Setup

Run the following queries in order:

```sql
-- Step 1: Create the database
CREATE DATABASE db_users;

-- Step 2: Use the database
USE db_users;

-- Step 3: Create the users table
CREATE TABLE tbl_users (
    id       INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50)  NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL
);

-- Step 4: Insert a test user
INSERT INTO tbl_users (username, password) VALUES ('admin', 'admin123');
```

### 2. App Configuration

If your SQL Server is **not** LocalDB, update the `Data Source` value in `App.config` to match your SQL Server instance.

### 3. Test Login

The system was tested with the following credentials and ran successfully:

| Field    | Value      |
|----------|------------|
| Username | `admin`    |
| Password | `admin123` |

---

## What Was Changed and Why

### Files Modified

| File | Change |
|------|--------|
| `App.config` | Defined a centralized connection string (`connString`) for SQL Server connectivity. |
| `frmLogin.cs` | Refactored database logic from `OleDb` to `SqlClient` and replaced insecure string concatenation with parameterized SQL commands. |
| `frmRegister.cs` | Replaced `OleDb` data access with `SqlClient` and implemented duplicate username verification alongside parameterized data insertion. |
| `frmDashboard.cs` | Updated the `btnLogout_Click` handler to display a confirmation dialog, close the active dashboard session, and re-instantiate `frmLogin`. |
| `Program.cs` | Updated the application startup entry point to launch `frmLogin` instead of `frmRegister`. |
| `database.sql` | Added a SQL script to enable automated schema generation for the environment. |

---

### Replacing OleDb with SqlClient & The Access Problem

1. **OleDb Removal** — Completely stripped out `using System.Data.OleDb;` and replaced all `OleDbConnection` / `OleDbCommand` classes with `SqlConnection` / `SqlCommand` from `System.Data.SqlClient`.

2. **Architecture & Compatibility** — Moved away from MS Access because it depends on outdated 32-bit Jet drivers, which frequently crash on modern 64-bit systems.

3. **Concurrency & Scalability** — Access is a file-based system that struggles with multiple users and lacks proper thread safety or transaction handling.

4. **Enterprise Security** — Switched to SQL Server to take advantage of real authentication, proper role management, and encrypted connections suitable for production.

---

### Centralizing Connection Strings in App.config

1. **Maintainability & DRY Principle** — Database credentials were moved out of individual form files (`frmLogin.cs`, `frmRegister.cs`) to avoid code duplication. The connection string is now centralized in `App.config` and pulled into any form via:

   ```csharp
   ConfigurationManager.ConnectionStrings["connString"]
   ```

2. **Environment Portability** — When deploying to a new server or machine, only a single XML value in `App.config` needs to be updated — no rebuilding or recompiling required.

---

### Security: Preventing SQL Injection

1. **The Problem** — Building queries with string concatenation, such as:

   ```csharp
   "SELECT * FROM users WHERE user = '" + txtUser.Text + "'"
   ```

   leaves the application wide open to attacks like `' OR '1'='1`, which can easily bypass authentication.

2. **The Fix** — Parameterized queries using `@username` and `@password` force the database engine to treat user input as pure data, not executable SQL code:

   ```csharp
   cmd.Parameters.AddWithValue("@username", txtUser.Text);
   cmd.Parameters.AddWithValue("@password", txtPass.Text);
   ```

---

