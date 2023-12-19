create table auth (
	user_name varchar(30) primary key NOT NULL unique,
	email varchar(30) NOT NULL unique,
	passwd text
)
create table profile (
	user_name varchar(30) references public.auth NOT NULL unique, 
	email text not null unique,
	fname varchar(20) not null,
	lname text,
	lives text,
	connection int check(connection>=0) DEFAULT 0,
	current_semester int  check(current_semester>=1 and current_semester<=8)  not null,
	university text not null,
	admitted date not null,
	graduate date not null,
	linkedin text not null
)

create table cgpa_per_semester (
	user_name varchar(30) references public.auth NOT NULL unique, 	
	admitted date not null,
	graduate date not null,
	"1st_sem" float check("1st_sem" >=0 and "1st_sem" <=4),
	"2nd_sem" float check("2nd_sem">=0 and "2nd_sem"<=4),
	"3rd_sem" float check("3rd_sem">=0 and "3rd_sem"<=4),
	"4th_sem" float check("4th_sem">=0 and "4th_sem"<=4),
	"5th_sem" float check("5th_sem" >=0 and "5th_sem"<=4),
	"6th_sem" float check("6th_sem">=0 and "6th_sem"<=4),
	"7th_sem" float check("7th_sem">=0 and "7th_sem"<=4),
	"8th_sem" float check("8th_sem">=0 and "8th_sem"<=4)
)

create table competative_programming(
	user_name varchar(30) references public.auth NOT NULL unique, 
	cf_handle varchar(20) ,
	cf_tot_solve int,
	ac float,
	wa float,
	tle float,
	leetcode_handle varchar(20) ,
	lc_tot_solve int,
	easySolved int,
	mediumSolved int,
	hardSolved int,
	acceptancerate_leetcode float
)

create table github(
	user_name varchar(30) references public.auth NOT NULL unique,
	github_user_name varchar(20),
	tot_repos int,
	tot_contribution int
)

create table projects(
	user_name varchar(30) references public.auth NOT NULL,
	project text,
	link text 
)
create table skills(
	user_name varchar(30) references public.auth NOT NULL, 
	skill text default null
)
create table connection(
	user_name varchar(30) references public.auth NOT NULL, 
	conections1 varchar(30)
)






