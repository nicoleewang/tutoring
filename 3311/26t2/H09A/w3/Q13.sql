create table Suppliers (
    name        varchar(50),
    city        varchar(50),
    primary key (name)
);

create table Parts (
    number      integer,
    colour      varchar(20),
    primary key (number)
);

create table Supplies (
    suppliers   varchar(50),
    part        integer,
    quantity    integer,
    primary key (suppliers, part),
    foreign key (supplier) references Supplier(name),
    foreign key (part) references Part(number)
);