-- Data cleaning

select *
from layoffs;


create table layoffs_staging
like layoffs;

insert layoffs_staging
select*
from layoffs;

select *
from layoffs_staging;

-- Remove Duplicates 
# First let's check for duplicates

with duplicates_cte as
(
select*,
row_number() over( 
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicates_cte
where row_num >1;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- these are the ones we want to delete where the row number is > 1

select *
from layoffs_staging
where company = 'casper';

create table layoffs_staging2
like layoffs_staging;

ALTER TABLE layoffs_staging2
ADD COLUMN row_num int;

insert into layoffs_staging2
select*,
row_number() over( 
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) as row_num
from layoffs_staging;


select *
from layoffs_staging2
where row_num >1;
## now that we have this we can delete rows were row_num is greater than 1
delete 
from layoffs_staging2
where row_num >1;


-- Standardizing data


select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select  distinct industry
from layoffs_staging2
order by 1;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select  distinct country, trim(trailing "." from country)
from layoffs_staging2
order by 1;


update layoffs_staging2
set country =  trim(trailing "." from country)
where country like 'United States%' ;

select  distinct country
from layoffs_staging2
order by 1;

## update the date column from string to date format 

select `date`,
str_to_date(`date`, '%m/%d/%Y/')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y/');

select `date`
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date ; 

select *
from layoffs_staging2;

 -- Look at null values 
 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

-- now we need to populate those nulls if possible

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;


select *
from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

 select *
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 # this is useless data we can delete it 
 
 delete
 from layoffs_staging2
 where total_laid_off is null
 and percentage_laid_off is null;
 
 select *
 from layoffs_staging2;
 
 alter table layoffs_staging2
 drop column row_num;
 
