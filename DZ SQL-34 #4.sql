--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаете новые таблицы в формате:
--таблица_фамилия, 
--если подключение к контейнеру или локальному серверу, то создаете новую схему и в ней создаете таблицы.


-- Спроектируйте базу данных для следующих сущностей:
-- 1. язык (в смысле английский, французский и тп)
-- 2. народность (в смысле славяне, англосаксы и тп)
-- 3. страны (в смысле Россия, Германия и тп)


--Правила следующие:
-- на одном языке может говорить несколько народностей
-- одна народность может входить в несколько стран
-- каждая страна может состоять из нескольких народностей

 
--Требования к таблицам-справочникам:
-- идентификатор сущности должен присваиваться автоинкрементом
-- наименования сущностей не должны содержать null значения и не должны допускаться дубликаты в названиях сущностей
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create table languages(
language_id serial PRIMARY KEY,
language_name VARCHAR(50) UNIQUE NOT NULL
)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

insert into languages(language_name)
select unnest(array['русский','французский','китайский','японский','немецкий','английский'])


--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

create table nationality (
nationality_id serial PRIMARY KEY,
nationality_name varchar(50) unique NOT NULL
)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ

insert into nationality (nationality_name)
select unnest(array['русские','французы','китайцы','японцы','немцы','британцы'])


--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table country(
country_id serial PRIMARY KEY,
country_name varchar(50) unique NOT NULL
)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

insert into country(country_name)
select unnest(array['Россия','Франция','Китай','Япония','Германия','Англия'])

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table nationality_language(
nationality_id int NOT null references nationality(nationality_id),
language_id int NOT null references languages(language_id),
last_update timestamp default now(),
primary key(nationality_id,language_id)
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into nationality_language(nationality_id,language_id)
select unnest(array[1,2,3,4,5,6,1,6]),unnest(array[1,2,3,4,5,6,6,1])


--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ

create table country_language(
country_id int NOT null references country(country_id),
language_id int NOT null references languages(language_id),
last_update timestamp default now(),
primary key(country_id,language_id)
)


--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into country_language(country_id,language_id)
select unnest(array[1,2,3,4,5,6,1,6]),unnest(array[1,2,3,4,5,6,6,1])

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

create table film_new (
film_name varchar(255) not null,
film_year integer check(film_year>0),
film_rental_rate numeric(4,2) default 0.99,
film_duration integer not null)

--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
select unnest(array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']),
unnest(array[1994, 1999, 1985, 1994, 1993]),
unnest(array[2.99, 0.99, 1.99, 2.99, 3.99]),
unnest(array[142, 189, 116, 142, 195])

--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update film_new
set film_rental_rate=film_rental_rate+1.41

--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

delete from film_new
where film_name = 'Back to the Future'

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
values('Lion King',1994,2.10,88)


--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых

select film_name, film_year, film_rental_rate, film_duration, round(film_duration::numeric/60,1) film_duration_hours 
from film_new

--ЗАДАНИЕ №7 
--Удалите таблицу film_new

drop table film_new
