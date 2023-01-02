--Query 1

DROP TABLE IF EXISTS product_summary
CREATE TABLE product_summary
(year NUMERIC,
description TEXT,
sales NUMERIC)

--Query 2

INSERT INTO product_summary
VALUES
('2014', 'BANANA Organic', '176818.73'),
('2015', 'BANANA Organic', '258541.96'),
('2014', 'AVOCADO Hass Organic', '146480.34'),
('2014', 'ChickenBreastBoneless/Skinless', '204630.90')

--Query 3

UPDATE product_summary
SET year = 2022
WHERE description = 'AVOCADO Hass Organic'

--Query 4

DELETE FROM product_summary
WHERE description = 'BANANA Organic'
AND year = '2014'

--Query 5

SELECT 
dept_date.department, 
sum(dept_date.spend) AS `Dept_Spend`,
Dept.dept_name as `Department_Name`
FROM `umt-msba.wedge_example.department_date` AS dept_date 
JOIN `umt-msba.wedge_example.departments` AS Dept ON Dept.department = dept_date.department
WHERE EXTRACT (YEAR from dept_date.date)= 2015
GROUP BY dept_date.department, Dept.dept_name
order by sum(spend) DESC;

--Query 6

SELECT DISTINCT (osd.card_no) as card_no,
EXTRACT (YEAR FROM osd.date) as `Year`,
EXTRACT (MONTH FROM osd.date) as `Month`,
sum(osd.spend) as `spend`, 
sum(osd.items) as `items`
FROM `umt-msba.wedge_example.owner_spend_date` as osd
GROUP BY card_no, Year, Month
HAVING spend between 750 and 1250
ORDER BY spend DESC
LIMIT 10;


--Query 7

SELECT COUNT(*) AS Num_Rows,
COUNT(DISTINCT(card_no)) AS Card_no_Count,
sum(total) AS Total_Spend,
count(distinct(description)) AS Description_Count
FROM`umt-msba.transactions.transArchive_201001_201003`;


--Query 8

SELECT COUNT(*) AS Row_Count,
COUNT(DISTINCT(card_no)) AS Card_Count,
sum(total) AS Total_Spend,
count(distinct(description)) AS Descrip_Count
FROM`umt-msba.transactions.transArchive_*`
GROUP BY EXTRACT (YEAR FROM datetime);

--Query 9

SELECT
EXTRACT(YEAR FROM datetime) as year,
sum(total) as Spend,
COUNT(DISTINCT Concat
(cast(EXTRACT(date from datetime) as string), 
cast(register_no as string),
cast(emp_no as string),
 cast(trans_no as string))) as trans,
SUM(CASE WHEN trans_status in ('V','R') THEN -1
ELSE 1 END) AS items
FROM`umt-msba.transactions.transArchive_*`
WHERE department not in (0,15)
AND (trans_status is NULL or
        trans_status in (' ', 'V', 'R'))
GROUP BY year
ORDER BY year;


--Query 10

SELECT
EXTRACT(date FROM datetime) as date,
EXTRACT(HOUR FROM datetime) as hour,
sum(total) as Spend,
COUNT(DISTINCT Concat
(cast(EXTRACT(date from datetime) as string), 
cast(register_no as string),
cast(emp_no as string),
 cast(trans_no as string))) as trans,
SUM(CASE WHEN trans_status in ('V','R') THEN -1
ELSE 1 END) AS items
FROM`umt-msba.transactions.transArchive_*`
WHERE department not in (0,15)
AND (trans_status is NULL or
        trans_status in (' ', 'V', 'R'))
GROUP BY date,hour
ORDER BY date, hour;
