SELECT 
    job_schedule_type,
    AVG(salary_year_avg),
    AVG(salary_hour_avg)
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-1'
GROUP BY
    job_schedule_type
ORDER BY
    job_schedule_type;

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS months,
    COUNT(*) AS posting_counts
FROM
    job_postings_fact
GROUP BY
    months
ORDER BY
    months;

SELECT
    cd.name,
    COUNT(jpf.job_id) AS postings_count
FROM
    job_postings_fact AS jpf
    LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
WHERE
    EXTRACT(QUARTER FROM job_posted_date) = 2
    AND jpf.job_health_insurance = TRUE
GROUP BY
    cd.name
HAVING
    COUNT(jpf.job_id) > 0
ORDER BY
    postings_count DESC

#in this scenario, since nothing is left excluded, it makes no real difference if right, inner or left JOIN
