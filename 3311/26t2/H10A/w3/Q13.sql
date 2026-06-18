create table Suppliers (
    name        varchar(50) primary key,
    city        varchar(50)
);

create table Parts (
    number      integer primary key,
    colour      varchar(50)
);

create table Supplies (
    supplier    varchar(50),
    part        integer,
    quantity    integer,
    primary key (supplier, part),
    foreign key (supplier) references Suppliers(name),
    foreign key (part) references Parts(number) 
);