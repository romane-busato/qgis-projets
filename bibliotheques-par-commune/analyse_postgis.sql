-- ============================================
-- ANALYSE DES BIBLIOTHÈQUES PAR COMMUNE
-- PostgreSQL / PostGIS — Haute-Garonne (31)
-- ============================================


-- --------------------------------------------
-- Requêtes attributaires
-- --------------------------------------------

-- Nombre de communes par tranches de population
SELECT 
	CASE WHEN population < 1000 THEN 'moins de 1000'
	WHEN population < 5000 THEN 'entre 1000 et 5000'
	WHEN population < 10000 THEN 'entre 5000 et 10000'
	ELSE 'plus de 10000'
	END AS tranches_pop, 
	COUNT(*) as nb_communes
FROM communes
GROUP BY tranches_pop
ORDER BY nb_communes DESC;

-- --------------------------------------------
-- Requêtes spatiales
-- --------------------------------------------

-- surface de chaque commune en km²
SELECT nom_offici, ROUND((ST_AREA(geom)/1000000)::numeric, 2) AS surface_km2
FROM communes
ORDER BY ST_AREA(geom) DESC
LIMIT 20;

-- centroide de chaque commune
SELECT nom_offici, ST_X(ST_Centroid(geom)) AS longitude, ST_Y(ST_Centroid(geom)) AS latitude
FROM communes
ORDER BY population DESC
LIMIT 10;

-- --------------------------------------------
-- Requêtes de proximité
-- --------------------------------------------

-- bibliothèque la plus proche de chaque commune
SELECT c.nom_offici as commune, 
	b.nom_de_l_e as bibliotheque_proche, 
	ROUND((ST_Distance(c.geom, b.geom)/1000)::numeric, 2) as dist_km
FROM communes c CROSS JOIN LATERAL (
	SELECT nom_de_l_e, geom
	FROM bibliotheques
	ORDER BY c.geom <-> geom ASC
	LIMIT 1
	) b
ORDER BY dist_km ASC;

-- Communes à moins de 20km de Toulouse (on utilise le centroide de Toulouse)
SELECT nom_offici, 
	ROUND((ST_Distance(geom, 
	ST_SetSRID(
	ST_MakePoint(
	(SELECT ST_X(ST_Centroid(geom)) FROM communes WHERE nom_offici='Toulouse'),
	(SELECT ST_Y(ST_Centroid(geom)) FROM communes WHERE nom_offici='Toulouse'))
	, 2154))/1000)::numeric, 2) 
	AS dist_from_Toulouse_km
FROM communes
WHERE ST_DWithin(geom, ST_SetSRID(
	ST_MakePoint(
	(SELECT ST_X(ST_Centroid(geom)) FROM communes WHERE nom_offici='Toulouse'),
	(SELECT ST_Y(ST_Centroid(geom)) FROM communes WHERE nom_offici='Toulouse'))
	, 2154), 20000)
ORDER BY dist_from_Toulouse_km;

-- --------------------------------------------
-- Jointures spatiales
-- --------------------------------------------

-- Nombre de bibliothèques par commune
SELECT c.nom_offici as commune, c.population as population, COUNT(b.geom) as nb_bibliotheques
FROM communes c LEFT JOIN bibliotheques b ON ST_Contains(c.geom, b.geom)
GROUP BY c.population, c.nom_offici
ORDER BY nb_bibliotheques DESC;

-- Communes sans bibliothèque
SELECT c.nom_offici as commune, c.population as population
FROM communes c LEFT JOIN bibliotheques b ON ST_Contains(c.geom, b.geom)
WHERE b.geom IS NULL
ORDER BY c.population DESC;
