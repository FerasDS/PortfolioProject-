select *
from ProfileProject.dbo.CovidDeaths
where continent is not null
order by 3, 4

--select *
--from ProfileProject.dbo.CovidDeaths$
--order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from ProfileProject..CovidDeaths
where continent is not null
order by 1,2

-- Total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
from ProfileProject..CovidDeaths
where location like '%saudi%'
where continent is not null
order by 1,2

-- total cases vs population 
select location, date,population, total_cases, (total_cases/population)*100 as Precentage
from ProfileProject..CovidDeaths
where location like '%saudi%'
order by 1,2

-- Highest Infection rate compared to population
select location, population, max(total_cases) as HighestinfectionCount, max((total_cases/population))*100 as PrecentPopulationInfected
from ProfileProject..CovidDeaths
--where location like '%saudi%'
group by location, population
order by PrecentPopulationInfected desc

-- Highest Desath Count per population
select location, max(cast(total_cases as int)) as TotalDeathCountPopulation
from ProfileProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by location
order by TotalDeathCountPopulation desc


-- Break Things Down By Continet 
select continent, max(cast(total_cases as int)) as TotalDeathCountPopulation
from ProfileProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by continent
order by TotalDeathCountPopulation desc

-- highest death count per population / continents
select continent, max(cast(total_cases as int)) as TotalDeathCountPopulation
from ProfileProject..CovidDeaths
--where location like '%saudi%'
where continent is not null
group by continent
order by TotalDeathCountPopulation desc

-- Global Numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deat, sum(cast
	(new_deaths as int))/sum(new_cases)*100 as GlobalDeath
from ProfileProject..CovidDeaths
-- where location like '%saudi%'
where continent is not null
--group by date
order by 1,2


-- total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingpeopleVaccination
from ProfileProject..CovidDeaths dea
join ProfileProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use CTE

with PopvsVac (continent, location, data, population, new_vaccinations, RollingpeopleVaccination)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingpeopleVaccination
from ProfileProject..CovidDeaths dea
join ProfileProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)

select *, (RollingpeopleVaccination/population)*100
from PopvsVac


-- TEMP Table

create table #precentpopulationvaccination
(
continent nvarchar(225),
location nvarchar(255),
data datetime,
population numeric,
new_vaccinations numeric,
RollingpeopleVaccination numeric,
)


insert into #precentpopulationvaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingpeopleVaccination
from ProfileProject..CovidDeaths dea
join ProfileProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select *, (RollingpeopleVaccination/population)*100
from #precentpopulationvaccination


-- creating view to store data for later visualization

create view precentpopulationvaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingpeopleVaccination
from ProfileProject..CovidDeaths dea
join ProfileProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from precentpopulationvaccination
