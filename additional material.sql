CREATE TABLE t_radek_neckar_project_SQL_dodatecny_material AS
SELECT 
    e.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM t_radek_neckar_project_SQL_secondary_final e
WHERE e.year IN (
    SELECT rok FROM t_radek_neckar_project_SQL_primary_final
)
AND e.country <> 'Czech Republic'
ORDER BY e.country, e.year;
