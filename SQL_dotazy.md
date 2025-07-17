-- Vytvoření primární tabulky
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

-- Vytvoření sekundární tabulky
CREATE TABLE t_radek_neckar_project_SQL_secondary_final AS
SELECT 
    e.country,
    e.year,
    e.gdp,
    e.gini,
    e.population
FROM economies e
JOIN countries c ON e.country = c.country
WHERE c.continent = 'Europe';

-- Dodatečný materiál - evropské státy ve stejném období jako ČR
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

1.Dotaz

SELECT pib.name AS odvetvi, cp.payroll_year, AVG(cp.value) AS prumerna_mzda
FROM czechia_payroll cp
JOIN czechia_payroll_value_type pvt ON cp.value_type_code = pvt.code
JOIN czechia_payroll_industry_branch pib ON cp.industry_branch_code = pib.code
WHERE pvt.name = 'Průměrná hrubá mzda na zaměstnance'
GROUP BY pib.name, cp.payroll_year
ORDER BY pib.name, cp.payroll_year;

2.Dotaz

SELECT 
    p.rok,
    ROUND( CAST(p.prumerna_mzda / p.cena_chleba AS numeric), 2 ) AS kg_chleba,
    ROUND( CAST(p.prumerna_mzda / p.cena_mleka AS numeric), 2 ) AS litry_mleka
FROM t_radek_neckar_project_SQL_primary_final p
WHERE p.rok IN (
    SELECT MIN(rok) FROM t_radek_neckar_project_SQL_primary_final
    WHERE cena_chleba IS NOT NULL AND cena_mleka IS NOT NULL
    UNION ALL
    SELECT MAX(rok) FROM t_radek_neckar_project_SQL_primary_final
    WHERE cena_chleba IS NOT NULL AND cena_mleka IS NOT NULL
);


3.Dotaz

WITH prumerne_ceny AS (
    SELECT 
        pc.name AS kategorie,
        EXTRACT(YEAR FROM cp.date_from) AS rok,
        ROUND(CAST(AVG(cp.value) AS numeric), 2) AS prumerna_cena
    FROM czechia_price cp
    JOIN czechia_price_category pc ON cp.category_code = pc.code
    GROUP BY pc.name, EXTRACT(YEAR FROM cp.date_from)
),

mezirocni_narusty AS (
    SELECT 
        kategorie,
        rok,
        prumerna_cena,
        LAG(prumerna_cena) OVER (PARTITION BY kategorie ORDER BY rok) AS predchozi_cena,
        CASE 
            WHEN LAG(prumerna_cena) OVER (PARTITION BY kategorie ORDER BY rok) IS NOT NULL
            THEN ROUND( CAST( (prumerna_cena - LAG(prumerna_cena) OVER (PARTITION BY kategorie ORDER BY rok)) / LAG(prumerna_cena) OVER (PARTITION BY kategorie ORDER BY rok) * 100 AS numeric), 2)
            ELSE NULL
        END AS mezirocni_narust
    FROM prumerne_ceny
),

prumerne_narusty AS (
    SELECT 
        kategorie,
        ROUND(AVG(mezirocni_narust), 2) AS prumerny_rocni_narust
    FROM mezirocni_narusty
    WHERE mezirocni_narust IS NOT NULL
    GROUP BY kategorie
)

SELECT 
    kategorie,
    prumerny_rocni_narust
FROM prumerne_narusty
ORDER BY prumerny_rocni_narust ASC
LIMIT 1;


4.Dotaz


WITH data_s_rustem AS (
    SELECT 
        rok,
        prumerna_mzda,
        (cena_chleba + cena_mleka) / 2 AS prumerna_cena_potravin,
        LAG(prumerna_mzda) OVER (ORDER BY rok) AS predchozi_mzda,
        LAG((cena_chleba + cena_mleka) / 2) OVER (ORDER BY rok) AS predchozi_cena
    FROM t_radek_neckar_project_SQL_primary_final
),

vypocet_rustu AS (
    SELECT 
        rok,
        ROUND(CAST( ((prumerna_cena_potravin - predchozi_cena) / predchozi_cena) * 100 AS numeric), 2) AS rust_cen,
        ROUND(CAST( ((prumerna_mzda - predchozi_mzda) / predchozi_mzda) * 100 AS numeric), 2) AS rust_mezd
    FROM data_s_rustem
    WHERE predchozi_cena IS NOT NULL AND predchozi_mzda IS NOT NULL
)

SELECT *
FROM vypocet_rustu
WHERE (rust_cen - rust_mezd) > 10;


5.Dotaz

WITH cz_hdp AS (
    SELECT 
        year AS rok,
        gdp
    FROM t_radek_neckar_project_SQL_secondary_final
    WHERE country = 'Czech Republic'
),

hdp_rust AS (
    SELECT 
        rok,
        ROUND(CAST(((gdp - LAG(gdp) OVER (ORDER BY rok)) / LAG(gdp) OVER (ORDER BY rok)) * 100 AS numeric), 2) AS rust_hdp
    FROM cz_hdp
),

mzdy_ceny_rust AS (
    SELECT 
        rok,
        ROUND(CAST(((prumerna_mzda - LAG(prumerna_mzda) OVER (ORDER BY rok)) / LAG(prumerna_mzda) OVER (ORDER BY rok)) * 100 AS numeric), 2) AS rust_mezd,
        ROUND(CAST((((cena_chleba + cena_mleka)/2 - LAG((cena_chleba + cena_mleka)/2) OVER (ORDER BY rok)) / LAG((cena_chleba + cena_mleka)/2) OVER (ORDER BY rok)) * 100 AS numeric), 2) AS rust_cen
    FROM t_radek_neckar_project_SQL_primary_final
),

spojene AS (
    SELECT 
        hdp_rust.rok,
        hdp_rust.rust_hdp,
        mzdy_ceny_rust.rust_mezd,
        mzdy_ceny_rust.rust_cen
    FROM hdp_rust
    JOIN mzdy_ceny_rust ON hdp_rust.rok = mzdy_ceny_rust.rok
)

SELECT * FROM spojene
ORDER BY rok;
