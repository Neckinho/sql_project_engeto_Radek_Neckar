
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
