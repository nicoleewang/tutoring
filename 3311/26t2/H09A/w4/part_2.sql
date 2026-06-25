-- Q12

select  distinct s.sid, s.sname
from    suppliers s
join    catalog c on (c.supplier = s.sid)
join    parts p on (c.part = p.pid)
where   p.colour = 'red';



-- Q13
select  distinct s.sid, s.sname
from    suppliers s
join    catalog c on (c.supplier = s.sid)
join    parts p on (c.part = p.pid)
where   p.colour = 'red' or p.colour = 'green';




-- Q15
-- method 1
(
    select s.sid, s.sname
    from catalog c 
    join parts p on (c.part = p.pid)
    join suppliers s on (s.sid = c.supplier)
    where p.colour = 'red'
) intersect (
    select s.sid, s.sname
    from catalog c 
    join parts p on (c.part = p.pid)
    join suppliers s on (s.sid = c.supplier)
    where p.colour = 'green'
);


-- method 2
select distinct s.sid, s.sname
from suppliers s 
join catalog c1 on c1.supplier = s.sid 
join parts p1 on p1.pid = c1.part and p1.colour = 'red'
join catalog c2 on c2.supplier = s.sid
join parts p2 on p2.pid =c2.part and p2.colour = 'green';


-- Q16
-- method 1
/*
1. find the set of all part ids
2. find the set of all part ids supplied by the supplier 
3. find the set difference beteen the two
4. if that set is empty that means that supplier supplies every part
*/
select sid, sname
from suppliers s
where not exists (
    (select p.pid from Parts p) 
    except
    (select c.part from catalog c where c.supplier = s.sid)
);

-- method 2
select sid, sname
from    catalog c 
join        suppliers s on (s.sid = c.supplier)
group by    s.sid, s.sname 
having      count(distinct c.part) = (select count(*) from parts);




-- Q17
-- method 1 
select sid, sname
from suppliers s
where not exists (
    (select p.pid from Parts p where p.colour = 'red') 
    except
    (select c.part from catalog c where c.supplier = s.sid)
);

-- method 2
select sid, sname
from        catalog c 
join        parts p on (c.part = p.pid)
join        suppliers s on (s.sid = c.supplier)
where       p.colour = 'red'
group by    s.sid, s.sname 
having      count(distinct c.part) = (select count(*) from parts where colour = 'red');




-- Q19
-- method 1
(
    -- suppliers who supply every red part
    select sid, sname
    from        catalog c 
    join        parts p on (c.part = p.pid)
    join        suppliers s on (s.sid = c.supplier)
    where       p.colour = 'red'
    group by    s.sid, s.sname 
    having      count(distinct c.part) = (select count(*) from parts where colour = 'red')
) union (
    -- suppliers who supply every green part 
    select sid, sname
    from        catalog c 
    join        parts p on (c.part = p.pid)
    join        suppliers s on (s.sid = c.supplier)
    where       p.colour = 'green'
    group by    s.sid, s.sname 
    having      count(distinct c.part) = (select count(*) from parts where colour = 'green');
);


-- method 2
(
    -- suppliers who supply every red part
    select distinct sid, sname
    from suppliers s
    where not exists (
        (select p.pid from Parts p where p.colour = 'red') 
        except
        (select c.part from catalog c where c.supplier = s.sid)
    )
) union (
    -- suppliers who supply every green part 
    select distinct sid, sname
    from suppliers s
    where not exists (
        (select p.pid from Parts p where p.colour = 'green') 
        except
        (select c.part from catalog c where c.supplier = s.sid)
    )
);



-- Q21

-- Q22
select p.pid, p.pname
from catalog c 
join suppliers s on (c.supplier = s.sid)
join parts p on (c.part = p.pid)
where s.sname = 'Yosemite Sham' 
      and c.cost >= (
        select max(c2.cost)
        from catalog c2 
        join suppliers s2 on (c2.supplier = s2.sid)
        where s2.sname = 'Yosemite Sham' and c2.supplier = s2.sid
      )
order by p.pid;