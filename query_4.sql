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
