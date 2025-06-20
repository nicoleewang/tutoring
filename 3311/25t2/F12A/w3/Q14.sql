create table Cars (
    rego_num    text,
    model       text,
    year        integer,
    primary key (rego_num)
);

create table People (
    licence_num integer,
    name        text,
    address     text,
    primary key (licence_num)
);

create table Accidents (
    report_num  integer,
    location    text,
    date        date,
    primary key (report_num)
);

create table Owns (
    licence_num integer,
    rego_num    text,
    primary key (licence_num, rego_num),
    foreign key (licence_num) references People(licence_num),
    foreign key (rego_num) references Cars(rego_num)
);

create table Involved (
    licence_num integer,
    rego_num    text,
    report_num  integer,
    damage      money,
    primary key (licence_num, rego_num, report_num),
    foreign key (licence_num) references People(licence_num),
    foreign key (rego_num) references Cars(rego_num),
    foreign key (report_num) references Accidents(report_num)
);