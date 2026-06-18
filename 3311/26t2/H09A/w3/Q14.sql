create table people (
    licenseNo   integer primary key,
    name        varchar(40),
    address     varchar(40)
);

create table cars (
    regoNo      integer primary key,
    model       varchar(40),
    year        integer
);

create table accidents (
    reportNo    integer primary key,
    location    varchar(40),
    date        date,
);

create table owns (
    regoNo      integer,
    licenseNo   integer,
    primary key (regoNo, licenseNo),
    foreign key (regoNo) references cars(regoNo),
    foreign key (licenseNo) references people(licenseNo),
);

create table involved (
    regoNo      integer,
    licenseNo   integer,
    reportNo    integer,
    damage      money,
    primary key (regoNo, licenseNo, reportNo),
    foreign key (regoNo) references cars(regoNo),
    foreign key (licenseNo) references people(licenseNo),
    foreign key (reportNo) references accidents(reportNo)
);
