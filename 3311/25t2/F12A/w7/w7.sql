-- Q1
create assertion manager_works_in_department
check (
    not exists (
        select * from Department as d 
        join Employee as e on d.manager = e.id
        where e.works_in <> d.id
    )
);

-- Q2
create assertion employee_manager_salary
check (
    not exists (
        select * from employee e 
        join Department d on (d.id = e.works_in)
        join employee m on d.manager = m.id 
        where e.salary > m.salary
    )
);

-- Q9
create or replace function emp_stamp() returns trigger
as $$
declare
begin
    if new.empname is null then
        raise exception 'empname cant be null :(';
    end if;

    if new.salary < 0  then
        raise exception 'salary has to be postive';
    end if;

    new.last_date := now();
    new.last_user := user();

    return new;
end;
$$ language plpgsql;

create trigger emp_stamp before insert or update on Emp
    for each row execute procedure emp_stamp();

-- Q10
/*
inserting this: Enrolment(COMP3311, 123, 40)

already have this:
Course(COMP3311, hadha, 40, 21);
Course(SENG3311, hadha, 40, 20);

*/

create or replace function insert_student() returns trigger
as $$
begin
    update course set numstudes = numstudes + 1 where code = new.code
    return new;  -- doesnt rly matter what it is since its for a after trigger....
end;
$$ language plpgsql;


create or replace function delete_student() returns trigger
as $$
begin
    update course set numstudes = numstudes - 1 where code = new.course;
    return new;  -- doesnt rly matter what it is since its for a after trigger....
end;
$$ language plpgsql;

create or replace function update_student() returns trigger
as $$
begin
    if new.course <> old.course then
        update course set numstudes = numstudes + 1 where code = new.course;
        update course set numstudes = numstudes - 1 where code = old.course;
    end if;
    return new;  -- doesnt rly matter what it is since its for a after trigger....
end;
$$ language plpgsql;

create or replace function quota() returns trigger
as $$
declare
    c   record
begin
    select numstudes, quota into c 
    from course 
    where code = new.course;

    if c.numstudes >= c.quota then
        raise exception 'Class % full', new course 
    end if;

    return new;
end;
$$ language plpgsql;


-- inserting a enrolment
create trigger insert_student after insert on enrolment
    for each row execute procedure insert_student();

-- deleting a enrolement
create trigger delete_student after delete on enrolment
    for each row execute procedure delete_student();

-- updating an enrolment
create trigger update_student after update on enrolment
    for each row execute procedure update_student();

-- handle checking quota
create trigger quota before insert or update on enrolment
    for each row execute procedure quota();

-- Q11
-- define my function
create or replace function new_shipment() returns trigger
as $$
declare
    cust_id     integer;
    book_isbn   integer;
    max_ship_id integer;
begin
    -- check valid id 
    select id into  cust_id from customers
    where id = new.customer;

    if not found then
        raise exception 'invalid customer id number';
    end if;

    -- check valid isbn
    select isbn into book_isbn from editions
    where isbn = new.isbn;

    if not found then
        raise exception 'invalid isbn';
    end if;

    if tg_op = 'insert' then
        update stock set numInStock = numInstock - 1 where isbn = new.isbn;
        update stock set numSold = numSold + 1 where isbn = new.isbn;
    else
        if new.isbn <> old.isbn then
            -- revert the stock for the old book
            update stock
            set numInStock = numInStock + 1;
                numSold = numSold - 1;
            where isbn = old.isbn;

            -- update stock for new book
            update stock
            set numInStock = numInStock - 1;
                numSold = numSold + 1;
            where isbn = new.isbn;
        end if;
    end if;

    -- calc max ship id
    select max(id) into max_ship_id
    from shipments
    order by id desc;

    new.id := max_ship_id + 1;
    new.ship_date := now();

    return new;
end;
$$ language plpgsql;


-- define trigger
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


-- aggregate definition
create aggregate mean(numeric) (
    stype       = StateType,
    sfunc       = sum_up,
    initcond    = '(0,0)',
    finalfunc   = divide
)
