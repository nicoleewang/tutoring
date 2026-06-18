-- ER design
create table People (
    ssn         integer primary key,
    name        varchar(20) not null,
    address     varchar(20)
);

create table Patients (
    ssn         integer primary key,
    birthdate   date,
    foreign key (ssn) references People(ssn)
);

create table Doctors (
    ssn         integer primary key,
    yearsExp    integer,
    foreign key (ssn) references People(ssn)
);

create table Specialties (
    doctor      integer,
    specialty   varchar(20),
    primary key (doctor, specialty),
    foreign key (doctor) references Doctors(ssn)
);

create table Pharmacists (
    ssn         integer primary key,
    qual        varchar(30),
    foreign key (ssn) references People(ssn)
);


-- single table with nulls
create table People (
    ssn         integer primary key,
    name        varchar(20),
    address     varchar(20),

    isPatient   boolean not null default false,
    isDoctor    boolean not null default false,
    isPharmcist boolean not null default false,

    -- patient-specific
    birthDate   date,

    -- doctor-specific
    yearsExp    integer,

    -- pharm-specific
    qual        varchar(20),

    check (isPatient = false and birthdate is null),
    check (isDoctor = false and yearsExp is null),
    check (isPharmcist = false and qual is null),
    check (isPatient or isDoctor or isPharmcist)

);

create table Specialties (
    doctor      integer,
    specialty   varchar(20),
    primary key (doctor, specialty),
    foreign key (doctor) references People(ssn)
);