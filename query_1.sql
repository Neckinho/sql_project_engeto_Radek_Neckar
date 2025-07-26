
SELECT pib.name AS odvetvi, cp.payroll_year, AVG(cp.value) AS prumerna_mzda
FROM czechia_payroll cp
JOIN czechia_payroll_value_type pvt ON cp.value_type_code = pvt.code
JOIN czechia_payroll_industry_branch pib ON cp.industry_branch_code = pib.code
WHERE pvt.name = 'Průměrná hrubá mzda na zaměstnance'
GROUP BY pib.name, cp.payroll_year
ORDER BY pib.name, cp.payroll_year;
