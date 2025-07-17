# Odpovědi na výzkumné otázky – SQL projekt

## Otázka 1:
**Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

✅ Odpověď:  
V datech je patrné, že **průměrná hrubá mzda roste ve většině odvětví stabilně**.  
V některých odvětvích došlo k poklesům v jednotlivých letech (např. během ekonomických krizí), ale dlouhodobě trend ukazuje růst.

---

## Otázka 2:
**Kolik si bylo možné koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?**

✅ Odpověď:

| Rok   | Kg chleba | Litry mléka |
|--------|----------|-------------|
| 2006   | 1282.41  | 1432.14     |
| 2018   | 1340.23  | 1639.21     |

Interpretace:  
Občané si v roce 2018 mohli za průměrnou mzdu koupit **více potravin než v roce 2006**, což znamená zlepšení kupní síly.

---

## Otázka 3:
**Která kategorie potravin zdražuje nejpomaleji (má nejnižší meziroční nárůst)?**

✅ Odpověď:

| Kategorie       | Průměrný meziroční růst (%) |
|----------------|-----------------------------|
| **Cukr krystalový** | **-1.92 %**                |

Interpretace:  
Cukr krystalový **nezdražuje, ale naopak zlevňuje**, což ho činí nejstabilnější potravinou z pohledu ceny.

---

## Otázka 4:
**Existuje rok, kdy ceny potravin rostly výrazně více než mzdy (více než o 10 %)?**

✅ Odpověď:

| Rok  | Růst cen (%) | Růst mezd (%) |
|------|--------------|--------------|
| 2008 | 18.51        | 7.87         |
| 2011 | 14.09        | 2.31         |

Interpretace:  
V roce 2008 a 2011 ceny potravin výrazně předběhly růst mezd. V obou případech rozdíl překročil hranici 10 %.

---

## Otázka 5:
**Má výška HDP vliv na změny mezd a cen potravin?**

✅ Odpověď:

| Rok  | Růst HDP (%) | Růst mezd (%) | Růst cen (%) |
|------|--------------|--------------|--------------|
| 2007 | 6.2          | 7.5          | 4.0          |
| 2008 | 3.0          | 7.0          | 18.5         |
| 2011 | 2.1          | 2.3          | 14.1         |

Interpretace:  
V datech je vidět částečná korelace mezi růstem HDP a mzdami.  
U cen potravin však vliv HDP není tak přímý – růst cen v některých letech předbíhal růst HDP i mezd (zejména v krizových letech).

---


Vyhotovil Radek Neckař.
