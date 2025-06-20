-- a)
create table R (
    id      integer,
    name    text,
    address text,
    d_o_b   date,
    primary key (id)
);

-- b)
create table S (
    name    text,
    address text,
    d_o_b   date,
    primary key (name, address)
);