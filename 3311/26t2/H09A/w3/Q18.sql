-- ER design
create table People (
    ssn         integer primary key,
    name        varchar(50) not null,
    address     varchar(100),
);

create table Patients (
    ssn         integer primary key,
    birthdate   date,
    foreign key (ssn) references Person(ssn)
);

create table Doctors (
    ssn         integer primary key,
    yearsExp    integer,
    foreign key (ssn) references Person(ssn)
);

create table Specialties (
    doctor      integer,
    speciality  varchar(20),
    primary key (doctor, speciality),
    foreign key (doctor) references Doctors(ssn) 
);

create table Pharmacists (
    ssn         integer primary key,
    qual        varchar(50),
    foreign key (ssn) references Person(ssn)
);

-- single table with nulls
create table People (
    ssn             integer primary key,
    name            varchar(50) not null,
    address         varchar(50),

    -- a person can belong to any of these subclasses
    isPatient       boolean not null default false,
    isDoctor        boolean not null default false,
    isPharmacist    boolean not null default false,

    -- patient-specific attrbiutes
    birthdate       date,

    -- doctor-specific attributes
    yearsExp        integer,

    -- pharmacist-specific attributes
    qual            varchar(30),

    check (isPatient = false and birthdate is null),
    check (isDoctor = false and yearsExp is null),
    check (isPharmcist = false and qual is null),
    check (isPatient or isDoctor or isPharmcist)
);

create table Specialties (
    doctor      integer,
    speciality  varchar(20),
    primary key (doctor, speciality),
    foreign key (doctor) references People(ssn) 
);