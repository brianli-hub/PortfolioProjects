select *
from ProjectNBA..['Point Guards$']

-- Getting Average Boxscore Stats for Point Guards -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..['Point Guards$']
group by [NBA Player], tm
order by avg(PTS) desc 

-- Getting Average Boxscore Stats for Shooting Guards -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..['Shooting Guards$']
group by [NBA Player], tm
order by avg(PTS) desc 

-- Getting Average Boxscore Stats for Small Forwards -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..['Small Forwards$']
group by [NBA Player], tm
order by avg(PTS) desc 

-- Getting Average Boxscore Stats for Power Forwards -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..['Power Forwards$']
group by [NBA Player], tm
order by avg(PTS) desc 

-- Getting Average Boxscore Stats for Centers -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..Centers$
group by [NBA Player], tm
order by avg(PTS) desc 

-- Getting Average Boxscore Stats for 6th Man -- 

select [NBA Player], tm as Team,
		round(avg(PTS),1) as PPG, 
		round(avg(TRB),1) as RPG, 
		round(avg(AST),1) as APG, 
		round(avg(STL),1) as SPG, 
		round(avg(BLK),1) as BPG, 
		round(avg("3P"),1) as '3PM', 
		round(avg("+/-"),1) as 'AVG +/-'
from ProjectNBA..['6th Man$']
group by [NBA Player], tm
order by avg(PTS) desc 

-- Creating Table for all NBA Players --
create table nba_players(
	[NBA Player] nvarchar(255),
	Date datetime, 
	Team nvarchar(255),
	Home_or_Away nvarchar(255),
	Opponent nvarchar(255),
	"Points" float,
	"Rebounds" float,
	"Assists" float,
	"Steals" float,
	"Blocks" float,
	"3 Pointers" float,
	"Free Throws" float, 
	"+/-" float)
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..['Point Guards$']
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..['Shooting Guards$']
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..['Small Forwards$']
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..['Power Forwards$']
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..Centers$
insert into nba_players
select [NBA Player], date, tm, f8, opp, pts, trb, ast, stl, blk, "3p", ft, "+/-" 
from ProjectNBA..['6th Man$']

drop table nba_players

-- Player stats per Team -- 
select [NBA Player], Team, count(date) as '# of Games Played',
		avg(points) as PPG, 
		avg(rebounds) as RPG, 
		avg(assists) as APG, 
		avg(steals) as SPG, 
		avg(blocks) as BPG, 
		avg("3 pointers") as '3PM', 
		avg("free throws") as FTM, 
		avg("+/-") as 'AVG +/-'
from ProjectNBA..nba_players
where team = 'DEN' and [+/-] is not null
group by [NBA Player], team

-- View of teams where players were traded before the deadline + post season (NOTE: must have know which players were traded) -- 
select [NBA Player], Team, 
		avg(points) as PPG, 
		avg(rebounds) as RPG, 
		avg(assists) as APG, 
		avg(steals) as SPG, 
		avg(blocks) as BPG, 
		avg("3 pointers") as '3PM', 
		avg("free throws") as FTM, 
		avg("+/-") as 'AVG +/-'
from nba_players
where team = 'BRK' AND [NBA Player] not in ('Kevin Durant', 'Yuta Watanabe', 'Kyrie Irving')
group by [nba player], team
order by PPG desc

-- Players performance V.S a Specific Team
select [NBA Player], Team, count(date) as '# of Games',
		avg(points) as PPG, 
		avg(rebounds) as RPG, 
		avg(assists) as APG, 
		avg(steals) as SPG, 
		avg(blocks) as BPG, 
		avg("3 pointers") as '3PM', 
		avg("free throws") as FTM, 
		avg("+/-") as 'AVG +/-'
from nba_players
where [NBA Player] = 'Lebron James' AND Opponent = 'DEN'
group by [NBA Player], team

-- Players Box Score V.S a Specific Player per Game -- 
select a.[NBA Player], a.Team,
		(a.points) as PPG, 
		(a.rebounds) as RPG, 
		(a.assists) as APG, 
		(a.steals) as SPG, 
		(a.blocks) as BPG, 
		(a."3 pointers") as '3PM', 
		(a."free throws") as FTM, 
		(a."+/-") as 'AVG +/-',
		(a.date) as '# of Games',
		b.[NBA Player], b.Team,
		(b.points) as PPG, 
		(b.rebounds) as RPG, 
		(b.assists) as APG, 
		(b.steals) as SPG, 
		(b.blocks) as BPG, 
		(b."3 pointers") as '3PM', 
		(b."free throws") as FTM, 
		(b."+/-") as 'AVG +/-',
		(b.date) as '# of Games'
from nba_players as a
inner join nba_players as b on a.[Date] = b.[Date]
where a.[NBA Player] = 'Lebron James'
AND a.Opponent = 'DEN'
and b.[NBA Player] = 'Nikola Jokic'
and b. Opponent = 'LAL'


-- Created Stored Procedure for Cleaner Look -- 

create procedure Player_Comparison @nbaplayer1 nvarchar(255), @opponent1 nvarchar(255), @nbaplayer2 nvarchar(255), @opponent2 nvarchar(255)
as
select a.[NBA Player], a.Team,
		avg(a.points) as PPG, 
		avg(a.rebounds) as RPG, 
		avg(a.assists) as APG, 
		avg(a.steals) as SPG, 
		avg(a.blocks) as BPG, 
		avg(a."3 pointers") as '3PM', 
		avg(a."free throws") as FTM, 
		avg(a."+/-") as 'AVG +/-',
		count(a.date) as '# of Games',
		b.[NBA Player], b.Team,
		avg(b.points) as PPG, 
		avg(b.rebounds) as RPG, 
		avg(b.assists) as APG, 
		avg(b.steals) as SPG, 
		avg(b.blocks) as BPG, 
		avg(b."3 pointers") as '3PM', 
		avg(b."free throws") as FTM, 
		avg(b."+/-") as 'AVG +/-',
		count(b.date) as '# of Games'
from nba_players as a
inner join nba_players as b on a.[Date] = b.[Date]
where a.[NBA Player] = @nbaplayer1
AND a.Opponent = @opponent1
and b.[NBA Player] = @nbaplayer2
and b. Opponent = @opponent2
group by a.[NBA Player], a.Team, b.[NBA Player], b.Team

exec Player_Comparison @nbaplayer1 = 'Nikola Jokic', @opponent1 = 'LAL', @nbaplayer2 = 'Lebron James', @opponent2 = 'DEN'

