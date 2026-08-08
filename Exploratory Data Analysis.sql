 -- Exploratory Data Analysis
 
 -- Here we are jsut going to explore the data and find trends or patterns 
 
SELECT * 
FROM world_layoffs.layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from world_layoffs.layoffs_staging2;

select *
from world_layoffs.layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

# Which companies had 1 which is basically 100 percent of they company laid off

select company, sum(total_laid_off)
from world_layoffs.layoffs_staging2
group by company
order by sum(total_laid_off) desc;

## found that amazon has the largest laid off 

select min(`date`), max(`date`)
from world_layoffs.layoffs_staging2;

select industry, sum(total_laid_off)
from world_layoffs.layoffs_staging2
group by industry
order by sum(total_laid_off) desc;

## consumer and retail industries have the largest laid off  between 2020 and 2023

select country, sum(total_laid_off)
from world_layoffs.layoffs_staging2
group by country
order by sum(total_laid_off) desc;


select year(`date`), sum(total_laid_off)
from world_layoffs.layoffs_staging2
group by year(`date`)
order by sum(total_laid_off) desc;

## found that 2020 was the worst year as it has the max laid off during that period 

select stage, sum(total_laid_off)
from world_layoffs.layoffs_staging2
group by stage
order by 2 desc;

select substring(`date`,1,7) as `month`, sum(total_laid_off) 
from world_layoffs.layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 desc;

WITH rolling_total as 
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as sum_tlo
from world_layoffs.layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 desc
)
select `month`, sum_tlo, sum(sum_tlo) over (order by `month`) as rolling
from rolling_total;

SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company, YEAR(`date`);
  
WITH Company_Year (company, years, total_laid_off) AS 
(
  SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) 
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, YEAR(`date`)
), comapny_year_ranking as
(SELECT*, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
where years is not null 
order by ranking asc
)
select *
from comapny_year_ranking
where ranking <=5
ORDER BY years ASC, total_laid_off DESC;
;

select *
from world_layoffs.layoffs_staging2;

SELECT company
from world_layoffs.layoffs_staging2
group by company;

with total_companies_num as
(
SELECT company
from world_layoffs.layoffs_staging2
group by company
)
select COUNT(*) AS total_comp_number
from total_companies_num;
