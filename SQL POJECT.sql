select *
from [portfolio project ].dbo.[Covid death data]
order by 3,4

select *
from [portfolio project ].dbo.[Covid vaccine data]
order by 3,4

select location , date, new_cases, total_cases, total_deaths,population 
from [portfolio project ].dbo.[Covid death data]
order by 1,2


-- Total Cases vs Total Deaths 

select location , date, total_cases, total_deaths , (cast (total_deaths as numeric )/ cast(total_cases as numeric))*100 as DeathPercentage 
from [portfolio project ].dbo.[Covid death data]
where location = 'Pakistan'
order by 1,2

-- Total Cases vs Population 

select location , date,population, total_cases, (total_cases/ population)*100 as DeathPercentage 
from [portfolio project ].dbo.[Covid death data]
--where location = 'Pakistan'
order by 1,2

-- Countries with higher infection rate compared to population 

select location ,population, (max (cast(total_cases as numeric))) as HighestInfectionRate ,   (max (total_cases)/ population)*100 as PopulationInfected
from [portfolio project ].dbo.[Covid death data]
--where location = 'united states'
group by location, population
order by PopulationInfected desc


-- Countries with highest death cout per population 

select location , max (cast(total_deaths as numeric))as TotalDeathCount
from [portfolio project ].dbo.[Covid death data]
--where location = 'united states'
where continent is not null 
group by location
order by TotalDeathCount desc

--
select continent , max (cast(total_deaths as numeric))as TotalDeathCount
from [portfolio project ].dbo.[Covid death data]
--where location = 'united states'
where continent is not null 
group by continent 
order by TotalDeathCount desc


----Global numbers

select sum(cast(new_cases as int)),SUM(cast( new_deaths as int)) ,
(sum(new_deaths) / NULLIF(SUM(new_cases), 0)) * 100  as deathpercentage
from [portfolio project ].dbo.[Covid death data]
where continent is not null
group by date
order by 1,2


-- total Population vs total vaccination

select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccination
from [portfolio project ].dbo.[Covid death data] dea
join [portfolio project ].dbo.[Covid vaccine data] vac
 on dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
 order by 2,3


 -- POPVSVAC
 with popvsvac (continent,location ,date,population , new_vaccinations, RollingPeopleVaccination)
as
(select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [portfolio project].dbo.[covid death data] dea
join [portfolio project].dbo.[covid vaccine data] vac
on dea.location = vac.location 
and  dea.date = vac.date
where dea.continent is  not null)

select *, (RollingPeopleVaccination/population)*100
from popvsvac


--
create table #PercentpopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime ,
population numeric,
New_vaccination numeric,
RollingPeopleVaccination numeric
)





insert into #PercentpopulationVaccinated

select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [portfolio project].dbo.[covid death data] dea
join [portfolio project].dbo.[covid vaccine data] vac
on dea.location = vac.location 
and  dea.date = vac.date
where dea.continent is  not null

select *, (RollingPeopleVaccination/population)*100
from #PercentpopulationVaccinated




--
drop view if exists PercentPopulationVaccinated
create view PercentPopulationVaccinated as 
select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [portfolio project].dbo.[covid death data] dea
join [portfolio project].dbo.[covid vaccine data] vac
on dea.location = vac.location 
and  dea.date = vac.date
where dea.continent is  not null

create view PercePopulationVaccinated as
select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [portfolio project].dbo.[covid death data] dea
join [portfolio project].dbo.[covid vaccine data] vac
on dea.location = vac.location 
and  dea.date = vac.date
where dea.continent is  not null

select *
from PercePopulationVaccinated