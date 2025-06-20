create table Suppliers (
    name            text,
    city            text,
    primary key (name)
);

create table Parts (
    part_number     integer,
    colour          text,
    primary key (part_number)
);

create table Supplies (
    supplier        text,
    part            integer,
    quantity        integer,
    primary key (supplier, part),
    foreign key (supplier) references Suppliers(name),
    foreign key (part) references Parts(part_number),
);

