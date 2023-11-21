-- SELECT
-- 1- Selezionare tutte le software house americane (3)
SELECT * FROM `software_houses` 
WHERE `country` = "United States";

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT * FROM `players` 
WHERE `city` = "Rogahnland";

-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT * FROM `players` 
WHERE `name` LIKE "%a";

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT * FROM `reviews` 
WHERE `player_id`= 800;

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT(*) FROM `tournaments` 
WHERE `year` = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT * FROM `awards` 
WHERE `description` LIKE "%facere%";

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT `videogame_id` FROM `category_videogame` WHERE `category_id` = 2 OR `category_id`= 6;

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT * FROM `reviews` 
WHERE `rating`>= 2 AND `rating`<= 4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT * FROM `videogames` 
WHERE `release_date` 
BETWEEN '2020-01-01' AND '2020-12-31';

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT `videogame_id` FROM `reviews` 
WHERE `rating`= 5;

-- *********** BONUS ***********
-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)
SELECT COUNT(`id`) AS totale_reviews, AVG(`rating`) AS metascore
FROM `reviews`
WHERE `videogame_id`= 412;
-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(`id`)
FROM `videogames`
WHERE `software_house_id`= 1 
AND `release_date` 
BETWEEN '2018-01-01' AND '2018-12-31';
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GROUP BY
-- 1- Contare quante software house ci sono per ogni paese (3)
SELECT `country`, COUNT(`id`) AS total_records
FROM `software_houses`
GROUP BY `country`;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT `videogame_id`, COUNT(`id`)
FROM `reviews`
GROUP BY `videogame_id`;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT `pegi_label_id`, COUNT(`videogame_id`)
FROM `pegi_label_videogame`
GROUP BY `pegi_label_id`;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(`release_date`) AS release_year, COUNT(*) AS total_games
FROM `videogames`
GROUP BY YEAR(`release_date`)
ORDER BY release_year;

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT `device_id` AS platform, 
COUNT(`videogame_id`) AS total_games
FROM `device_videogame`
GROUP BY `device_id`;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT `videogame_id` AS videogame, AVG(`rating`) AS average_rat
FROM `reviews`
GROUP BY `videogame_id`
ORDER BY average_rat DESC;
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- JOIN
-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT p.*
FROM `players` p
JOIN `reviews` r ON p.`id` = r.`player_id`
GROUP BY p.`id`;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT vg.*
FROM `videogames` vg
JOIN `tournament_videogame` trnm 
ON vg.`id` = trnm.`videogame_id`
JOIN `tournaments` t 
ON trnm.`tournament_id` = t.`id`
WHERE t.`year` = 2016
GROUP BY vg.`id`;

-- 3- Mostrare le categorie di ogni videogioco (1718)
SELECT DISTINCT v.*, c.`name`
FROM `videogames` v
JOIN `category_videogame` cv ON v.`id` = cv.`videogame_id`
JOIN `categories` c ON cv.`category_id` = c.`id`
ORDER BY v.`id`

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT sh.*
FROM `software_houses` sh
JOIN `videogames` vg
ON vg.`software_house_id` = sh.`id`
WHERE YEAR(vg.`release_date`) > 2020

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT DISTINCT aw.* 
FROM `award_videogame` aw 
JOIN `videogames` vg ON aw.`videogame_id` = vg.`id` 
JOIN `software_houses` sh ON vg.`software_house_id` = sh.`id`;

-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT v.*, c.`name`, pl.`name`
FROM `videogames` v
JOIN `category_videogame` cv ON v.`id` = cv.`videogame_id`
JOIN `categories` c ON cv.`category_id` = c.`id`
JOIN `pegi_label_videogame` plv ON v.`id` = plv.`videogame_id`
JOIN `pegi_labels` pl ON plv.`pegi_label_id` = pl.`id`
JOIN `reviews` r ON v.`id` = r.`videogame_id`
WHERE r.`rating` IN (4, 5);


-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT v.*
FROM `videogames` v
JOIN `tournament_videogame` tv ON v.`id` = tv.`videogame_id`
JOIN `tournaments` t ON tv.`tournament_id` = t.`id`
JOIN `player_tournament` pt ON t.`id` = pt.`tournament_id`
JOIN `players` p ON pt.`player_id` = p.`id`
WHERE p.`name` LIKE 'S%';


-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT t.`city`
FROM `tournaments` t
JOIN `tournament_videogame` tv ON t.`id` = tv.`tournament_id`
JOIN `videogames` v ON tv.`videogame_id` = v.`id`
JOIN `award_videogame` av ON v.`id` = av.`videogame_id`
JOIN `awards` a ON av.`award_id` = a.`id`
WHERE a.`name` = "Gioco dell'anno" AND av.`year` = 2018;

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
-- *********** BONUS ***********
-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)
-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : potrebbe uscire 449 o 398, sono entrambi a 20)
-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : potrebbe uscire 3 o 1, sono entrambi a 3)
-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 2 (10)