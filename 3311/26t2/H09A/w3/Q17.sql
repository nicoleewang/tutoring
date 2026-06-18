
create table Departments (
    name        varchar(20) primary key,
    phone       integer,
    location    varchar(20),
    manager     integer
);

create table Employees (
    ssn         integer primary key,
    birthDate   date,
    name        varchar(20),
    worksFor    varchar(20) not null references Departments(name)
);

alter table Departments add
    foreign key (manager)
    references Employees(ssn);

