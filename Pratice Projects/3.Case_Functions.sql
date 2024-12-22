SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        WHEN salary_year_avg < 60000 THEN 'Low salary'
        WHEN salary_year_avg > 100000 THEN 'High salary'
        ELSE 'Standard salary'
    END AS salary_categories
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

SELECT
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE then company_id END) AS wfh,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE then company_id END) AS nwfh
FROM
    job_postings_fact;

SELECT
    job_id,
    salary_year_avg,
    CASE
        WHEN job_title ILIKE '%Senior%' THEN 'Senior'
        WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Manager%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        ELSE 'Not Specified'
    END AS experience_level,
    CASE
        WHEN job_work_from_home = TRUE THEN 'Yes'
        WHEN job_work_from_home = FALSE THEN 'No'
    END AS remote_option
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    job_id