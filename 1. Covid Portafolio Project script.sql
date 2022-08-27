select *
from [Portfolio Project ].dbo.COVIDDEATHS$
where continent is not null
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population 
from [Portfolio Project ]..COVIDDEATHS$
where continent is not null
order by 1,2

---Looking at total cases vs total deaths
---Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project ]..COVIDDEATHS$
Where location like '%states%'
and continent is not null
order by 1,2

---Looking at Total Cases vs Population
---Shows what percentage of population got Covid

Select location, date, total_cases, Population, (total_cases/population)*100 as Percentage_Population_thatgotcovid
from [Portfolio Project ]..COVIDDEATHS$
Where location like '%states%'
and continent is not null
order by 1,2

---Looking at Countries with Highest Infection rate compared to Population
Select location, Population, MAX(total_cases) as HighestInfecctionCount, MAX((total_cases/population))*100 as MAX_Percentage_Population_thatgotcovid
from [Portfolio Project ]..COVIDDEATHS$
--Where location like '%states%'
Group by location, population
order by MAX_Percentage_Population_thatgotcovid desc


---Showing Countries with highest Death Count per Populaion 
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..COVIDDEATHS$
--Where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc

---Showing the continent with highest death per population
Select location, max(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project ]..COVIDDEATHS$
--Where location like '%states%'
where continent is null
group by location
order by TotalDeathCount desc

---Global Numbers
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project ]..COVIDDEATHS$
--Where location like '%states%'
where continent is not null
---Group by date
order by 1,2

---Looking at Total Population vs Vaccinations
---Total pop of the world that has been vacinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..COVIDDEATHS$ dea
Join [Portfolio Project ]..COVIDVACCINATIONS$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

----Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project ]..COVIDDEATHS$ dea
Join [Portfolio Project ]..COVIDVACCINATIONS$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


