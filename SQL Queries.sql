-- Select Data that we are going to use

SELECT Location, date, total_Cases, new_cases, total_Deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (CAST(total_deaths AS float) /(total_cases))*100 AS DeathPercentage
FROM CovidDeaths
WHERE LOCATION like '%states%'
AND continent IS NOT NULL
ORDER BY 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid
SELECT Location, date, population, total_cases, (CAST(total_cases AS float) /(population))*100 AS InfectedPercentage
FROM CovidDeaths
WHERE LOCATION like '%states%'
ORDER BY 1,2


-- Looking at countries with highest infection rate compared to population

SELECT Location, MAX(population) AS Population, MAX(total_cases) AS HighestInfectionCount
, (CAST(MAX(total_cases) AS float) / MAX(population))*100 AS InfectedPercentage
FROM CovidDeaths
GROUP BY Location, population
ORDER BY InfectedPercentage DESC

-- Showing Countries with highest Death count per population

SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, population
ORDER BY TotalDeathCount DESC

-- BY Continent highest Death count per population
-- Showing continents with highest death count
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT 
    date, 
    SUM(new_cases) AS Cases, 
    SUM(new_deaths) AS Deaths,
    CASE 
        WHEN SUM(new_cases) <> 0 THEN (SUM(CAST(new_deaths AS FLOAT)) / SUM(new_cases)) * 100
        ELSE NULL
    END AS DeathPercentage
FROM 
    CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    date
ORDER BY 
    date;


-- Looking at total population vs Vaccincations 
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
FROM CovidDeaths cd
INNER JOIN CovidVaccinations cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3  