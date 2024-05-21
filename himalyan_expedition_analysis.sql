-- Retrieving data from all the tables
select * from himalyan.deaths d ;
select * from himalyan.expeditions e ;
select * from himalyan.peaks p  ;
select * from himalyan.summiters s  ;

-- popular season to climb

select peak_name ,season,count(peak_id) as no_of_expedition
from himalyan.expeditions e 
where peak_name in(
select peak_name from
(select peak_name,count(peak_id) no_of_expedition,
rank() over(order by count(peak_id) desc)rnk
from himalyan.expeditions e 
group by peak_name 
order by 2 desc
)t1 
where rnk < 11)
group by peak_name ,season 
order by 3 desc;
-- The most popular seasons to climb mountains are autumn and spring


/*peak_wise top 3 participating countries*/
select peak_name ,nationality,no_of_participation 
from
(select peak_name,nationality,count(peak_id) as no_of_participation,
dense_rank() over(partition by peak_name order by count(peak_id)desc)rnk2
from himalyan.expeditions e 
where peak_name in 
(select peak_name 
from(select peak_name,count(peak_id) as no_of_expeditions,
dense_rank() over(order by count(peak_id) desc)rnk
from expeditions e 
group by peak_name)rnk1_table
where rnk < 11)
group by peak_name,nationality) as rnk_table
where rnk2<4;
-- Most number of climbers are from USA followed by UK


-- Past ten years number of expeditions
select year,count(peak_id) 
from himalyan.expeditions 
group by 1 
order by year desc 
limit 10;
-- During the year 2020 the number of expeditions was only 3 ,if we compare these with 2019 and 2018 it shows a sharp decline


-- The most popular host countries

select host_cntr,count(peak_id)
from himalyan.expeditions e 
group by 1
order by 2;
-- the most popular host countruies are nepal and china


-- cause of death count in top 10 peaks
select cause_of_death,count(*)
from himalyan.deaths d2 
where peak_name in
(select peak_name 
from (select peak_name,count(peak_id),
rank() over(order by count(peak_id) desc)rnk
from himalyan.deaths d
group by peak_name )t1
where rnk < 11)
group by cause_of_death 
order by 2 desc;
-- The main cause of deaths are Avalanche,fall,AMS(Altitude mountain sickness) and illness


-- Top 3 routes peak-wise
-- first we will take top 10 peaks based on expeditions
-- after that we will take top 3 routes for every peak
select peak_name,rte_1_name,no_of_expedition from
(select peak_name,rte_1_name ,count(*) no_of_expedition,
dense_rank() over(partition by peak_name order by count(*)desc) rnk1
from himalyan.expeditions e 
where peak_name in (
select peak_name from
(select peak_name,count(peak_id),
rank() over(order by count(peak_id)desc)rnk
from himalyan.expeditions e  
group by peak_name
)t1
where rnk < 11
)
group by peak_name ,rte_1_name 
order by 1 asc ,3 desc)t2
where rnk1<4
-- The best route to Ama Dablam is Sw Ridge and N ridge
--The best route to climb MT Everest is S col-SE Ridge and N col-NE ridge
