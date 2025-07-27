
--Data Cleaning Project:
-- Remove duplicates
--standardise data
--deal with null/ blank values
--remove any columns

ALTER TABLE portfolioprojects-457720.Layoffs.Layoffs_Staging 
RENAME COLUMN string_field_0 TO company,
RENAME COLUMN string_field_1 TO location,
RENAME COLUMN string_field_2 TO industry,
RENAME COLUMN string_field_3 TO total_laid_off,
RENAME COLUMN string_field_4 TO percentage_laid_off,
RENAME COLUMN string_field_5 TO date,
RENAME COLUMN string_field_6 TO stage,
RENAME COLUMN string_field_7 TO country,
RENAME COLUMN string_field_8 TO raised_funds_millions

-- checking for duplicates
-- duplicates: casper, cazoo,hibob,wildlife studios, yahoo

WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
  PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, stage, country, raised_funds_millions) AS row_num
  FROM Layoffs
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1 
--Checking Casper to see if there is a duplicate
SELECT *
FROM Layoffs
WHERE company = 'Casper'



WITH duplicate_cte AS (
SELECT *,
ROW_NUMBER() OVER(
  PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, stage, country, raised_funds_millions) AS row_num
  FROM Layoffs
)
SELECT * 
FROM duplicate_cte

-- Uploaded new table and removed any instances where there are duplicates
SELECT *
FROM Layoffs
WHERE row_num = 1

--STANDARDISING DATA
SELECT company, TRIM(company)
FROM Layoffs 

UPDATE Layoffs
SET company = TRIM(company)


--changed to Dbeaver because of paid features on Google BigQuery
--trimming layoffs
UPDATE Layoffs 

SET company = TRIM(company)

--checking
SELECT *
FROM layoffs

-- checking data, there are null values, duplicates and blanks
SELECT DISTINCT(industry)
FROM layoffs
--updating crypto duplicates
SELECT *
FROM Layoffs 
WHERE industry LIKE 'Crypto%'

UPDATE Layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
-- Malmo is also shown as Malmo with umlaut, need to be changed, someone also put United States. instead of United States
SELECT DISTINCT location
FROM layoffs

/*SELECT 
  DISTINCT(country), 
  TRIM(TRAILING '.' FROM country) AS trimmed_country
FROM layoffs;
This would also work but I am using SQLite*/
-- Removing USA type
UPDATE layoffs
SET country = 'United States of America'
WHERE country = 'United States of America.'

SELECT DISTINCT(country)
FROM layoffs

/*
date column is a string not a date format, however SQLite does not have a strict date datatype

SELECT date,
STRFTIME(date)
FROM layoffs

SELECT 'date',
STR_TO_DATE(date, %m/%d/%Y)
FROM layoffs

ALTER TABLE layoffs
MODIFY COLUMN date DATE
*/

//Typical IS NULL function wasnt working so I used this as a workaround

SELECT *
FROM layoffs
WHERE total_laid_off = 'NULL'
AND percentage_laid_off = 'NULL';

SELECT DISTINCT(industry) 
FROM Layoffs 
WHERE total_laid_off = 'NULL'
OR percentage_laid_off = "NULL"

SELECT * 
FROM Layoffs 
WHERE industry = 'NULL'
OR industry = '';

SELECT *
FROM Layoffs 
WHERE company = 'Airbnb';

SELECT a.industry,b.industry
FROM Layoffs a
JOIN Layoffs b ON (a.company = b.company)
WHERE (a.industry = 'NULL' OR a.industry = '')
AND b.industry <> 'NULL'

-- attempts to change nulls failed
UPDATE Layoffs AS a
JOIN Layoffs AS b ON (a.company = b.company)
SET a.industry = b.industry
WHERE (a.industry = 'NULL' OR a.industry = '')
AND b.industry <> 'NULL';

UPDATE Layoffs AS a
JOIN Layoffs AS b ON a.company = b.company
SET a.industry = b.industry
WHERE (a.industry IS NULL OR a.industry = '')
AND b.industry IS NOT NULL AND b.industry <> '';
--successful update to nulls
UPDATE Layoffs
SET industry = (
    SELECT b.industry
    FROM Layoffs AS b
    WHERE b.company = Layoffs.company
      AND b.industry IS NOT NULL
      AND b.industry != ''
    LIMIT 1
)
WHERE (industry IS NULL OR industry = '');

SELECT industry
FROM layoffs 
--one  is still not filled, but this is because there is no other row which has its industry
SELECT *
FROM Layoffs l 
SELECT * FROM layoffs WHERE company = "Bally's Interactive"

/* DElETE FROM Layoffs 
WHERE total_laid_off IS NULL 	
AND percentage_laid_off IS NULL

This could possibly be deleted but i kept it anyway*/
ALTER TABLE Layoffs 
DROP COLUMN row_num

SELECT * FROM layoffs
