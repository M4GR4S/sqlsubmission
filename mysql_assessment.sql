-- Active: 1715669251949@@127.0.0.1@3306

-- 1. Analyse the data
-- ****************************************************************
-- How are the two tables related?
SELECT u.*, p.*
FROM users u
JOIN progress p
ON u.user_id = p.user_id;

-- 2. What are the Top 25 schools (.edu domains)?
-- ****************************************************************
SELECT COUNT(u.email_domain) AS "Number of Students", u.email_domain
FROM users u
GROUP BY email_domain
ORDER BY COUNT (u.email_domain) DESC
LIMIT 25;

-- How many .edu learners are located in New York? 
-- ****************************************************************
SELECT COUNT(*)
FROM users
WHERE email_domain LIKE '%.edu'
AND city = 'New York';

-- The mobile_app column contains either mobile-user or NULL. 
-- How many of these Codecademy learners are using the mobile app?
-- ****************************************************************
SELECT COUNT(*)
FROM users 
WHERE mobile_app LIKE 'mobile-user';

-- 3. Query for the sign up counts for each hour.
-- Refer to CodeAcademy to solve this question
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format 
-- ****************************************************************
SELECT strftime('%H', sign_up_at) AS sign_up_hour, COUNT(*) AS sign_up_count
FROM users
GROUP BY sign_up_hour
ORDER BY sign_up_hour;


-- 4. Do different schools (.edu domains) prefer different courses?
-- ****************************************************************
WITH join_table AS 
(SELECT *
FROM users u
JOIN progress p
ON u.user_id = p.user_id)
SELECT email_domain, 
COUNT(CASE WHEN learn_sql IN ('completed', 'started') THEN 1 END) AS "SQL", 
COUNT(CASE WHEN learn_cpp IN ('completed', 'started') THEN 1 END) AS "C++", 
COUNT(CASE WHEN learn_html IN ('completed', 'started') THEN 1 END) AS "HTML",
COUNT(CASE WHEN learn_javascript IN ('completed', 'started') THEN 1 END) AS "JavaScript",
COUNT(CASE WHEN learn_java IN ('completed', 'started') THEN 1 END) AS "Java", 
COUNT(email_domain) AS TOTAL
FROM join_table
GROUP BY email_domain
ORDER BY COUNT(email_domain) DESC
LIMIT 10;

-- What courses are the New Yorker Students taking?
SELECT city,
SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "C++",
SUM(CASE WHEN learn_sql NOT IN('') THEN 1 ELSE 0 END) AS "SQL",
SUM(CASE WHEN learn_html NOT IN('') THEN 1 ELSE 0 END) AS "HTML",
SUM(CASE WHEN learn_javascript NOT IN('') THEN 1 ELSE 0 END) AS "JavaScript",
SUM(CASE WHEN learn_java NOT IN('') THEN 1 ELSE 0 END) AS "Java",
COUNT(city) AS "Learners from New York"
FROM progress
JOIN users ON progress.user_id = users.user_id
WHERE city = "New York"
GROUP BY city;


-- What courses are the Chicago Students taking?
SELECT city,
SUM(CASE WHEN learn_cpp NOT IN('') THEN 1 ELSE 0 END) AS "C++",
SUM(CASE WHEN learn_sql NOT IN('') THEN 1 ELSE 0 END) AS "SQL",
SUM(CASE WHEN learn_html NOT IN('') THEN 1 ELSE 0 END) AS "HTML",
SUM(CASE WHEN learn_javascript NOT IN('') THEN 1 ELSE 0 END) AS "JavaScript",
SUM(CASE WHEN learn_java NOT IN('') THEN 1 ELSE 0 END) AS "Java",
COUNT(city) AS "Learners from Chicago"
FROM progress
JOIN users ON progress.user_id = users.user_id
WHERE city = "Chicago"
GROUP BY city;