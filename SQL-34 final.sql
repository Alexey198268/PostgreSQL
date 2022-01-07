--1 � ����� ������� ������ ������ ���������?

select city "�����", count(airport_code) "���������� ����������"
from airports a 
group by city 
having count(airport_code)>1

--������� ���������� ���������� �� �������, ��������� ������, ��� �� ������ 1. 
--� ����� �������, ��� ����� ������� ��� - � ������ 3 ���������, � ���������� - 2.
--------------------------------------------------

--2 � ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?

select distinct (a2.airport_name) 
from aircrafts a join flights f on a.aircraft_code = f.aircraft_code join airports a2 on a2.airport_code = f.departure_airport 
where a.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))
union
select distinct (a3.airport_name) 
from aircrafts a join flights f on a.aircraft_code = f.aircraft_code join airports a3 on a3.airport_code = f.arrival_airport 
where a.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))

--�������� ����������� ��� ��������, ������� ����� ������������ ��������� ������, 
--����� ��������� �������-����������� ��������� � ���������� � �������� �������, 
--��������� �����, ������� ����������� ������ ������ ��������� � ������������ ���������� ������ 
--� ������� ������������ ���������� ���������� �������� � ����������. 
--���������� �� ��� ���������� (union) � �������� ������ ����� ����������.
--------------------------------------------------

--3 ������� 10 ������ � ������������ �������� �������� ������

select f.flight_no "����� �����", max(f.actual_departure - f.scheduled_departure) "������������ ����� �������� �����" 
from flights f 
where f.actual_departure is not null
group by f.flight_no 
order by max(f.actual_departure - f.scheduled_departure) desc
limit 10

--����� ��������� �������� �����, ����� ������� �� ������������ ������� ������ ����� ������ �� ����������. 
--�.�. �� ����� ������� ����������� ����� ������, �� ��������� �������, �������� ������ � ������������� 
--�������� ������������ ������. ����� ����������� ������ �� ������� ������ � ���������� ������������ ����� 
--�������� ������ �� ������� ������ �����. ���������� ���� ���������� �� �������� � ������� ������ 10 ������ �������.
----------------------------------------------------------

--4 ���� �� �����, �� ������� �� ���� �������� ���������� ������?

select count(b.book_ref) 
from tickets t join ticket_flights tf on t.ticket_no = tf.ticket_no join boarding_passes bp on tf.ticket_no = bp.ticket_no 
full join bookings b on b.book_ref = t.book_ref 
where t.book_ref isnull 

---���������� ������� �������, ���������, ���������� �������. � ��� ������������ ������� ������������ ������ ������������, 
--����� � ��������� ������ ����� �������������� ������������, �� ������� �� ���� ������ ���������� �������.
--��������� ������ ����� ������������. � ����� ��������, ��� �� 91 381 ������������ �� ���� ������ ���������� �������.  
----------------------------------------------------------


--6 ������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������.

select a.model "������ ���������", count(tf.flight_id )*100/(select count(flight_id) from ticket_flights) "% �� ������ ���������� ���������"
from ticket_flights tf join flights f on tf.flight_id = f.flight_id join aircrafts a on f.aircraft_code = a.aircraft_code 
group by a.model


-- ���������� ������� ��������� � ������, ��������� � ��� ������ �� ������� ������  ���������. ���������� �� ������� ��������� � 
-- ����������� ������� ���������� ��������� ������ ������ �������� � ������ ���������� ��������� (������ ���������� ������������ �����������).
-----------------------------------------------------------

--7 ���� �� ������, � ������� �����  ��������� ������ - ������� �������, ��� ������-������� � ������ ��������? 

with eco as (
	select a.city city_A, a2.city city_B, tf.fare_conditions, max(tf.amount)
	from flights f join ticket_flights tf on f.flight_id = tf.flight_id join airports a on a.airport_code =f.departure_airport 
	join airports a2 on f.arrival_airport = a2.airport_code 
	where tf.fare_conditions = 'Economy'
	group by a.city, a2.city, tf.fare_conditions), 
bus as (
	select a.city city_A, a2.city city_B, tf.fare_conditions, min(tf.amount)
	from flights f join ticket_flights tf on f.flight_id = tf.flight_id join airports a on a.airport_code =f.departure_airport 
	join airports a2 on f.arrival_airport = a2.airport_code 
	where tf.fare_conditions = 'Business'
	group by a.city, a2.city, tf.fare_conditions) 
select *, 
case
	when e.max < b.min then '������ �������'
	else '������ �������'
end "���������"
from eco e join bus b on e.city_A = b.city_A and e.city_B = b.city_B
where e.city_A < e.city_B
		
--- ��������� ��� cte - ��� ��������� ������-������� (������� ������������ ��������� �������� ����� ��������) 
--� ��� ��������� ������-������� (������� ����������� ��������� �������� ����� ��������). ���������� �� �� ������� ������ � ��������. 
--������� �������������� ������� � ��������� ����� �������, ���� �� ��������, ��� ����������� ��������� �������� ������-�������
--���� �� ����, ��� ������������ ��������� �������� ������-�������. ����� ������� �� ��������.
------------------------------------------------------------- 

--8 ����� ������ �������� ��� ������ ������?

(select a.city "�����1", a1.city "�����2" 
from (select distinct a.city 
from flights f join airports a on f.departure_airport =a.airport_code join airports a2 on f.arrival_airport = a2.airport_code) a
cross join (select distinct a.city 
from flights f join airports a on f.departure_airport =a.airport_code join airports a2 on f.arrival_airport = a2.airport_code) a1
where a.city not like a1.city and a.city < a1.city
order by a.city, a1.city)
except
(select a.city "�����1", a1.city "�����2" 
from flights f join airports a on f.departure_airport =a.airport_code join airports a1 on f.arrival_airport = a1.airport_code 
where a.city < a1.city 
group by a.city, a1.city
order by a.city, a1.city)

---��������� ��� ������� - ������ ������������ ����� ��������� ������������ ����� ����� �������� �������, ������ - ������ 
--����������� ������� ����� ��������. �������� �� ������� ������� ������, � ���������� �������� ������ ������ �������, ����� 
--�������� ���=� ������ ������.
---------------------------------------------------------

--9 ��������� ���������� ����� �����������, ���������� ������� �������, �������� � ���������� ������������ ���������� ��������� 
-- � ���������, ������������� ��� ����� * � ��������� ���� ���������� ��������� � �������� airports.longitude � airports.latitude.
--��������� ���������� ����� ����� ������� A � B �� ������ ����������� (���� ������� �� �� �����) ������������ ������������:
--d = arccos {sin(latitude_a)�sin(latitude_b) + cos(latitude_a)�cos(latitude_b)�cos(longitude_a - longitude_b)}, ��� latitude_a � latitude_b � 
--������, longitude_a, longitude_b � ������� ������ �������, d � ���������� ����� �������� ���������� � �������� ������ ���� �������� ����� 
--������� ����.
--���������� ����� ��������, ���������� � ����������, ������������ �� �������:
--L = d�R, ��� R = 6371 �� � ������� ������ ������� ����.

select a.city "�����1", a1.city "�����2", a.airport_name "��������1", a1.airport_name "��������2",
a2.model "������ ���.", min(a2."range") "�����. ������ ��������", 
round(acos(sin(radians(a.latitude))*sin(radians(a1.latitude)) + 
cos(radians(a.latitude))*cos(radians(a1.latitude))*cos(radians(a.longitude) - radians(a1.longitude)))*6371.) "����. �����. �/� ��������",
	case
		when min(a2."range")>= round(acos(sin(radians(a.latitude))*sin(radians(a1.latitude)) + 
cos(radians(a.latitude))*cos(radians(a1.latitude))*cos(radians(a.longitude) - radians(a1.longitude)))*6371.) then 'Ok'
		else 'no ok'
	end "��������"
from flights f join airports a on f.departure_airport = a.airport_code join airports a1 on f.arrival_airport = a1.airport_code 
join aircrafts a2 on f.aircraft_code = a2.aircraft_code 
where a.city < a1.city
group by a.city, a1.city, a2.model, a.latitude, a.longitude, a1.latitude, a1.longitude,a.airport_name, a1.airport_name
order by a.city, a1.city

--��������� �������� ������ �������, ����� �������� �������������� ��������, ������������ �� ������� ���������� ����� ����� ��������,
--��������� �������� � ���������, ������� ������ � ���� ������������ � �� ������������ ��������� ������. ���������� ���������� ����� ��������
-- � ���� ��������������� ��������, ��������� ����� case �������� ������������ �������� ��������� ��������. 
---������������� ��������� ������ �� ����������. 