# SQL_1
Data Warehousing and ETL process.
---
A Data Warehousing (DWH) is a process for collecting and managing data from varied sources to provide meaningful business insights. A Data warehouse is typically used to connect and analyze business data from heterogeneous sources. The data warehouse is the core of the BI system which is built for data analysis and reporting.

---
## Exercise 00 - Classical DWH
(DataBase in Directory)

`User` table Definition:

| Column Name | Description |
| ------ | ------ |
| ID | Primary Key |
| name | Name of User |
| lastname | Last name of User |

`Currency` table Definition:

| Column Name | Description |
| ------ | ------ |
| ID | Primary Key |
| name | Currency Name |
| rate_to_usd | Ratio to USD currency |

`Balance` table Definition:

| Column Name | Description |
| ------ | ------ |
| user_id | “Virtual Foreign Key” to User table from other source |
| money | Amount of money |
| type | Type of balance (can be 0,1,...) |
| currency_id | “Virtual Foreign Key” to Currency table from other source |

I wrote a SQL query that returns the total amount (sum of all money) of transactions from a user's balance, aggregated by user and balance type. All data was processed, including data with anomalies.

---
## Exercise 01 - Detailed Query

Before deeper diving into this task was applied INSERTs statements below.

`insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');`

`insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');`

I wrote a SQL query that returns all users, all balance transactions (this task ignores currencies that do not have a key in the `Currency` table) with the currency name and the calculated value of the currency in USD for the next day.