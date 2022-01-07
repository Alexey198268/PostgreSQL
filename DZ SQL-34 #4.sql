--=============== ������ 4. ���������� � SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1
--���� ������: ���� ����������� � �������� ����, �� �������� ����� ������� � �������:
--�������_�������, 
--���� ����������� � ���������� ��� ���������� �������, �� �������� ����� ����� � � ��� �������� �������.


-- ������������� ���� ������ ��� ��������� ���������:
-- 1. ���� (� ������ ����������, ����������� � ��)
-- 2. ���������� (� ������ �������, ���������� � ��)
-- 3. ������ (� ������ ������, �������� � ��)


--������� ���������:
-- �� ����� ����� ����� �������� ��������� �����������
-- ���� ���������� ����� ������� � ��������� �����
-- ������ ������ ����� �������� �� ���������� �����������

 
--���������� � ��������-������������:
-- ������������� �������� ������ ������������� ���������������
-- ������������ ��������� �� ������ ��������� null �������� � �� ������ ����������� ��������� � ��������� ���������
 
--�������� ������� �����

create table languages(
language_id serial PRIMARY KEY,
language_name VARCHAR(50) UNIQUE NOT NULL
)

--�������� ������ � ������� �����

insert into languages(language_name)
select unnest(array['�������','�����������','���������','��������','��������','����������'])


--�������� ������� ����������

create table nationality (
nationality_id serial PRIMARY KEY,
nationality_name varchar(50) unique NOT NULL
)

--�������� ������ � ������� ����������

insert into nationality (nationality_name)
select unnest(array['�������','��������','�������','������','�����','��������'])


--�������� ������� ������

create table country(
country_id serial PRIMARY KEY,
country_name varchar(50) unique NOT NULL
)

--�������� ������ � ������� ������

insert into country(country_name)
select unnest(array['������','�������','�����','������','��������','������'])

--�������� ������ ������� �� �������

create table nationality_language(
nationality_id int NOT null references nationality(nationality_id),
language_id int NOT null references languages(language_id),
last_update timestamp default now(),
primary key(nationality_id,language_id)
)


--�������� ������ � ������� �� �������

insert into nationality_language(nationality_id,language_id)
select unnest(array[1,2,3,4,5,6,1,6]),unnest(array[1,2,3,4,5,6,6,1])


--�������� ������ ������� �� �������

create table country_language(
country_id int NOT null references country(country_id),
language_id int NOT null references languages(language_id),
last_update timestamp default now(),
primary key(country_id,language_id)
)


--�������� ������ � ������� �� �������

insert into country_language(country_id,language_id)
select unnest(array[1,2,3,4,5,6,1,6]),unnest(array[1,2,3,4,5,6,6,1])

--======== �������������� ����� ==============


--������� �1 
--�������� ����� ������� film_new �� ���������� ������:
--�   	film_name - �������� ������ - ��� ������ varchar(255) � ����������� not null
--�   	film_year - ��� ������� ������ - ��� ������ integer, �������, ��� �������� ������ ���� ������ 0
--�   	film_rental_rate - ��������� ������ ������ - ��� ������ numeric(4,2), �������� �� ��������� 0.99
--�   	film_duration - ������������ ������ � ������� - ��� ������ integer, ����������� not null � �������, ��� �������� ������ ���� ������ 0
--���� ��������� � �������� ����, �� ����� ��������� ������� ������� ������������ ����� �����.

create table film_new (
film_name varchar(255) not null,
film_year integer check(film_year>0),
film_rental_rate numeric(4,2) default 0.99,
film_duration integer not null)

--������� �2 
--��������� ������� film_new ������� � ������� SQL-�������, ��� �������� ������������� ������� ������:
--�       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--�       film_year - array[1994, 1999, 1985, 1994, 1993]
--�       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--�   	  film_duration - array[142, 189, 116, 142, 195]

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
select unnest(array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']),
unnest(array[1994, 1999, 1985, 1994, 1993]),
unnest(array[2.99, 0.99, 1.99, 2.99, 3.99]),
unnest(array[142, 189, 116, 142, 195])

--������� �3
--�������� ��������� ������ ������� � ������� film_new � ������ ����������, 
--��� ��������� ������ ���� ������� ��������� �� 1.41

update film_new
set film_rental_rate=film_rental_rate+1.41

--������� �4
--����� � ��������� "Back to the Future" ��� ���� � ������, 
--������� ������ � ���� ������� �� ������� film_new

delete from film_new
where film_name = 'Back to the Future'

--������� �5
--�������� � ������� film_new ������ � ����� ������ ����� ������

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
values('Lion King',1994,2.10,88)


--������� �6
--�������� SQL-������, ������� ������� ��� ������� �� ������� film_new, 
--� ����� ����� ����������� ������� "������������ ������ � �����", ���������� �� �������

select film_name, film_year, film_rental_rate, film_duration, round(film_duration::numeric/60,1) film_duration_hours 
from film_new

--������� �7 
--������� ������� film_new

drop table film_new
