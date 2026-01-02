CREATE DATABASE ai_job_dataset;
#1. Total job postings
SELECT COUNT(*) AS total_jobs
FROM ai_job_dataset;
#2. Unique job titles
SELECT DISTINCT job_title
FROM ai_job_dataset;
#3. Job count per job title
SELECT job_title, COUNT(*) AS job_count
FROM ai_job_dataset
GROUP BY job_title
ORDER BY job_count DESC;
#4.Top 10 hiring companies
SELECT company_name, COUNT(*) AS job_count
FROM ai_job_dataset
GROUP BY company_name
ORDER BY job_count DESC
LIMIT 10;
#5.Average salary by job title
SELECT job_title, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY job_title;
#6.Highest average salary role
SELECT job_title, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 1;
#7.Min, Max, Avg salary
SELECT 
    MIN(salary_usd) AS min_salary,
    MAX(salary_usd) AS max_salary,
    ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset;
#8.Unique locations
SELECT DISTINCT company_location
FROM ai_job_dataset;
#9. Average salary by location
SELECT company_location, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY company_location
ORDER BY avg_salary DESC;
#10. Top paying locations
SELECT company_location, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY company_location
ORDER BY avg_salary DESC
LIMIT 10;
#11. Job count by experience level
SELECT experience_level, COUNT(*) AS job_count
FROM ai_job_dataset
GROUP BY experience_level;
#12. Avg salary by experience level
SELECT experience_level, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY experience_level;
#13. Most demanded experience level
SELECT experience_level, COUNT(*) AS demand
FROM ai_job_dataset
GROUP BY experience_level
ORDER BY demand DESC
LIMIT 1;
#14. Job count by employment type
SELECT employment_type, COUNT(*) AS job_count
FROM ai_job_dataset
GROUP BY employment_type;
#15. Highest paying employment type
SELECT employment_type, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY employment_type
ORDER BY avg_salary DESC
LIMIT 1;
#16. Most demanded skills
SELECT required_skills, COUNT(*) AS demand
FROM ai_job_dataset
GROUP BY required_skills
ORDER BY demand DESC;
#17. Skills in high-paying jobs (above avg salary)
SELECT required_skills, COUNT(*) AS count
FROM ai_job_dataset
WHERE salary_usd > (SELECT AVG(salary_usd) FROM ai_job_dataset)
GROUP BY required_skills
ORDER BY count DESC;
#18. Jobs requiring specific skills (example: Python)
SELECT COUNT(*) AS python_jobs
FROM ai_job_dataset
WHERE required_skills LIKE '%Python%';
#19. Skills for Data Analyst roles
SELECT salary_usd, COUNT(*) AS demand
FROM ai_job_dataset
WHERE job_title LIKE '%Data Analyst%'
GROUP BY salary_usd
ORDER BY demand DESC;
#20. Companies with highest avg salary
SELECT company_name, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY company_name
ORDER BY avg_salary DESC
LIMIT 10;
#21. Companies hiring for multiple roles
SELECT company_name, COUNT(DISTINCT job_title) AS roles
FROM ai_job_dataset
GROUP BY company_name
HAVING roles > 1;
#22.Industry-wise job count
SELECT industry, COUNT(*) AS job_count
FROM ai_job_dataset
GROUP BY industry
ORDER BY job_count DESC;
#23. Avg salary by industry
SELECT industry, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY industry
ORDER BY avg_salary DESC;
#24. Highest paying industry
SELECT industry, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY industry
ORDER BY avg_salary DESC
LIMIT 1;
#25. Rank job titles by salary
SELECT job_title, ROUND(AVG(salary_usd),2) AS avg_salary,
RANK() OVER (ORDER BY AVG(salary_usd) DESC) AS salary_rank
FROM ai_job_dataset
GROUP BY job_title;
#26. Top 3 paying jobs per location
SELECT *
FROM (
    SELECT job_title, company_location, salary_usd,
    RANK() OVER (PARTITION BY company_location ORDER BY salary_usd DESC) AS rnk
    FROM ai_job_dataset
) t
WHERE rnk <= 3;
#27. Salary trend by experience
SELECT experience_level, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY experience_level
ORDER BY avg_salary;
#28. High demand but low salary locations
SELECT company_location, COUNT(*) AS jobs, ROUND(AVG(salary_usd),2) AS avg_salary
FROM ai_job_dataset
GROUP BY company_location
HAVING jobs > (SELECT AVG(cnt) FROM (SELECT COUNT(*) cnt FROM ai_job_dataset GROUP BY company_location) x)
AND avg_salary < (SELECT AVG(salary_usd) FROM ai_job_dataset);
#29. View for high-paying jobs
CREATE VIEW high_paying_jobs AS
SELECT *
FROM ai_job_dataset
WHERE salary_usd > (SELECT AVG(salary_usd) FROM ai_job_dataset);
