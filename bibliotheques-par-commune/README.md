\# Répartition des bibliothèques publiques par commune



!\[Carte](carte\_choroplèthe\_bibliothèques\_31.png)



\## Objectif

Visualiser la répartition des bibliothèques publiques par commune 

sur le département de la Haute-Garonne.



\## Données utilisées

\- \*\*IGN BD TOPO\*\* — limites communales (cartes.gouv.fr)

\- \*\*Adresses des bibliothèques des collectivités territoriales\*\* (data.gouv.fr, Ministère de la Culture)



\## Méthode

1\. Chargement des données communales IGN en Lambert 93 (EPSG:2154)

2\. Chargement et reprojection des bibliothèques (WGS84 → Lambert 93)

3\. Filtrage des couches sur le département 31

3\. Comptage par commune via jointure spatiale

4\. Carte choroplèthe avec classification manuelle



\## Limites

Le jeu de données national peut présenter des lacunes locales — 

certaines bibliothèques départementales peuvent ne pas y figurer. 

Les données des adresses des bibliothèques ont été mises à jour pour la dernière 

fois le 27/08/2025



\## Outils

QGIS · Lambert 93 (EPSG:2154) · données vecteur

