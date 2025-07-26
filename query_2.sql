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
