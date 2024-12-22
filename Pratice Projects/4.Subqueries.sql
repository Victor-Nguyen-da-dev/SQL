-- Test
    SELECT 
        sjd.skill_id,
        COUNT(sjd.job_id) AS job_count
    FROM
        skills_job_dim as sjd
    GROUP BY
        sjd.skill_id
    ORDER BY
        job_count DESC
    LIMIT 5


SELECT
    sd.skills
FROM
    skills_dim AS sd
INNER JOIN (
    SELECT 
        sjd.skill_id,
        COUNT(sjd.job_id) AS job_count
    FROM
        skills_job_dim as sjd
    GROUP BY
        sjd.skill_id
    ORDER BY
        job_count DESC
    LIMIT 5
) AS skill_count ON skill_count.skill_id = sd.skill_id
ORDER BY
    skill_count.job_count


SELECT
    company_id,
    name,
    CASE
        WHEN job_posts < 10 THEN 'Small'
        WHEN job_posts BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Large'
    END AS size
FROM (
    SELECT
    cd.company_id,
    cd.name,
    COUNT(jpf.job_id) as job_posts
    FROM
    company_dim AS cd
    INNER JOIN job_postings_fact AS jpf ON jpf.company_id = cd.company_id
    GROUP BY
    cd.company_id,
    cd.name
) AS company_job_count;

SELECT
        name
FROM
    (
        SELECT
            cd.company_id,
            cd.name,
            AVG(jpf.salary_year_avg) AS company_avg_salary
        FROM
            company_dim AS cd
            INNER JOIN job_postings_fact AS jpf ON jpf.company_id = cd.company_id
        WHERE
            jpf.salary_year_avg IS NOT NULL
        GROUP BY
            cd.company_id,
            cd.name
        ORDER BY
            cd.company_id
        )
WHERE
    company_avg_salary > (SELECT
    AVG(salary_year_avg)
    FROM
        job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL)
ORDER BY
    company_avg_salary DESC

-- ALT
SELECT 
    company_dim.name
FROM 
    company_dim
INNER JOIN (
    SELECT 
			company_id, 
			AVG(salary_year_avg) AS avg_salary
    FROM job_postings_fact
    GROUP BY company_id
    ) AS company_salaries ON company_dim.company_id = company_salaries.company_id
WHERE company_salaries.avg_salary > (
    SELECT AVG(salary_year_avg)
    FROM job_postings_fact
);

SELECT
com.name
FROM company_dim as com
INNER JOIN (
    SELECT
    company_id,
    AVG(salary_year_avg) as company_avg_salary
    FROM job_postings_fact
    WHERE salary_year_avg is not null
    GROUP BY company_id
        ) as c on com.company_id = c.company_id
WHERE c.company_avg_salary > (
SELECT
AVG(salary_year_avg) as company_avg_salary
FROM job_postings_fact
WHERE salary_year_avg is not null
);