(SELECT
    job_id,
    job_title,
    'With Salary Info' AS salary_info
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL)
UNION ALL
(SELECT
    job_id,
    job_title,
    'Without Salary Info' AS salary_info
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NULL AND salary_year_avg IS NULL)
ORDER BY
    salary_info DESC,
    job_id

SELECT
    q1p.job_id,
    q1p.job_title_short,
    q1p.job_location,
    q1p.job_via,
    sd.skills,
    sd.type
FROM
    (SELECT*
    FROM january_month
    UNION ALL
    SELECT*
    FROM february_month
    UNION ALL
    SELECT*
    FROM march_month) AS q1p
LEFT JOIN skills_job_dim AS sjd ON sjd.job_id = q1p.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE
    q1p.salary_year_avg > 70000
ORDER BY
	q1p.job_id;

WITH fqd AS (
    SELECT*
    FROM january_month
    UNION ALL
    SELECT*
    FROM february_month
    UNION ALL
    SELECT*
    FROM march_month
), jps AS (
    SELECT
    sd.skills,
    EXTRACT(MONTH FROM fqd.job_posted_date) AS posting_month,
    EXTRACT(YEAR FROM fqd.job_posted_date) AS posting_year,
    COUNT(sjd.job_id) AS jobs_per_skill
    FROM
    skills_dim AS sd
    INNER JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
    INNER JOIN fqd ON fqd.job_id = sjd.job_id
    GROUP BY
    sd.skills, 
    posting_month,
    posting_year
)
SELECT
skills,
posting_month,
posting_year,
jobs_per_skill
FROM
jps
ORDER BY
skills, posting_month, posting_year
