--=============== ������ 3. ������ SQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1 ������
--�������� ��� ������� ���������� ��� ����� ����������, 
--����� � ������ ����������.

select concat(a.first_name, ' ', a.last_name) "������� � ���", b.address "�����", c.city "�����", d.country "������"
from customer a join address b using(address_id) join city c using(city_id) join country d using(country_id)



--������� �2 ������
--� ������� SQL-������� ���������� ��� ������� �������� ���������� ��� �����������.

select store_id, count(customer_id) 
from customer
group by store_id 

--����������� ������ � �������� ������ �� ��������, ������
--� ������� ���������� ����������� ������ 300-��.
--��� ������� ����������� ���������� �� ��������������� ������� 
--� �������������� ������� ���������.

select store_id, count(customer_id) 
from customer
group by store_id 
having count(customer_id) > 300

-- ����������� ������, ������� � ���� ���������� � ������ ��������, ����������-������
--� ����� ������� � ��� ��������, ������� �������� � ���� ��������.

select s.store_id "ID ��������", count(c.customer_id) "���������� �����������", c2.city "����� ��������", 
concat(s2.last_name, ' ', s2.first_name) "������� � ��� ��������"  
from customer c join store s on c.store_id = s.store_id join staff s2 on s.manager_staff_id = s2.staff_id 
join address a on s.address_id = a.address_id join city c2 on a.city_id = c2.city_id 
group by s.store_id, c2.city, s2.last_name, s2.first_name 
having count(c.customer_id) > 300

--������� �3 ������
--�������� ���-5 �����������, 
--������� ����� � ������ �� �� ����� ���������� ���������� �������

select concat(last_name, ' ', first_name) "������� � ��� ����������", count(rental_id) as "���������� �������"
from customer a join rental b using(customer_id)
group by customer_id
order by "���������� �������" desc
limit 5

--������� �4 ������ ����������
--���������� ��� ������� ���������� 4 ������������� ����������:
--  1. ���������� �������, ������� �� ���� � ������
--  2. ����� ��������� �������� �� ������ ���� ������� (�������� ��������� �� ������ �����)
--  3. ����������� �������� ������� �� ������ ������
--  4. ������������ �������� ������� �� ������ ������

 select concat(c.last_name, ' ', c.first_name) "������� � ��� ����������", count(p.payment_id) "���-�� �������",
 round(sum(p.amount),0) "���. ��-�� ��������", min(p.amount) "���. ��-�� ����.", max(p.amount) "����. ��-�� ����." 
 from rental r join inventory i on r.inventory_id = i.inventory_id left join payment p on r.rental_id = p.rental_id 
 join customer c on c.customer_id = r.customer_id 
 group by c.customer_id 
 
--������� �5 ������
--��������� ������ �� ������� ������� ��������� ����� �������� ������������ ���� ������� ����� �������,
 --����� � ���������� �� ���� ��� � ����������� ���������� �������. 
 --��� ������� ���������� ������������ ��������� ������������.
 
select a.city "����� 1", b.city "����� 2" 
from city a cross join city b
where a.city not like b.city 


--������� �6 ������
--��������� ������ �� ������� rental � ���� ������ ������ � ������ (���� rental_date)
--� ���� �������� ������ (���� return_date), 
--��������� ��� ������� ���������� ������� ���������� ����, �� ������� ���������� ���������� ������.
 
select b.customer_id "ID ����������", round(avg(a.return_date::date - a.rental_date::date), 2) "������� ���-�� ���� �� �������"
from rental a join customer b using(customer_id)
group by b.customer_id 
order by b.customer_id

--======== �������������� ����� ==============

--������� �1
--���������� ��� ������� ������ ������� ��� ��� ����� � ������ � �������� ����� ��������� ������ ������ �� �� �����.

select f.title, count(r.rental_id), sum(p.amount) 
from film f left join inventory i on f.film_id = i.film_id left join rental r on i.inventory_id = r.inventory_id 
left join payment p on r.rental_id = p.rental_id 
group by f.film_id 
order by f.title


--������� �2
--����������� ������ �� ����������� ������� � �������� � ������� ������� ������, ������� �� ���� �� ����� � ������.

select f.title, count(r.rental_id), sum(p.amount) 
from film f full join inventory i on f.film_id = i.film_id full join rental r on i.inventory_id = r.inventory_id 
left join payment p on r.rental_id = p.rental_id 
group by f.film_id 
having count(r.rental_id) = 0
order by f.title



--������� �3
--���������� ���������� ������, ����������� ������ ���������. �������� ����������� ������� "������".
--���� ���������� ������ ��������� 7300, �� �������� � ������� ����� "��", ����� ������ ���� �������� "���".







