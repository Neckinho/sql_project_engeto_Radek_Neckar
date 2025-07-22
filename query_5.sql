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