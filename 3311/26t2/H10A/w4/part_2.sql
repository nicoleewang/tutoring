-- Q12
/*
Find the sids and snames of suppliers who supply some red part.
*/

select  distinct s.sid, s.sname
from    suppliers s 
join    catalog c on (c.supplier = s.sid)
join    parts p on (c.part = p.pid)
where   p.colour = 'red';


-- Q13
/*
Find the sids and snames of suppliers who supply some red or 
green part.
*/
select  distinct s.sid, s.sname
from    suppliers s 
join    catalog c on (c.supplier = s.sid)
join    parts p on (c.part = p.pid)
where   p.colour = 'red' or p.colour = 'green';


-- Q15
/*
Find the sids and snames of suppliers who supply some red part 
and some green part.
*/

-- method 1
(
    select  s.sid, s.sname
    from    catalog c 
    join    parts p on (c.part = p.pid)
    join    suppliers s on (s.sid = c.supplier)
    where   p.colour = 'red'
) intersect (
    select  s.sid, s.sname
    from    catalog c 
    join    parts p on (c.part = p.pid)
    join    suppliers s on (s.sid = c.supplier)
    where   p.colour = 'green'
);

-- method 2
select distinct s.sid, s.sname
from    parts p, catalog c, suppliers s
where   p.colour = 'red' and p.pid = c.part and s.sid = c.supplier
        and exists (
            select  p2.pid
            from    parts p2, catalog c2 
            where p2.colour = 'green' and c2.supplier = c.supplier and p2.pid = c2.part
        );


-- Q16
/*
Find the sids and snames of suppliers who supply every part.

-- method 1
for each supplier, is the set of parts they supply equal to 
the entire set of parts???

1. find teh set of all part ids
2. find the set of all part ids supplied by the supplier
3. find the set difference between the two
4. if that set is empty that means that supplier supplies every part

*/
select sid, sname
from suppliers s
where not exists (
    (select p.pid from parts p)
    except
    (select c.part from catalog c where c.supplier = s.sid)
);

-- method 2
select      s.sid, s.sname
from        catalog c 
join        suppliers s on (s.sid = c.supplier)
group by    s.sid, s.sname
having      count(distinct c.part) = (select count(*) from parts);


-- Q17
/*
Find the sids and snames of suppliers who supply every red part.
*/

-- method 1
select sid, sname
from suppliers s
where not exists (
    (select p.pid from parts p where p.colour = 'red')
    except
    (select c.part from catalog c where c.supplier = s.sid)
);

-- method 2
select      s.sid, s.sname
from        catalog c 
join        suppliers s on (s.sid = c.supplier)
join        parts p on (c.part = p.pid)
where       p.colour = 'red'
group by    s.sid, s.sname
having      count(distinct c.part) = (select count(*) from parts where colour = 'red');

-- Q19
/*
Find the sids and snames of suppliers who supply every red part 
or supply every green part.
*/

(
   select sid, sname
    from suppliers s
    where not exists (
        (select p.pid from parts p where p.colour = 'red')
        except
        (select c.part from catalog c where c.supplier = s.sid)
    )
) union (
    select sid, sname
    from suppliers s
    where not exists (
        (select p.pid from parts p where p.colour = 'green')
        except
        (select c.part from catalog c where c.supplier = s.sid)
    )
);

-- Q21

-- Q22
/*
Find the pids and pnames of the most expensive part(s) 
supplied by suppliers named "Yosemite Sham".
*/
select  p.pid, p.pname
from    catalog c
join    suppliers s on (c.supplier = s.sid)
join    parts p on (c.part = p.pid)
where   s.sname = 'Yosemite Sham'
        and c.cost >= (
            -- what the price of the most expensive part is 
            select  max(c2.cost)
            from    catalog c2
            join    suppliers s2 on (c2.supplier = s2.sid)
            where   s2.sname = 'Yosemite Sham'
        )
order by p.pid;
