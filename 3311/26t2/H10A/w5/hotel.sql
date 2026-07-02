-- Q7
create or replace function
    hotelsIn(_addr text) returns text
as $$
declare 
    r   record;
    out text := '';
begin
    -- 1. find all the bars with the given ddress and loop over it
    for r in select * from bars where addr = _addr
    loop 
        -- 2. concantenate all the names into a single result
        out := out ||  r.name || e'\n';
    end loop;

    return out;
end;
$$ language plpgsql;

-- Q8

create or replace function
    hotelsIn (_addr text) returns text
as $$
declare
    howmany     integer;
    pubnames    text;
    p           record;
begin
    -- 1. handle edge case of no hotels
    select count(*)
    into howmany
    from Bars 
    where addr = _addr;

    if (howmany = 0) then 
        return 'There are no hotels in ' || _addr || e'\n';
    end if;

    pubnames := 'Hotels in  ' || _addr || ':';

    -- 2. loop over all the bars, filtered by the address

    for p in select * from Bars where addr = _addr
    loop
        pubnames := pubnames || ' ' || p.name;
    end loop;

    pubnames := pubnames || e'\n';

    return pubnames;
end;
$$ language plpgsql;