

-=============== ������ 5. ������ � POSTGRESQL =======================================
--= �������, ��� ���������� ���������� ������ ���������� � ������� ����� PUBLIC===========
SET search_path TO public;

--======== �������� ����� ==============

--������� �1+
--�������� ������ � ������� payment � � ������� ������� ������� �������� ����������� ������� �������� ��������:
--	������������ ��� ������� �� 1 �� N �� ����
--	������������ ������� ��� ������� ����������, ���������� �������� ������ ���� �� ����
--	���������� ����������� ������ ����� ���� �������� ��� ������� ����������, ���������� ������ ���� ������ �� ���� �������, 
--  � ����� �� ����� ������� �� ���������� � �������
--	������������ ������� ��� ������� ���������� �� ��������� ������� �� ���������� � ������� ���, 
--  ����� ������� � ���������� ��������� ����� ���������� �������� ������.
-- ����� ��������� �� ������ ����� ��������� SQL-������, � ����� ���������� ��� ������� � ����� �������.

select p.customer_id, p.payment_id,  p.payment_date, row_number() over (order by p.payment_date) "column_1", 
row_number() over (partition by p.customer_id order by p.payment_date) "column_2",
sum(p.amount) over (partition by p.customer_id order by p.payment_date, p.amount) "column_3",
rank() over (partition by p.customer_id order by p.amount desc) "column_4"
from payment p 





--������� �2+
-- � ������� ������� ������� �������� ��� ������� ���������� ��������� ������� 
-- � ��������� ������� �� ���������� ������ �� ��������� �� ��������� 0.0 � ����������� �� ����.
 
select p.customer_id, p.payment_id, p.payment_date, p.amount "amount", 
lag(p.amount,1,0.0) over (partition by p.customer_id order by p.payment_date) "last_amount"
from payment p 
 order by p.customer_id, p.payment_date 





--������� �3+
-- � ������� ������� ������� ����������, �� ������� ������ 
-- ��������� ������ ���������� ������ ��� ������ ��������.

select p.customer_id, p.payment_id, p.payment_date, p.amount "amount",
p.amount-lead(p.amount,1,0.0) over (partition by p.customer_id order by p.payment_date) "difference"
from payment p 
 order by p.customer_id, p.payment_date




--������� �4+
-- � ������� ������� ������� ��� ������� ���������� �������� ������ � ��� ��������� ������ ������.

select p2.customer_id, p2.payment_id, p2.payment_date, p2.amount  
from (select customer_id, payment_id, max(payment_date) over (partition by customer_id) "max_date"
from payment where amount>0) ov 
join payment p2 on p2.payment_id = ov.payment_id 
where p2.customer_id = ov.customer_id and p2.payment_date = ov.max_date

--======== �������������� ����� ==============

--������� �1
--� ������� ������� ������� �������� ��� ������� ���������� ����� ������ �� ���� 2007 ����
-- � ����������� ������ �� ������� ���������� � 
-- �� ������ ���� ������� (��� ����� �������) � ����������� �� ����.




--������� �2
--10 ������ 2007 ���� � ��������� ��������� �����: ����������, ����������� ������ 100�� ������
-- ������� �������������� ������ �� ��������� ������.
-- � ������� ������� ������� �������� ���� �����������, ������� � ���� ���������� ����� �������� ������.




--������� �3
--��� ������ ������ ���������� � �������� ����� SQL-�������� �����������, ������� �������� ��� �������:
-- 1. ����������, ������������ ���������� ���������� �������
-- 2. ����������, ������������ ������� �� ����� ������� �����
-- 3. ����������, ������� ��������� ��������� �����