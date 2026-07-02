-- Q14

create or replace function unitName(_ouid integer) returns text
as $$
declare 
    _ouname     text;
begin
    -- 1. error cases: is the orgunit id valid?
    select * into _ouname from OrgUnit where id = _ouid; 
    if (not found) then
        raise exception 'No such unit: %', _ouid;
    end if;

    -- 2. select from orgUnitType and orgunit
    select case 
        when t.name = 'University' then 'UNSW'
        when t.name = 'Faculty' then u.longname
        when t.name = 'School' then 'School of '||u.longname
        when t.name = 'Department' then 'Department of '||u.longname
        when t.name = 'Centre' then 'Centre for '||u.longname
        when t.name = 'Institute' then 'Institute of '||u.longname
        else null
        end into _ouname
    from orgunit u 
    join orgunittype t on u.utype = t.id 
    where u.id = _ouid;

    return _ouname;
end;
$$ language plpgsql;

-- Q16
create or replace function facultyOf(_ouid integer) returns integer
as $$
declare
    _count  integer;
    _tname  text;
    _parent integer;
begin
    -- 1. error handling
    select count(*) into _count 
    from orgunit where id = _ouid;

    if (_count = 0) then
        raise exception  'No such unit: %', _ouid;
    end if;

    -- 2. get the name of the org unit
    select t.name into _tname
    from orgunit u, orgunittype t 
    where u.id = _ouid and u_utype = t.id;

    -- 3. handle any edge cases 
    if (_tname is null) then
        return null;
    elsif (_tname =  'Univerisity') then
        return null; 
    elsif (_tname = 'Faculty') then
        return _ouid;
    else
        select owner into _parent
        from unitgroups 
        where member = _ouid;

        return facultyOf(_parent);
    end if;
end;
$$ language plpgsql;