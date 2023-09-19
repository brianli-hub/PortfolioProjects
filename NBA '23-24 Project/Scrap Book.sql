-- Creating Tables for PG Averages -- 

create table pointguard_averages(
	[NBA Player] nvarchar(255),
	"# of Games Played" float, 
	Team nvarchar(255),
	"PPG" float,
	"RPG" float,
	"APG" float,
	"SPG" float,
	"BPG" float,
	"3PM" float,
	"FT" float, 
	"+/-" float)
insert into pointguard_averages
select [NBA Player], 
		count(date), 
		tm, 
		round(avg(PTS),1), 
		round(avg(TRB),1), 
		round(avg(AST),1), 
		round(avg(STL),1), 
		round(avg(BLK),1), 
		round(avg("3p"),1), 
		round(avg(ft),1), 
		round(avg("+/-"),1) 
from ProjectNBA..['Point Guards$']
group by [NBA Player],Tm

select *
from pointguard_averages

drop table pointguard_averages