-- Q1
create assertion manager_works_in_department
check  (
    not exists (
        select * from department as d
        join employee as e on d.manager = e.id 
        where e.works_in <> d.id
    )
);

-- Q2
create assertion employee_manager_salary
check (
    not exists (
        select * from employees as e
        join department d on d.id = e.workin 
        join employee m on d.manager = m.id
        where e.salary > m.salary
    )
);

-- Q8
-- circular dependency: gonna be stuck in a loop forever :(

-- Q9
create or replace function emp_stamp() returns trigger
as $$
declare
begin
    if new.empname is null then
        raise exception 'emp name cant be null';
    end if;
    if new.salary < 0 then
        raise exception 'salary has to be positive >:(';
    end if;

    new.last_date := now();
    new.last_user := user();

    return new;
end;
$$ language plpgsql;

create trigger emp_stamp before insert or update on Emp 
    for each row execute procedure emp_stamp();

-- can do this now: insert into emp value ('John', 4000)

-- Q10
create or replace function insert_student() returns trigger
as $$
begin
    update course set numStudes = numStudes + 1 where code = new.course;
    return new; -- doesnt rly matter what this is bc its a after trigger function
end;
$$ language plpgsql;

create or replace function delete_student() returns trigger
as $$
begin
    update course set numStudes = numStudes - 1 where code = new.course;
    return old; -- doesnt rly matter what this is bc its a after trigger function
end;
$$ language plpgsql;

create or replace function update_student() returns trigger
as $$
begin
    if new.course <> old.course then 
        update course set numStudes = numStudes + 1 where code = new.course;
        update course set numStudes = numStudes - 1 where code = old.course;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace function quota() returns trigger
as $$
declare
    c   record;
begin
    select numStudes, quota into c
    from course
    where code = new.course;

    if c.numStudes >= c.quota then
        raise exception 'class % is full', new.course;
    end if;

    return new;
end;
$$ language plpgsql;


-- insert enrolment
create trigger insert_student after insert on enrolment
    for each row execute procedure insert_student();

-- delete enrolment
create trigger delete_student after delete on enrolment
    for each row execute procedure delete_student();

-- update enrolment
create trigger updating_student after update on enrolment
    for each row execute procedure update_student();

-- check quota
create trigger quota before insert or update on enrolment
    for each row execute procedure quota();

-- Q11

create or replace function new_shipment() returns trigger
as $$
declare
    cust_id     integer;
    book_isbn   integer;
    max_id      integer;
begin
    -- check cust id
    select id into cust_id from customers
    where id = new.customer;

    if not found then
        raise excpetion 'invalid customer id';
    end if;

    -- check valid isbn
    select isbn into  book_isbn from editions
    where isbn = new.isbn;

    if not found then
        raise exception 'invalid isbn';
    end if;

    if tg_op = 'insert' then
        update stock set numInStock = numInStock - 1 where isbn = new.isbn;
        update stock set numSold = numSold + 1 where isbn = new.isbn;
    else
        if new.isbn <> old.isbn then
            -- revert stock for old book
            update stock
            set numInStock = numInStock + 1,
                numSold = numSold - 1
            where isbn = old.isbn;

            -- update stock for the new book
            update stock
            set numInStock = numInStock - 1,
                numSold = numSold + 1
            where isbn = new.isbn;
        end if;
    end if;
    
    -- getting max
    select max(id) into max_id
    from shipments
    order by id desc;

    new.id := max_id + 1;
    new.ship_date := now();
    
    return new;
end;
$$ language plpgsql;


create trigger new_shipment before insert or update on shipments 
    for each row execute procedure new_shipment();

-- Q14
create type StateType as (sum numeric, count numeric);

create or replace function sum_up(s StateType, v numeric) returns StateType
as $$
declare
begin
    if v is not null then
        s.sum := s.sum + v;
        s.count := s.count + 1;
    end if;
    return s;
end;
$$ language plpgsql;

create or replace function divide(s StateType) returns numeric
as $$
begin
    if s.count = 0 then
        return null;
    else 
        return s.sum / s.count;
    end if;
end;
$$ language plpgsql;


create aggregate mean(numeric) (
    sfunc       = sum_up,
    stype       = StateType,
    initcond    = '(0,0)',
    finalfunc   = divide
);
