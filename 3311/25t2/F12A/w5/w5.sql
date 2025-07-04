-- Q1) 
create or replace function sqr(n integer) returns integer
as $$
begin
    return n * n;
end;
$$ language plpgsql;


create or replace function sqr(n numeric) returns numeric
as $$
begin
    return n * n;
end;
$$ language plpgsql;

-- Q2)
-- using a while loop
create or replace function spread(txt text) returns text
as $$
declare
    i       integer := 1;
    result  text := '';
begin
    while (i <= length(txt)) loop
        result := result || substr(txt, i, 1) || ' ';
        i := i + 1;
    end loop;
    return result;
end;
$$ language plpgsql;

-- using a for loop
create or replace function spread(txt text) returns text
as $$
declare
    i       integer;
    result  text := '';
begin
    for i in 1..length(txt) loop
        result := result || substr(txt, i, 1) || ' ';
        i := i + 1;
    end loop;
    return result;
end;
$$ language plpgsql;

-- Q3)
create or replace function seq(n integer) returns setof integer
as $$
declare
    i   integer;
begin
    for i in 1 .. n loop
        return next i;
    end loop;
end;
$$ language plpgsql; 

-- Q4)
create or replace function seq(lo int, hi int, inc int) returns setof integer
as $$
declare
    i   integer := lo;
begin
    if (inc > 0) then
        while (i <= hi) loop
            return next i;
            i := i + inc;
        end loop;
    elsif (inc < 0) then
         while (i >= hi) loop
            return next i;
            i := i + inc;
        end loop;
    end if;
end;
$$ language plpgsql;

-- Q5) 
create or replace function seq(n integer) returns setof integer
as $$
    select * from seq(1, n, 1);
$$ language sql;

-- Q7)
create function hotelsIn(_addr text) returns text
as $$
declare
    r       record;
    result  text := '';
begin
    for r in select * from bars where addr = _addr loop
        result := result || r.name || e'\n';
    end loop;
    return result;
end;
$$ language plpgsql;

-- Q8)
create or replace function hotelsIn(_addr text) returns text
as $$
declare
    howMany     integer;
    pubnames    text;
    r           record;
begin
    select count(*) into howMany from Bars where addr = _addr;
    if (howMany = 0) then
        return 'There are no hotels in ' || _addr || e'\n';
    end if;

    pubnames := 'Hotels in ' || _addr || ':';
    
    for r in select * from bars where addr = _addr loop
        pubnames := pubnames || ' ' || r.name;
    end loop;
    pubnames := pubnames || e'\n';
    return pubnames;
end;
$$ language plpgsql;


-- Q9)
create function happyHourPrice(hotel_name text, beer_name text, dollars real) returns text
as $$
declare
    counter     integer;
    beer_price  real;
    new_price   real;
begin
    select count(*) into counter from bars where name = hotel_name;

    if (counter = 0) then
        return 'There is no hotel called ' || hotel_name || e'\n';
    end if;

    select * from Beers where name = beer_name;

    if (not found) then
        return 'There is no beer called ' || beer_name || e'\n';
    end if;

    select price into beer_price
    from Sells s 
    where s.beer = beer_name and s.bar = hotel_name;

    if (not found) then
        return "The " || hotel_name || ' does not serve ' || beer_name || e'\n';
    end if;

    new_price := beer_price - dollars;
    if (new_price < 0) then
        return 'Price reduction is too large; ' || beer_name || ' only costs ' || to_char(beer_price,'$9.99');
    else
        return 'Happy hour price for ' || beer_name || ' at ' || hotel_name || ' is ' || to_char(new_price,'$9.99');
    end if;
end;
$$ language plpgsql;


-- Q10)
create or replace function hotelsIn(hotel_address text) returns setof Bars
as $$
    select * from Bars where addr = hotel_address;
$$ language sql;

-- Q12)
-- a)
-- sql version
create or replace function empSal(emp_id integer) returns real
as $$
    select salary from employees where id = emp_id;
$$ language sql;

-- plpgsql versrion
create or replace function empSal(emp_id integer) returns real
as $$
declare
    emp_sal real;
begin
    select salary into emp_sal from employees where id = emp_id;
    return emp_sal;
end;
$$ language plpgsql;

-- b)
-- sql version
create or replace function bankDetails(branch_location text) returns Branches
as $$
    select * from Branches where location = branch_location;
$$ language sql;

-- plpgsql version
create or replace function bankDetails(branch_location text) returns Branches
as $$
declare
    branch  Branches;
begin
    select * into branch from Branches where location = branch_location;
    return branch;
end;
$$ language plpgsql;

-- c)
-- sql version
create or replace function earnMoreSal(sal real) returns setof text
as $$
    select name from employees where salary > sal;
$$ language sql;


-- Q13)
-- note: when formatting numbers use to_char() and when u do this you have to use 9
create or replace function branchList() returns text
as $$
declare
    result text := '';
    total real := 0;
    b record;
    h record;
begin
    for b in (select * from Branches) loop
         -- 1. format branches
        result := result || 'Branch: ' || b.location || ', ' || b.address || e'\n';
        result := result || 'Customers: ';

        -- 2. format customers and total
        for h in (select * from Accounts where branch = b.location) loop
            result := result || h.holder || ' ';
            total := total + h.balance;
        end loop;
        result := result || e'\n';
        result := result || 'Total Deposits: ' || to_char(total,'$999999.99');
        result := result || e'\n---\n';
    end loop;
    return result;
end;
$$ language plpgsql;

