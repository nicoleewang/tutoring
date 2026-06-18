create table people (
    licenseNo       integer primary key,
    name            varchar(20),
    address         varchar(20)
);

create table cars (
    regoNo          integer primary key,
    model           varchar(20),
    year            integer
);

create table accidents (
    reportNo        integer primary key,
    date            date,
    location        varchar(20)
);

create table owns (
    regoNo          integer,
    licenseNo       integer,
    primary key (regoNo, licenseNo),
    foreign key (regoNo) references cars(regoNo),
    foreign key (licenseNo) references people(licenseNo)
);

create table involved (
    regoNo          integer,
    licenseNo       integer,
    reportNo        integer,
    damage          money,
    primary key (regoNo, licenseNo, reportNo),
    foreign key (regoNo) references cars(regoNo),
    foreign key (licenseNo) references people(licenseNo),
    foreign key (reportNo) references accidents(reportNo)
);

