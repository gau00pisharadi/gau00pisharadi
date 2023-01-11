/*Covid 19 Data Exploration */


/* Top ten countries with the highest number of deaths */

SELECT location, MAX(total_cases) AS total_death_count
FROM covid_deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location 
ORDER BY MAX(total_cases) DESC
LIMIT 10;

/* Top ten countries with the highest number of cases */

SELECT location, MAX(total_cases) AS total_infected
FROM covid_deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location
ORDER BY MAX(total_cases) DESC
LIMIT 10;

/* Top ten countries with the highest mortality rate, i.e. (total_deaths/total_cases) */

SELECT location, MAX(total_deaths), MAX(total_cases), (MAX(total_deaths)/MAX(total_cases)*100) AS mortality_rate
FROM covid_deaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location
ORDER BY (MAX(total_deaths)/MAX(total_cases)*100) DESC
LIMIT 10;

/* Mortality rate of India */

SELECT location, MAX(total_deaths), MAX(total_cases), (MAX(total_deaths)/MAX(total_cases)*100) AS mortality_rate
FROM covid_deaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL AND total_cases IS NOT NULL 
GROUP BY location
HAVING location ILIKE '%india%';

/* Countries with the highest infection percent, i.e. (total_cases/population)*/

SELECT location, MAX(total_cases), MAX(population), (MAX(total_cases)/MAX(population)*100) AS infection_percent
FROM covid_deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location 
ORDER BY (MAX(total_cases)/MAX(population)*100) DESC;

/* Infection percent of India */

SELECT location, MAX(total_cases), MAX(population), (MAX(total_cases)/MAX(population)*100) AS infection_percent
FROM covid_deaths
WHERE continent IS NOT NULL AND total_cases IS NOT NULL
GROUP BY location 
HAVING location ILIKE '%india%';

/* Top 10 countries with maximum tests done */

SELECT location, MAX(total_tests) AS tests
FROM covid_vaccinations 
WHERE continent IS NOT NULL AND total_tests IS NOT NULL
GROUP BY location
ORDER BY MAX(total_tests) DESC
LIMIT 10;

/* Top 10 countries with highest number of  fully vaccinated people */

SELECT location, MAX(people_fully_vaccinated) AS fully_vaccinated_people
FROM covid_vaccinations 
WHERE continent IS NOT NULL AND people_fully_vaccinated IS NOT NULL
GROUP BY location
ORDER BY MAX(people_fully_vaccinated) DESC
LIMIT 10;

/* Percentage of Population that has recieved at least one Covid Vaccine in each country */

WITH vaccinated_per_population (continent, location, date, population, new_vaccinations, loc_new_vaccinations) 
AS 
(SELECT covid_deaths.continent, covid_deaths.location, 
 covid_deaths.date, covid_deaths.population, 
 covid_vaccinations.new_vaccinations, 
 SUM(covid_vaccinations.new_vaccinations) OVER (PARTITION BY covid_deaths.location ORDER BY covid_deaths.location, covid_deaths.date) AS loc_new_vaccinations
 FROM covid_deaths
 INNER JOIN covid_vaccinations
 ON covid_deaths.location = covid_vaccinations.location AND covid_deaths.date = covid_vaccinations.date
 WHERE covid_deaths.continent IS NOT NULL)
 
SELECT *, (loc_new_vaccinations/population)*100 AS vaccinated_per_population
FROM vaccinated_per_population;


