-- Covid 19 Data Exploration & Cleaning 

SELECT location, dateconverted, total_cases, new_cases, total_deaths, population
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND population is not null AND iso_code NOT LIKE '%owid%'
ORDER BY 1, 2

-- create new formatted date column 

ALTER TABLE COVIDPROJECT.dbo.CovidDeaths
ADD dateconverted Date

UPDATE COVIDPROJECT.dbo.CovidDeaths
SET dateconverted = CONVERT(Date, date)


-- displays likelihood of dying if you contracted covid in each country by date 

SELECT location, dateconverted, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
ORDER by 1,2

-- displays percentage of population infected 

SELECT location, dateconverted, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
ORDER BY 1, 2 

-- countries with the highest infection rate in relation to population 

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- countries with the highest death count per population 

SELECT location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
GROUP BY location
ORDER BY TotalDeathCount DESC


-- displaying contintents with the highest death count per population

SELECT location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is null AND location not in ('European Union', 'International')
GROUP BY location 
ORDER BY TotalDeathCount DESC

-- covid fatality rate in regards to total deaths and cases 

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null 
ORDER BY 1, 2 

-- rolling number of vaccines administered of each country 

SELECT death.continent, death.location, death.dateconverted, death.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, Death.dateconverted) AS RollingNumberOfVaccines
FROM COVIDPROJECT.dbo.CovidDeaths death
JOIN COVIDPROJECT.dbo.CovidVaccinations vac
	ON death.location = vac.location 
	AND death.date = vac.date
WHERE death.continent is not null AND death.population is not null
ORDER BY 2, 3


-- CTE, number of fully vaccinated people in each country and percentage of individuals fully vaccinated compared to population 

WITH FullyVac (location, population, fully_vaccinated, PercentFullyVaccinated) 
AS
(
SELECT vac.location, MAX(population) AS current_pop, MAX(CONVERT(numeric, vac.people_fully_vaccinated)) AS fully_vaccinated, MAX(CONVERT(numeric, vac.people_fully_vaccinated))/MAX(population)*100 AS PercentFullyVaccinated
FROM COVIDPROJECT.dbo.CovidVaccinations vac 
JOIN COVIDPROJECT.dbo.CovidDeaths death
	ON vac.location = death.location
	AND vac.date = death.date
WHERE vac.continent is not null AND vac.iso_code NOT LIKE '%owid%' AND death.population is not null
GROUP BY vac.location
)
SELECT*
FROM FullyVac
ORDER BY PercentFullyVaccinated DESC

-- VIEWS

CREATE VIEW PercentFullyVac 
AS
SELECT vac.location, MAX(population) AS current_pop, MAX(CONVERT(numeric, vac.people_fully_vaccinated)) AS fully_vaccinated, MAX(CONVERT(numeric, vac.people_fully_vaccinated))/MAX(population)*100 AS PercentFullyVaccinated
FROM COVIDPROJECT.dbo.CovidVaccinations vac 
JOIN COVIDPROJECT.dbo.CovidDeaths death
	ON vac.location = death.location
	AND vac.date = death.date
WHERE vac.continent is not null AND vac.iso_code NOT LIKE '%owid%' AND death.population is not null
GROUP BY vac.location


CREATE VIEW CovidDeathRate
AS
SELECT location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
GROUP BY location


CREATE VIEW CovidInfectionRate
AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'
GROUP BY location, population


CREATE VIEW CovidDeathPercentage
AS
SELECT location, dateconverted, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM COVIDPROJECT.dbo.CovidDeaths
WHERE continent is not null AND total_cases is not null AND total_deaths is not null AND population is not null AND iso_code NOT LIKE '%owid%'

