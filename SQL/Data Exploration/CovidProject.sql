select *
from ProjectCovid..Coviddeaths$
where continent is not null
order by 3,4

--select *
--from ProjectCovid..Covidvaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from ProjectCovid..Coviddeaths$
where continent is not null
order by 1,2

-- Altered data columns as they were in nvarchar instead of floats 
alter table ProjectCovid..Coviddeaths$
alter column total_deaths float;
alter table ProjectCovid..Coviddeaths$
alter column total_cases float;

-- Fatality Rate of Covid based on Location
select Location, Date, Total_Cases, Total_Deaths, (total_deaths/total_cases)*100 as FatalityRate
from ProjectCovid..Coviddeaths$
where location like '%states%' and continent is not null
order by 1,2

-- Total Cases vs Population
select Location, Date, Total_Cases, Population, (total_cases/population)*100 as PercentPopulationInfectedOverTime
from ProjectCovid..Coviddeaths$
where location like '%states%' and continent is not null
order by 1,2

-- Countries with Highest Infection Rate Compared to Population
select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
from ProjectCovid..Coviddeaths$
where continent is not null
group by location, population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population
select Location, Max(total_deaths) as TotalDeathCount
from ProjectCovid..Coviddeaths$
where continent is not null
group by location
order by TotalDeathCount desc


-- Continents with Highest Death Count per Population
select Location, Max(total_deaths) as TotalDeathCount
from ProjectCovid..Coviddeaths$
where continent is null and location not like '%income' 
	and location not like 'European Union' 
	and location not like 'World'
group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS
select Date, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Deaths, sum(new_deaths)/nullif(sum(new_cases),0)*100 as FatalityRate
from ProjectCovid..Coviddeaths$
where continent is not null
group by date
order by 1,2

-- Total Population VS Total Vaccinations
select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, sum(convert(bigint,vax.new_vaccinations)) over (partition by deaths.location, deaths.date) as RollingVaccinationCount
from ProjectCovid..Coviddeaths$ as deaths
join ProjectCovid..Covidvaccinations$ as vax
	on deaths.location = vax.location
	and deaths.date = vax.date
where deaths.continent is not null 
order by 2,3


-- % Of Population Vaccinated by Rolling Dates using CTE
with PopVsVax (Continent, Location, Date, Population, new_vaccinations, RollingVaccinationCount) as 
(
select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, sum(convert(bigint,vax.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinationCount
from ProjectCovid..Coviddeaths$ as deaths
join ProjectCovid..Covidvaccinations$ as vax
	on deaths.location = vax.location
	and deaths.date = vax.date
where deaths.continent is not null 
)
select *, (RollingVaccinationCount/Population)*100 as "Percent of Population Vaccinated"
from PopVsVax

-- % Of Population Vaccinated by Rolling Dates using Temp Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinationCount numeric
)

Insert into #PercentPopulationVaccinated
select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, sum(convert(bigint,vax.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinationCount
from ProjectCovid..Coviddeaths$ as deaths
join ProjectCovid..Covidvaccinations$ as vax
	on deaths.location = vax.location
	and deaths.date = vax.date
where deaths.continent is not null 

select *, (RollingVaccinationCount/Population)*100 as "Percent of Population Vaccinated"
from #PercentPopulationVaccinated


-- Create View to store data for later visualizations 

Create View PercentPopulationVaccinated as 
select deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, sum(convert(bigint,vax.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as RollingVaccinationCount
from ProjectCovid..Coviddeaths$ as deaths
join ProjectCovid..Covidvaccinations$ as vax
	on deaths.location = vax.location
	and deaths.date = vax.date
where deaths.continent is not null 

select *
from PercentPopulationVaccinated