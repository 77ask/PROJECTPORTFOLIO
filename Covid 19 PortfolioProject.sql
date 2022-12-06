SELECT *
FROM [SQL PROJECTS]..CovidDeaths$

-- Select Data that I am going to use
SELECT Location,date, total_cases, new_cases, total_deaths, population

FROM    [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2



 --looking at total cases versus total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage

FROM [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
--WHERE location like '%India%'
ORDER BY 1,2
 

 --looking at total cases versus population

SELECT location, date, total_cases, population,(total_cases/population)*100 as PercentPopulationInfected

FROM [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
--WHERE location like '%India%'
ORDER BY 1,2


--looking at countries with highest infection rate compared to population


SELECT location, population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected

FROM  [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null

GROUP BY location, population

ORDER BY PercentPopulationInfected desc

--showing countries with Highest Death Count per population

SELECT location, MAX(total_deaths) as TotalDeathCount
FROM  [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

 --LET's BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM [SQL PROJECTS]..CovidDeaths$
WHERE continent is  not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- showing continents with Highest Death Count per population


SELECT continent, MAX(total_deaths) as TotalDeathCount
FROM [SQL PROJECTS]..CovidDeaths$
WHERE continent is not  null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

SELECT date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(New_deaths as int))/SUM(new_cases)*100 as Death_percentage

FROM  [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
--WHERE location like '%India%'
GROUP BY date
ORDER BY 1,2


SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(New_deaths as int))/SUM(new_cases)*100 as Death_percentage

FROM  [SQL PROJECTS]..CovidDeaths$
WHERE continent is not null
--WHERE location like '%India%'
--GROUP BY date
ORDER BY 1,2

--Looking at population vs vaccination

SELECT dea.continent, dea.date, dea.location,dea.population, vac.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) over (Partition by  dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated --(RollingPeople Vaccinated/Population)*100
FROM [SQL PROJECTS]..CovidDeaths$ dea
JOIN [SQL PROJECTS]..CovidVaccinations$ vac
     on dea.location = vac.location
	  and  dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2,3


--CTE

WITH PopVac(continent,location,date, population, new_vaccination, RollingPeopleVaccinated )
as
(
SELECT dea.continent, dea.date, dea.location,dea.population, vac.new_vaccinations,
SUM(CONVERT(int, new_vaccinations)) over (Partition by  dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated --(RollingPeople Vaccinated/Population)*100
FROM [SQL PROJECTS]..CovidDeaths$ dea
JOIN [SQL PROJECTS]..CovidVaccinations$ vac
     on dea.location = vac.location
	  and  dea.date = vac.date
WHERE dea.continent is not null
--ORDER by 2,3
)
SELECT *,(RollingPeopleVaccinated/ Population)*100
FROM PopVac


--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO  #PercentPopulationVaccinated
SELECT dea.continent , dea.date, dea.location,dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated --(RollingPeople Vaccinated/Population)*100

FROM  [SQL PROJECTS]..CovidDeaths$ dea
JOIN [SQL PROJECTS]..CovidVaccinations$ vac
     on dea.location = vac.location
	  and  dea.date = vac.date
--WHERE dea.continent is not null

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



--Creating view to store data for later visualization

Create view PercentPopulationVaccinated as
SELECT dea.continent , dea.date, dea.location,dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location,dea.date) 
as RollingPeopleVaccinated --(RollingPeople Vaccinated/Population)*100

FROM  [SQL PROJECTS]..CovidDeaths$ dea
JOIN [SQL PROJECTS]..CovidVaccinations$ vac
     on dea.location = vac.location
	  and  dea.date = vac.date

WHERE dea.continent is not null

--ORDER BY 2,3


SELECT *
FROM PercentPopulationVaccinated
