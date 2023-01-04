--SELECT * FROM CovidDeaths
--Where continent is not null
--Order by 3

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths
--Where continent is not null
--Order by location,date


-----Total Deaths VS Total Cases
---- -Looking @ Percentage of Death from total Cases for each Country 
--SELECT location,date, population, total_deaths , total_cases , (total_deaths / total_cases)*100 as DeathPercent
--FROM  CovidDeaths
--Where continent is not null
--ORDER BY 1,2

--3.Percentage of infected from population
SELECT location,  date, population , total_cases , (total_cases/population)*100 as InfectionPercent
FROM  CovidDeaths
Where continent is not null
ORDER BY 1,2

--4Countries with highest infection Rates
SELECT location,population , MAX(total_cases) AS HighestCasesCount , MAX(total_cases/population)*100 as InfectionPercent
FROM  CovidDeaths
Where continent is not null
GROUP BY location, population
ORDER BY InfectionPercent DESC


----Countries with highest death per population
----SELECT location, MAX(cast(total_deaths as int)) AS MaxTotalDeath 
----FROM  CovidDeaths
----Where continent is not null
----GROUP BY location
----ORDER BY  MaxTotalDeath DESC


---- --2  . Continent with death
SELECT continent, SUM(cast(new_deaths as int)) AS SumTotalDeath 
FROM  CovidDeaths
Where continent is not null
GROUP BY continent
ORDER BY   SumTotalDeath DESC



--1 GLOBAL NUMBERS
 
SELECT SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM  CovidDeaths
Where continent is not null
ORDER BY 1,2


--Vaccinated People vs population
With VacPop( continent, location , date, population,new_vaccinations,RollingTotalVaccinations)
as 
(
SELECT de.continent, de.location, de.date, de.population, vac.new_vaccinations --have to specify which column before date because we use joins not unions
, SUM(cast(vac.new_vaccinations as int))
OVER 
(Partition by de.location order by de.location , de.date) as	RollingTotalVaccinations
FROM CovidDeaths de
jOIN CovidVac vac
on de.location=vac.location and de.date=vac.date
Where de.continent is not null
)
SELECT * ,	(RollingTotalVaccinations/population)*100
FROM VacPop



---TEMPTABLE
DROP TABLE IF EXISTS #PercentpopulationVaccinated
CREATE Table #PercentpopulationVaccinated
( continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingTotalVaccinations numeric)

insert into #PercentpopulationVaccinated

SELECT de.continent, de.location, de.date, de.population, vac.new_vaccinations --have to specify which column before date because we use joins not unions
, SUM(cast(vac.new_vaccinations as int))
OVER 
(Partition by de.location order by de.location , de.date) as	RollingTotalVaccinations
FROM CovidDeaths de
jOIN CovidVac vac
on de.location=vac.location and de.date=vac.date
Where de.continent is not null
order by 2,3

SELECT * ,	(RollingTotalVaccinations/population)*100
FROM  #PercentpopulationVaccinated



---Creating view for saving for visualization

Create View PercentpopulationVaccinated as -----remove # to VOID THE ERROR
SELECT de.continent, de.location, de.date, de.population, vac.new_vaccinations --have to specify which column before date because we use joins not unions
, SUM(cast(vac.new_vaccinations as int))
OVER 
(Partition by de.location order by de.location , de.date) as	RollingTotalVaccinations
FROM CovidDeaths de
jOIN CovidVac vac
on de.location=vac.location and de.date=vac.date
Where de.continent is not null





