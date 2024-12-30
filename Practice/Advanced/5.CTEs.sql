WITH distinct_jobs AS (
    SELECT
        DISTINCT jpf.job_title,
        cd.name
    FROM
        company_dim AS cd
    INNER JOIN job_postings_fact AS jpf ON jpf.company_id = cd.company_id)
SELECT 
    name,
    COUNT(job_title) as unique_count
FROM
    distinct_jobs
GROUP BY
    name
ORDER BY
    unique_count DESC
LIMIT 10


WITH avg_salaries AS (
    SELECT
        job_country,
        AVG(salary_year_avg) as avg_salary
    FROM
        job_postings_fact
    GROUP BY
        job_country)
SELECT
    jpf.job_id,
    jpf.job_title,
    cd.name,
    jpf.salary_year_avg AS salary_rate,
    CASE
        WHEN jpf.salary_year_avg > avg_salaries.avg_salary THEN 'ABOVE AVERAGE'
        ELSE 'BELOW AVERAGE'
    END AS salary_rank,
    EXTRACT(MONTH FROM jpf.job_posted_date) AS month_posted
FROM
    job_postings_fact AS jpf
INNER JOIN company_dim AS cd ON jpf.company_id = cd.company_id
INNER JOIN avg_salaries ON avg_salaries.job_country = jpf.job_country
ORDER BY
    month_posted DESC

WITH skills_count AS (
    SELECT
    cd.company_id,
    COUNT(DISTINCT sjd.skill_id) AS unique_skills_count
    FROM
    company_dim AS cd
    LEFT JOIN job_postings_fact as jpf ON jpf.company_id = cd.company_id
    LEFT JOIN skills_job_dim as sjd ON sjd.job_id = jpf.job_id
    GROUP BY
    cd.company_id
),
    max_salary AS(
    SELECT
    jpf.company_id,
    MAX(jpf.salary_year_avg) AS highest_avg_salary
    FROM
    job_postings_fact AS jpf
    WHERE
    jpf.job_id IN (SELECT job_id FROM skills_job_dim) -- due to skills_job_dim only having job_id with at least one skill id, we will only get salaries from jobs which has at least one skill
    GROUP BY
    jpf.company_id
)
SELECT
cd.name,
skills_count.unique_skills_count AS unique_skills_required,
max_salary.highest_avg_salary
FROM
company_dim AS cd
LEFT JOIN skills_count ON skills_count.company_id = cd.company_id
LEFT JOIN max_salary ON max_salary.company_id = cd.company_id
ORDER BY
cd.name