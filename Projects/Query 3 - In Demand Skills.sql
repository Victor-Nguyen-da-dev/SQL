SELECT
    skills,
    COUNT(sd.skill_id) AS skill_counts
FROM
    skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sjd.skill_id = sd.skill_id
INNER JOIN job_postings_fact AS jpf ON sjd.job_id = jpf.job_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_counts DESC
LIMIT 10