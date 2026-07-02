-- Q3
create or replace
    function seq(n integer) returns setof integer
as $$
begin
    -- 1. loop from 1 to n inclusive
    for i in 1..n loop
        -- 2. as we loop over, add the result to the result set
        return next i;
    end loop;
end;
$$ language plpgsql;

-- -- Q4
create or replace function seq(lo int, hi int, inc int) returns setof integer
as $$
declare
    i   integer := lo;
begin
    -- 1. split into the two cases
    if (inc > 0) then
        -- 2. increment from i to hi
        while (i <= hi) loop
            -- 3. add each value to the result set
            return next i;
            i := i + inc;
        end loop;
    elsif (inc < 0) then
        -- 4. same logic but decrement
        while (i <= hi) loop
            -- 3. add each value to the result set
            return next i;
            i := i - inc;
        end loop;
    end if;

    return;
end;
$$ language plpgsql;

-- -- Q5
create or replace function seq(n int) returns setof integer
as $$
    -- 1. query that function 
    select * from seq(1,n,1);
$$ language sql;