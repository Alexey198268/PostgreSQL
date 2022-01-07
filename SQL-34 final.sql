--1 В каких городах больше одного аэропорта?

select city "Город", count(airport_code) "Количество аэропортов"
from airports a 
group by city 
having count(airport_code)>1

--Считаем количество аэропортов по городам, фильтруем города, где их больше 1. 
--В итоге выходит, что таких городов два - в Москве 3 аэропорта, в Ульяновске - 2.
--------------------------------------------------

--2 В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?

select distinct (a2.airport_name) 
from aircrafts a join flights f on a.aircraft_code = f.aircraft_code join airports a2 on a2.airport_code = f.departure_airport 
where a.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))
union
select distinct (a3.airport_name) 
from aircrafts a join flights f on a.aircraft_code = f.aircraft_code join airports a3 on a3.airport_code = f.arrival_airport 
where a.aircraft_code = (select aircraft_code from aircrafts where "range" = (select max("range") from aircrafts))

--Выбираем подзапросом код самолета, который имеет максимальную дальность полета, 
--затем соединяем таблицы-справочники самолетов и аэропортов с таблицей полетов, 
--фильтруем рейсы, которые совершались только данным самолетом с максимальной дальностью полета 
--и находим наименования уникальных аэропортов отправки и назначения. 
--Объединяем их без дубликатов (union) и получаем список таких аэропортов.
--------------------------------------------------

--3 Вывести 10 рейсов с максимальным временем задержки вылета

select f.flight_no "Номер рейса", max(f.actual_departure - f.scheduled_departure) "Максимальное время задержки рейса" 
from flights f 
where f.actual_departure is not null
group by f.flight_no 
order by max(f.actual_departure - f.scheduled_departure) desc
limit 10

--Чтобы посчитать задержку рейса, нужно вычесть из фактического времени вылета время вылета по расписанию. 
--Т.к. не везде указано фактическое время вылета, то ограничим выборку, исключив строки с незаполненным 
--временем фактического вылета. Затем сгруппируем данные по номерам рейсов и рассчитаем максимальное время 
--задержки вылета по каждому номеру рейса. Упорядочим этот показатель по убыванию и выведем только 10 первых записей.
----------------------------------------------------------

--4 Были ли брони, по которым не были получены посадочные талоны?

select count(b.book_ref) 
from tickets t join ticket_flights tf on t.ticket_no = tf.ticket_no join boarding_passes bp on tf.ticket_no = bp.ticket_no 
full join bookings b on b.book_ref = t.book_ref 
where t.book_ref isnull 

---Объединяем таблицы билетов, перелетов, посадочных талонов. К ним присоединяем таблицу бронирований полным объединением, 
--чтобы в результат попали также идентификаторы бронирований, на которые не было выдано посадочных талонов.
--Фильтруем список таких бронирований. В итоге получаем, что на 91 381 бронирование не было выдано посадочных талонов.  
----------------------------------------------------------


--6 Найдите процентное соотношение перелетов по типам самолетов от общего количества.

select a.model "Модели самолетов", count(tf.flight_id )*100/(select count(flight_id) from ticket_flights) "% от общего количества перелетов"
from ticket_flights tf join flights f on tf.flight_id = f.flight_id join aircrafts a on f.aircraft_code = a.aircraft_code 
group by a.model


-- Объединяем таблицы перелетов и рейсов, добавляем к ним данные из таблицы списка  самолетов. Группируем по моделям самолетов и 
-- высчитываем процент количества перелетов каждой модели самолета к общему количеству перелетов (данный показатель рассчитываем подзапросом).
-----------------------------------------------------------

--7 Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета? 

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
	when e.max < b.min then 'Эконом дешевле'
	else 'Бизнес дешевле'
end "Сравнение"
from eco e join bus b on e.city_A = b.city_A and e.city_B = b.city_B
where e.city_A < e.city_B
		
--- Формируем два cte - для перелетов эконом-классом (считаем максимальную стоимость перелета между городами) 
--и для перелетов бизнес-классом (считаем минимальную стоимость передета между городами). Объединяем их по городам вылета и прибытия. 
--Удаляем зазеркаливания городов и вычисляем через условие, были ли перелеты, где минимальная стоимость перелета билнес-классом
--была бы ниже, чем максимальная стоимость перелета эконом-классом. Таких случаев не выявлено.
------------------------------------------------------------- 

--8 Между какими городами нет прямых рейсов?

(select a.city "Город1", a1.city "Город2" 
from (select distinct a.city 
from flights f join airports a on f.departure_airport =a.airport_code join airports a2 on f.arrival_airport = a2.airport_code) a
cross join (select distinct a.city 
from flights f join airports a on f.departure_airport =a.airport_code join airports a2 on f.arrival_airport = a2.airport_code) a1
where a.city not like a1.city and a.city < a1.city
order by a.city, a1.city)
except
(select a.city "Город1", a1.city "Город2" 
from flights f join airports a on f.departure_airport =a.airport_code join airports a1 on f.arrival_airport = a1.airport_code 
where a.city < a1.city 
group by a.city, a1.city
order by a.city, a1.city)

---Формируем два запроса - первый представляет собой декартово произведение между всеми городами полетов, второй - список 
--фактических полетов между городами. Вычитаем из первого запроса второй, в результате получаем список связок городов, между 
--которыми неи=т прямых рейсов.
---------------------------------------------------------

--9 Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов 
-- в самолетах, обслуживающих эти рейсы * В локальной базе координаты находятся в столбцах airports.longitude и airports.latitude.
--ратчайшее расстояние между двумя точками A и B на земной поверхности (если принять ее за сферу) определяется зависимостью:
--d = arccos {sin(latitude_a)·sin(latitude_b) + cos(latitude_a)·cos(latitude_b)·cos(longitude_a - longitude_b)}, где latitude_a и latitude_b — 
--широты, longitude_a, longitude_b — долготы данных пунктов, d — расстояние между пунктами измеряется в радианах длиной дуги большого круга 
--земного шара.
--Расстояние между пунктами, измеряемое в километрах, определяется по формуле:
--L = d·R, где R = 6371 км — средний радиус земного шара.

select a.city "Город1", a1.city "Город2", a.airport_name "Аэропорт1", a1.airport_name "Аэропорт2",
a2.model "Модель сам.", min(a2."range") "Дальн. полета самолета", 
round(acos(sin(radians(a.latitude))*sin(radians(a1.latitude)) + 
cos(radians(a.latitude))*cos(radians(a1.latitude))*cos(radians(a.longitude) - radians(a1.longitude)))*6371.) "Прям. расст. м/д городами",
	case
		when min(a2."range")>= round(acos(sin(radians(a.latitude))*sin(radians(a1.latitude)) + 
cos(radians(a.latitude))*cos(radians(a1.latitude))*cos(radians(a.longitude) - radians(a1.longitude)))*6371.) then 'Ok'
		else 'no ok'
	end "Проверка"
from flights f join airports a on f.departure_airport = a.airport_code join airports a1 on f.arrival_airport = a1.airport_code 
join aircrafts a2 on f.aircraft_code = a2.aircraft_code 
where a.city < a1.city
group by a.city, a1.city, a2.model, a.latitude, a.longitude, a1.latitude, a1.longitude,a.airport_name, a1.airport_name
order by a.city, a1.city

--Формируем перечень связок городов, между которыми осуществялются перелеты, рассчитываем по формуле расстояния между этими городами,
--добавляем сведения о самолетах, которые летают в этих направлениях и их максимальную дальность полета. Сравниваем расстояние между городами
-- с этой характеристикой самолета, добавляем через case проверку соответствия самолета дальности маршрута. 
---Недостаточной дальности полета не обнаружено. 