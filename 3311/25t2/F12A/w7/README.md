# Today: Constraints, Triggers and Aggregates

- Constraints we've seen so far: `NOT NULL`, `UNIQUE`, `CHECK`
- We may require more complex constraints (constraints involving multiple tables) -> schema level constraints
    - We saw this in week 4…

## Assertions

- Used to define **schema-level constraints**
- Designed for **global**, **cross-table**, or **multi-row** conditions
    - e.g. *Sum of all account balances in a bank must be ≥ 0*
- Automatically **checked after any modification** to involved tables
    - Expensive: need to unnecessarily re-evaluate large sets of data
- *Note: PostgreSQL (and most RDBMS) doesn't support assertions*
    - is defined in the SQL standard only
- Syntax

    ```sql
    CREATE ASSERTION assertion_name
    CHECK (
        <boolean condition involving one or more tables>
    );
    ```

## Triggers

- A **stored procedure** that runs **automatically** in response to:
    - `INSERT`, `UPDATE`, or `DELETE` events
- Triggers provide **custom, procedural logic** to:
    - Enforce or maintain constraints (e.g. prevent negative balances)
    - Perform side effects (e.g. audit logs, update timestamps)
- Key features:
    - Can be set to run:
        - `BEFORE` or `AFTER` the triggering event
        - `FOR EACH ROW` or `FOR EACH STATEMENT`
    - Access special variables inside trigger function:
        - `NEW` – the new row
        - `OLD` – the old row (before update/delete)
        - `TG_OP` – type of operation (`INSERT`, `UPDATE`, etc.)
    - If an exception is raised by a trigger: **ROLLBACK** changes
- Sequence of activities during db update: BEFORE triggers -> standard DB contraint checking -> AFTER triggers
- Syntax

    ```sql
    -- Trigger function
    CREATE OR REPLACE FUNCTION function_name()
    RETURNS trigger AS $$
    BEGIN
        -- logic using NEW, OLD
        RETURN NEW; -- or RETURN NULL or RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    -- Trigger definition
    CREATE TRIGGER trigger_name
    { BEFORE | AFTER }
    { INSERT | UPDATE | DELETE } ON table_name
    [ FOR EACH ROW | FOR EACH STATEMENT ]
    EXECUTE PROCEDURE function_name();

    -- Drop trigger
    DROP TRIGGER trigger_name ON table_name;
    ```

## Aggregates

- Reduce a set of values into a single value
- Examples we've seen: `MAX()`, `MIN()`, `COUNT()`, `STRING_AGG()`, often used in conjunction with `GROUP BY`
- Can define your own aggregate
    - Achieved using a state + state transition function
    - (Optional) a **final function** to process the state before returning the result
- Syntax

    ```sql
    -- Transition function
    CREATE FUNCTION transition_function(state_type, input_type)
    RETURNS state_type AS $$
    BEGIN
        -- return updated state
    END;
    $$ LANGUAGE plpgsql;

    -- Optional final function
    CREATE FUNCTION final_function(state_type)
    RETURNS result_type AS $$
    BEGIN
        -- return final result
    END;
    $$ LANGUAGE plpgsql;

    -- Aggregate definition
    CREATE AGGREGATE aggregate_name(input_type) (
        SFUNC     = transition_function,      -- called for each input row
        STYPE     = state_data_type,          -- type of the internal state
        [FINALFUNC = final_function,]         -- optional: transforms final state to result
        [INITCOND  = initial_state_value]     -- optional: initial state value
    );
    ```
- Equivalent to something like this...
    ```python
        S = initcond
        for row in relation_R:      # could be an entire row, could be a single column from a row
            S = sfunc(S, row)
        return finalfunc(S)
    ```
