-- Q1
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

-- Q2
create or replace function spread(txt text) returns text
as $$
declare
    i       integer;
    result  text := '';
begin
    for i in 1 .. length(txt) loop
        result := result || substr(txt, i, 1) || ' ';
    end loop;
    return result;
end;
$$ language plpgsql;

-- Q3
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

-- Q4
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

-- Q7
create or replace function hotelsIn(_addr text) returns text
as $$
declare
    h       record;
    result  text := '';
begin
    for h in (select * from bars where addr = _addr) loop
        result := result || h.name || e'\n';
    end loop;
    return result;
end;
$$ language plpgsql;

-- Q8
create or replace function hotelsIn(_addr text) returns text
as $$
declare
    howMany integer;
    h       record;
    hotels  text;
begin
    select count(*) into howMany from Bars where addr = _addr;

    if (howMany = 0) then
        return 'There are no hotels in ' || _addr || e'\n';
    end if;

    hotels := 'Hotels in ' || _addr || ':';
    for h in (select * from Bars where addr = _addr) loop
        hotels := hotels || ' ' || h.name;
    end loop;
    return hotels;
end;
$$ language plpgsql;

-- Q9 
create or replace function happyHourPrice(hotel_name text, beer_name text, dollars real) returns text
as $$
declare
    counter     integer;
    beer_price  real;
    new_price   real;
    res         record;
begin
    select count(*) into counter from Bars where name = hotel_name;

    if (counter = 0) then
        return 'There is no hotel called ' || hotel_name || e'\n';
    end if;

    select * into res from Beers where name = beer_name;

    if (not found) then
        return 'There is no beer called ' || beer_name || e'\n';
    end if;

    select price into beer_price
    from sells s
    where s.beer = beer_name and s.bar = hotel_name;

    if (not found) then
        return 'The ' || hotel_name || ' does not serve ' || beer_name || e'\n';
    end if;

    new_price := beer_price - dollars;
    if (new_price < 0) then
        return 'Price reduction is too large; ' || beer_name || ' only costs ' || to_char(beer_price,'$9.99');
    else
        return 'Happy hour price for ' || beer_name || ' at ' || hotel_name || ' is ' || to_char(new_price,'$9.99');
    end if;
end;
$$ language plpgsql;

-- Q10
create or replace function hotelsIn(text) returns setof Bars
as $$
    select * from Bars where addr = $1;
$$ language sql;

-- Q12
-- a)
-- sql version 

create or replace function empSal(emp_id integer) returns real
as $$
    select salary from employees where id = emp_id;
$$ language sql;

-- plpgsql version
create or replace function empSal(emp_id integer) returns real
as $$
declare
    emp_sal real;
begin
    select salary into emp_sal 
    from employees where id = emp_id;

    return emp_sal;
end;
$$ language plpgsql;

-- b)
-- sql version
create or replace function bankDetails(branch_location text) returns Branches
as $$
    select * from Branch where location = branch_location;
$$ language sql;

-- plpgsql version
create or replace function bankDetails(branch_location text) returns Branches
as $$
declare
    result  Branches;
begin
    select * into result from Branch where location = branch_location;
    return result;
end;
$$ language plpgsql;

-- Q13)
create or replace function branchList() returns text
as $$
declare
    b       record;
    h       record;
    result  text := '';
    total   real := 0;
begin
    for b in (select * from Branches) loop
        result := result || 'Branch: ' || b.location || ', ' || b.address || e'\n';
        result := result || 'Customers: ';

        for h in (select * from Accounts where branch = b.location) loop
            result := result || h.holder || ' ';
            total := total + h.balance;
        end loop;
        result := result || e'\n';
        result := result || 'Total deposits: ' || to_char(total, '$999999.99');
        result := result || e'\n---\n';
    end loop;
    return result;
end;
$$ language plpgsql;