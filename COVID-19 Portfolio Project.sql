SELECT *
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is not NULL
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccination
--ORDER BY 3,4

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
Where location like 'australia'
ORDER BY 1,2

SELECT location, population, MAX(total_cases) as HighestInfectionCount ,MAX((total_cases/population)) *100 as PercentagePopulationInfected
FROM PortfolioProject.dbo.CovidDeath
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is not NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--GLOBAL number

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeath
WHERE continent is NOT NULL
ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3

DROP TABLE IF exists #PercentPopulationVaccincated
CREATE TABLE #PercentPopulationVaccincated(
continent VARCHAR(50),
locatoin VARCHAR(50),
date DATETIME,
population INT,
new_vaccinations INT,
RollingPeopleVaccinated NUMERIC
)

INSERT INTO #PercentPopulationVaccincated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is not NULL

SELECT *, (RollingPeopleVaccinated/population)*100 as PercentPeopleGetVaccinated 
FROM #PercentPopulationVaccincated


CREATE VIEW PercentPopulationVaccincations as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(INT, vac.new_vaccinations)) 
OVER(Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject.dbo.CovidDeath dea
Join PortfolioProject.dbo.CovidVaccination vac
    on dea.location= vac.location
	and dea.date=vac.date
WHERE dea.continent is not NULL

SELECT *
FROM PercentPopulationVaccincations