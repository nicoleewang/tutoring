create table Cars (
    rego_num        integer,
    model           text,
    year            integer,
    primary key (rego_num)
);

create table People (
    licence_num     integer,
    name            text,
    address         text,
    primary key (licence_num)
);

create table Accidents (
    report_num      integer,
    location        text,
    date            date,
    primary key (report_num)
);

create table Owns (
    licence_num     integer references People(licence_num),
    rego_num        integer references Car(rego_num),
    primary key (licence_num, rego_num)
);

create table Involves (
    licence_num     integer references People(licence_num),
    rego_num        integer references Car(rego_num),
    report_num      integer references Accidents(report_num),
    damage          money,
    primary key (licence_num, rego_num, rego_num)
);
