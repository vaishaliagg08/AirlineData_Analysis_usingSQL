create database airline_data;
use airline_data;

CREATE table airlines(airline_id int auto_increment primary key , airline_name varchar(100) unique);
insert ignore into airlines (airline_name)
select distinct airline from flight_data;

select * from airlines;

create table cities (city_id int auto_increment primary key, city_name varchar(100) unique);

insert into cities(city_name)
select distinct source_city
from flight_data
where source_city is not null 
union 
select distinct destination_city
from flight_data
where destination_city is not null ;

select * from cities;

create table classes(class_id int auto_increment primary key , class_name varchar(100) unique);

insert into classes (class_name)
select distinct class 
from flight_data
where class is not null ;

select * from classes;

create table flights( 
flight_id int auto_increment primary key, 
airline_id int, 
flight_number varchar(50), 
source_city_id int, 
destination_city_id int , 
departure_time time, 
arrival_time time, 
stops int, 
duration varchar(50), 
class_id int ,
foreign key (airline_id) references airlines(airline_id),
foreign key (source_city_id) references cities (city_id),
foreign key (destination_city_id) references cities (city_id), 
foreign key (class_id) references classes (class_id));

ALTER TABLE Flights MODIFY departure_time VARCHAR(50);
ALTER TABLE Flights MODIFY arrival_time VARCHAR(50);
ALTER TABLE Flights MODIFY stops VARCHAR(20);


insert into flights (airline_id, flight_number, source_city_id, destination_city_id, departure_time, arrival_time, stops, duration, class_id)
select  
a.airline_id,
fd.flight,
sc.city_id as source_city_id,
dc.city_id as destination_city_id,
fd.departure_time,
fd.arrival_time,
fd.stops,
fd.duration,
c.class_id
from flight_data fd
join airlines a on fd.airline = a.airline_name
join cities sc on fd.source_city = sc.city_name
join cities dc on fd.destination_city = dc.city_name
join classes c on fd.class = c.class_name;

select * from flights;

create table ticket_prices( price_id int auto_increment primary key , flight_id int , days_left int , price decimal(10,2),
foreign key (flight_id) references flights(flight_id));

insert into ticket_prices (flight_id, days_left, price)
select 
f.flight_id,
fd.days_left,
fd.price
from flight_data fd
join airlines a on fd.airline = a.airline_name
join cities sc on fd.source_city = sc.city_name
join cities dc on fd.destination_city = dc.city_name
join classes c on fd.class = c.class_name
join flights f on f.airline_id = a.airline_id 
and f.flight_number =  fd.flight
and f.source_city_id = sc.city_id
and f.destination_city_id = dc.city_id 
and f.class_id = c.class_id;

select * from ticket_prices;

drop table flight_data;

-- top 5 most expensive flight 

select 
a.airline_name,
f.flight_number,
sc.city_name as source_city,
dc.city_name as destination_city,
MAX(tp.price) as max_price
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join airlines a on f.airline_id = a.airline_id
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
group by a.airline_name, f.flight_number, sc.city_name, dc.city_name
order by max_price desc
limit 5;

-- average ticket price by airline and class

select 
a.airline_name,
c.class_name,
ROUND(AVG(tp.price), 2) as avg_price
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join airlines a on f.airline_id = a.airline_id
join classes c on f.class_id = c.class_id
group by a.airline_name, c.class_name
order by avg_price desc;

-- cheapest flight for each route 
select 
sc.city_name as source_city,
dc.city_name as destination_city,
MIN(tp.price) as cheapest_price
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
group by sc.city_name, dc.city_name
order by cheapest_price asc;

-- price change trend as day left decreases
select
f.flight_number,
a.airline_name,
tp.days_left,
tp.price
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join airlines a on f.airline_id = a.airline_id
where f.flight_number = 'UK-963' 
order by tp.days_left desc;

-- routes with most flights
select 
sc.city_name as source_city,
dc.city_name as destination_city,
COUNT(*) as total_flights
from flights f
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
group by sc.city_name, dc.city_name
order by total_flights desc;

-- most profitable route 
select
sc.city_name as source_city,
dc.city_name as destination_city,
SUM(tp.price) as total_revenue
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
group by sc.city_name, dc.city_name
order by total_revenue desc
limit 1;

-- average duration for each route 
select 
sc.city_name as source_city,
dc.city_name as destination_city,
ROUND(avg(CAST(REPLACE(f.duration, 'h', '') as decimal(5,2))), 2) as avg_duration_hours
from flights f
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
group by sc.city_name, dc.city_name
order by avg_duration_hours asc;

-- airline performance report 
select 
a.airline_name,
CONCAT(sc.city_name, ' → ', dc.city_name) as route,
c.class_name,
MIN(tp.price) as cheapest_price,
ROUND(avg(tp.price), 2) as average_price,
MAX(tp.price) as highest_price,
COUNT(distinct f.flight_id) as total_flights
from ticket_prices tp
join flights f on tp.flight_id = f.flight_id
join airlines a on f.airline_id = a.airline_id
join cities sc on f.source_city_id = sc.city_id
join cities dc on f.destination_city_id = dc.city_id
join classes c on f.class_id = c.class_id
group by a.airline_name, sc.city_name, dc.city_name, c.class_name
order by average_price desc;




