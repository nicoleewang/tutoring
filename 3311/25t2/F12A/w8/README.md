
# Today: Python/Psycopg2

## Reminders

- quiz due tn!!
- assignment 2 spec is out (due week 10 mon)

---

## psycopg2 Overview

- `psycopg2` is a Python module that provides access to postgres databases.
- commonly used to execute SQL queries from within Python programs.

---

## Typical Usage

```python
import psycopg2

connection = None
try:
    connection = psycopg2.connect("dbname=Database")  # Establish connection
    cursor = connection.cursor()                      # Create a cursor object
    cursor.execute("SQL Query")                       # Execute a SQL query

    for row in cursor.fetchall():
        # Process each row
        pass

    cursor.close()  # Close cursor
except:
    print("Database error")
finally:
    if connection:
        connection.close()  # Always close the connection
```

---

- connection
    - Establishes authenticated access to the database.
    - Required to communicate with the PostgreSQL server.
    - Takes in other parameters like user, password etc… but you’ll always have dbname

---

- cursor
    - Acts as a communication pipeline between your Python program and the PostgreSQL database.
    - Used to:
        - **Execute SQL statements** (e.g. `.execute()`)
        - **Retrieve query results**:
            - `.fetchall()` to get all rows
            - `.fetchone()` to get the next row (in top-down order)

---

## When to Use Python or SQL???

- **Use SQL for data-heavy logic**:
  - Perform filtering, joining, and aggregation within SQL queries for performance and clarity.
- **Use Python for complex processing**:
  - Handle more complicated logic and formatting results.

> pls don’t load ur whole database into a list in python and try to filter out what you wanna find… databases are optimised for this kinda stuff!!

---

## Using Variables in Queries

You can include variables in SQL using parameterised queries:

```python
cursor.execute("SELECT * FROM table WHERE id = %s", (some_id,))
```

- even if u have one variable, make sure you write it as a tuple
