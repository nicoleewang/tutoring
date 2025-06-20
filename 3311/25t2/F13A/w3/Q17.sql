create table Employees (
    SSN         integer,
    birthdate   date,
    name        text,
    primary key (SSN)
    -- add in foreign key to department later... 
);

create table Departments (
    name        text,
    phone       numeric(10),
    location    text,
    manager     integer not null unique,
    mDate       date,
    primary key (name),
    foreign key (manager) references Employees(SSN)
);

alter table Employees add
    foreign key (worksFor)
    references  Departments(name);

create table Dependents (
    name        text,
    employee    integer not null,
    birthdate   date,
    relation    text,
    primary key(name, employee),
    foreign key (employee) references Employees(SSN)
)

create table Projects (
    pNum        integer,
    title       text,
    primary key (pNum)
);

create table Participations (
    employee    integer,
    project     integer,
    time        integer,
    foreign key (employee) references Employees(ssn),
    foreign key (project) references Projects(pNum),
    primary key (employee, project)
);