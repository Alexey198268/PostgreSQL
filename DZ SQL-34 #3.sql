--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1 ГОТОВО
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat(a.first_name, ' ', a.last_name) "Фамилия и имя", b.address "Адрес", c.city "Город", d.country "Страна"
from customer a join address b using(address_id) join city c using(city_id) join country d using(country_id)



--ЗАДАНИЕ №2 ГОТОВО
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id, count(customer_id) 
from customer
group by store_id 

--Доработайте запрос и выведите только те магазины, ГОТОВО
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select store_id, count(customer_id) 
from customer
group by store_id 
having count(customer_id) > 300

-- Доработайте запрос, добавив в него информацию о городе магазина, ДОРАБОТАНО-ГОТОВО
--а также фамилию и имя продавца, который работает в этом магазине.

select s.store_id "ID магазина", count(c.customer_id) "Количество покупателей", c2.city "Город магазина", 
concat(s2.last_name, ' ', s2.first_name) "Фамилия и имя продавца"  
from customer c join store s on c.store_id = s.store_id join staff s2 on s.manager_staff_id = s2.staff_id 
join address a on s.address_id = a.address_id join city c2 on a.city_id = c2.city_id 
group by s.store_id, c2.city, s2.last_name, s2.first_name 
having count(c.customer_id) > 300

--ЗАДАНИЕ №3 ГОТОВО
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select concat(last_name, ' ', first_name) "Фамилия и имя покупателя", count(rental_id) as "Количество фильмов"
from customer a join rental b using(customer_id)
group by customer_id
order by "Количество фильмов" desc
limit 5

--ЗАДАНИЕ №4 ГОТОВО ДОРАБОТАНО
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

 select concat(c.last_name, ' ', c.first_name) "Фамилия и имя покупателя", count(p.payment_id) "Кол-во фильмов",
 round(sum(p.amount),0) "Общ. ст-ть платежей", min(p.amount) "Мин. ст-ть плат.", max(p.amount) "Макс. ст-ть плат." 
 from rental r join inventory i on r.inventory_id = i.inventory_id left join payment p on r.rental_id = p.rental_id 
 join customer c on c.customer_id = r.customer_id 
 group by c.customer_id 
 
--ЗАДАНИЕ №5 ГОТОВО
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select a.city "Город 1", b.city "Город 2" 
from city a cross join city b
where a.city not like b.city 


--ЗАДАНИЕ №6 ГОТОВО
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select b.customer_id "ID покупателя", round(avg(a.return_date::date - a.rental_date::date), 2) "Среднее кол-во дней на возврат"
from rental a join customer b using(customer_id)
group by b.customer_id 
order by b.customer_id

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select f.title, count(r.rental_id), sum(p.amount) 
from film f left join inventory i on f.film_id = i.film_id left join rental r on i.inventory_id = r.inventory_id 
left join payment p on r.rental_id = p.rental_id 
group by f.film_id 
order by f.title


--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.

select f.title, count(r.rental_id), sum(p.amount) 
from film f full join inventory i on f.film_id = i.film_id full join rental r on i.inventory_id = r.inventory_id 
left join payment p on r.rental_id = p.rental_id 
group by f.film_id 
having count(r.rental_id) = 0
order by f.title



--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".







