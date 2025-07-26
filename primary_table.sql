CREATE TABLE t_radek_neckar_project_SQL_primary_final AS
SELECT 
    p.payroll_year AS rok,
    AVG(p.value) AS prumerna_mzda,
    AVG(CASE WHEN pc.name = 'Mléko polotučné pasterované' THEN cp.value END) AS cena_mleka,
    AVG(CASE WHEN pc.name = 'Chléb konzumní kmínový' THEN cp.value END) AS cena_chleba
FROM czechia_payroll p
JOIN czechia_payroll_value_type pvt ON p.value_type_code = pvt.code
LEFT JOIN czechia_price cp ON EXTRACT(YEAR FROM cp.date_from) = p.payroll_year
LEFT JOIN czechia_price_category pc ON cp.category_code = pc.code
WHERE pvt.name = 'Průměrná hrubá mzda na zaměstnance'
GROUP BY p.payroll_year
ORDER BY p.payroll_year;
