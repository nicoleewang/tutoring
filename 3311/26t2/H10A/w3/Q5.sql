-- a)
create table R (
    id      integer primary key,
    name    varchar(20),
    address varchar(20),
    d_o_b   date
);

create table R (
    id      integer,
    name    varchar(20),
    address varchar(20),
    d_o_b   date,
    primary key (id)
);


-- b)
create table S (
    name    varchar(20),
    address varchar(20),
    d_o_b   date,
    primary key (name, address)
);