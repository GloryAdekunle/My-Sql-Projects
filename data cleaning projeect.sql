-- DATA CLEANING--

-- NOTE: Always duplicate the dataset to work on the duplicate and not the raw dataset

-- 1 Remove DUplicates
-- 2 Standardize the dataset
-- 3 Null values or Blank Values 
-- 4 Remove any columns


SELECT *
FROM layoffs;


CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte as 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- TO DELETE THE DUPLICATE ---
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;


 SELECT *
 FROM layoffs_staging2
 WHERE row_num > 1;
 
 DELETE
 FROM layoffs_staging2
 WHERE row_num > 1;
 
 SELECT *
 FROM layoffs_staging2;
 
 
 -- STANDARDIZING DATA --
 
 SELECT company,  (TRIM(COMPANY))
 FROM layoffs_staging2; 
 
 UPDATE layoffs_stagings2
 SET company = TRIM(company);
 
 SELECT *
 FROM layoffs_staging2;
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%' ; 
 
 UPDATE layoffs_staging2
 SET industry = 'Crypto'
 WHERE industry  LIKE 'Crypto%';

SELECT DISTINCT (industry)
FROM layoffs_staging2;


SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;


SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);



-- TO CHANGE THE DATE FORMATINNG --
SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_staging2  ;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');


SELECT *
FROM layoffs_staging2;

## Too change the column to date column

ALTER TABLE  layoffs_staging2
MODIFY COLUMN `date` DATE; 

-- NULL AND BLANCK VALUES --

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL;

 SELECT *
 FROM layoffs_staging2
 WHERE industry IS NULL
 OR industry = '';
 
 SELECT *
 FROM layoffs_staging2
 WHERE  company = 'Airbnb';
 
 SELECT t1.industry,t2.industry
 FROM layoffs_staging2 AS t1
 JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;   



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL;


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND  percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- ExPLORATORY DATA Analysis -

SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

SELECT industry,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry 
ORDER BY 2 DESC;



SELECT country,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  stage
ORDER BY 2 DESC;

SELECT company,AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY  company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH ROlling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,total_off,  SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total 
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE years IS NOT NULL
