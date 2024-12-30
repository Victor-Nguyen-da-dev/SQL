WITH in_demand_skills AS (
    SELECT
    sd.skill_id,
    skills,
    COUNT(sd.skill_id) AS skill_counts
FROM
    skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
INNER JOIN job_postings_fact AS jpf ON sjd.job_id = jpf.job_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sd.skill_id,
    skills
ORDER BY
    skill_counts DESC
LIMIT 10
), 
average_salary AS (
    SELECT
    skills_dim.skill_id,
    AVG(salary_year_avg) AS avg_salary_skill
FROM
    skills_dim
INNER JOIN skills_job_dim ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
ORDER BY
    avg_salary_skill DESC)
SELECT
    skills,
    skill_counts,
    ROUND(average_salary.avg_salary_skill, 2) AS avg_salary
FROM
    in_demand_skills
INNER JOIN average_salary ON average_salary.skill_id = in_demand_skills.skill_id
ORDER BY
    skill_counts DESC,
    avg_salary DESC


-- Alternative Shortened version 

SELECT
    sd.skill_id,
    skills,
    COUNT(sd.skill_id) AS skill_counts,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM
    skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
INNER JOIN job_postings_fact AS jpf ON sjd.job_id = jpf.job_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    sd.skill_id
HAVING
    COUNT(sd.skill_id) > 10
ORDER BY
    avg_salary DESC
LIMIT 15