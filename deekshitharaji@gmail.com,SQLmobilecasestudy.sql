--SQL Advance Case Study

	 select * from FACT_TRANSACTIONS
	 select * from DIM_CUSTOMER
	 select * from DIM_DATE
	 select * from DIM_LOCATION
	 select * from DIM_MANUFACTURER
	 select * from DIM_MODEL
	 
	

--Q1--BEGIN 
	
	

	select DL.state,year(ft.date)[Sale Year till Now],ft.IDCustomer
	from DIM_LOCATION DL 
		inner join FACT_TRANSACTIONS FT  on FT.IDLocation=DL.IDLocation 
		inner join DIM_MODEL DM on DM.IDModel=FT.IDModel 
		inner join DIM_MANUFACTURER DMF on DMF.IDManufacturer=DM.IDManufacturer 
		where year(ft.date) between '2005' and getdate()
		order by year(ft.date),ft.IDCustomer



--Q1--END

--Q2--BEGIN 
	
	select DL.state,sum(ft.Quantity)[States buying samsung]
	from DIM_LOCATION DL 
		inner join FACT_TRANSACTIONS FT  on FT.IDLocation=DL.IDLocation 
		inner join DIM_MODEL DM on DM.IDModel=FT.IDModel 
		inner join DIM_MANUFACTURER DMF on DMF.IDManufacturer=DM.IDManufacturer where DL.Country='Us' and 
		DMF.Manufacturer_Name='samsung' 
		group by DL.State
		order by [States buying samsung] desc
		
	
		
	  

--Q2--END

--Q3--BEGIN    
	
	Select DM.IDModel,DM.Model_Name,DL.Zipcode,DL.state,count(FT.Quantity )[Transaction]
	from DIM_LOCATION DL 
		inner join FACT_TRANSACTIONS FT  on FT.IDLocation=DL.IDLocation 
		inner join DIM_MODEL DM on DM.IDModel=FT.IDModel 
		group by DM.IDModel,DM.Model_Name,DL.ZipCode,DL.State
		order by DM.Model_Name,ZipCode,State




--Q3--END

--Q4--BEGIN

select top 1 Model_Name[Cheapest cellphone],Unit_price
from DIM_MODEL
order by Unit_price asc


--Q4--END

--Q5--BEGIN


select top 5 DMM.Manufacturer_Name,DM.Model_Name,avg(DM.Unit_price)[average price],
avg(FT.TotalPrice)[total sales]
from FACT_TRANSACTIONS FT
		inner join DIM_MODEL DM on dm.idmodel=FT.IDModel
		inner join DIM_MANUFACTURER DMM on dmm.IDManufacturer=dm.IDManufacturer
		group by DM.Model_Name,DMM.Manufacturer_Name
		order by [average price] desc




--Q5--END

--Q6--BEGIN 


select DC.Customer_Name,avg(FT.TotalPrice) [Avg Price spent on 2009]
from DIM_CUSTOMER DC
		inner join FACT_TRANSACTIONS FT on FT.IDCustomer= DC.IDCustomer
		
		inner join DIM_DATE DD on FT.[Date]=DD.[DATE]
		where DD.year='2009'
		group by DC.Customer_Name
		Having avg(FT.TotalPrice)>500 


--Q6--END
	
--Q7--BEGIN  
	
	select * from (
select  top 5  DM.Model_Name[name],sum(Ft.Quantity)[top],DD.year[year]
from DIM_MODEL DM
		inner join FACT_TRANSACTIONS FT on FT.IDmodel=DM.IDModel
		inner join DIM_DATE DD on FT.[Date]=DD.[DATE]
		where DD.year ='2008'
		group by dm.Model_Name,dd.year
		order by [top] desc
		)a
		inner join
		
		(select  top 5  DM.Model_Name[name],sum(Ft.Quantity)[top],DD.year[year]
       from DIM_MODEL DM
		inner join FACT_TRANSACTIONS FT on FT.IDmodel=DM.IDModel
		inner join DIM_DATE DD on FT.[Date]=DD.[DATE]
		where DD.year ='2009'
		group by dm.Model_Name,dd.year
		order by [top] desc
		)b
		on a.name=b.name

		inner join
		
		(select  top 5  DM.Model_Name[name],sum(Ft.Quantity)[top],DD.year[year]
       from DIM_MODEL DM
		inner join FACT_TRANSACTIONS FT on FT.IDmodel=DM.IDModel		
		inner join DIM_DATE DD on FT.[Date]=DD.[DATE]
		where DD.year ='2010'
		group by dm.Model_Name,dd.year
		order by [top] desc
		)c
		on b.name=c.name
		



------------
	select  top 5  DM.Model_Name[name],sum(Ft.Quantity)[top],DD.year[year]
from DIM_MODEL DM
		inner join FACT_TRANSACTIONS FT on FT.IDmodel=DM.IDModel
		
		inner join DIM_DATE DD on FT.[Date]=DD.[DATE]
		where DD.year ='2008'or year ='2009'or year ='2010'
		group by dm.Model_Name,dd.year
		order by [top] desc



--Q7--END	
--Q8--BEGIN

select * from 
(select dd.YEAR[Year], DMM.Manufacturer_Name[Name],sum(ft.TotalPrice)[Top sales],
rank() over(partition by  dd.YEAR order by sum(ft.TotalPrice) desc)[Rank]
	from DIM_DATE DD
			inner join FACT_TRANSACTIONS FT on FT.Date=DD.DATE
			inner join DIM_MODEL DM on DM.IDModel=FT.IDModel
			inner join DIM_MANUFACTURER DMM on DMM.IDManufacturer=DM.IDManufacturer 
			where dd.YEAR in ('2009', '2010') 
			group by dd.YEAR,DMM.Manufacturer_Name
			)t1

			where t1.Rank = 2
	       order by t1.Year desc,t1.[Top sales] desc




--Q8--END
--Q9--BEGIN 

	select distinct DMM.Manufacturer_Name
	from DIM_DATE DD
			inner join FACT_TRANSACTIONS FT on FT.Date=DD.DATE
			inner join DIM_MODEL DM on DM.IDModel=FT.IDModel
			inner join DIM_MANUFACTURER DMM on DMM.IDManufacturer=DM.IDManufacturer 
			where dd.year != '2009' or FT.Quantity<0 or dd.year='2010' or FT.Quantity>0
			
	

--Q9--END

--Q10--BEGIN

	select top 100 dc.Customer_Name,year(ft.date)[Year],
	avg(ft.Quantity)[avg quantity],
	avg(ft.TotalPrice)[avg spend],
	(avg(ft.TotalPrice)-Lag(avg(ft.TotalPrice),1)
	over(order by dc.Customer_Name,year(ft.date)asc))/avg(ft.TotalPrice)*100[Percentage Difference]
	from DIM_CUSTOMER DC
		 inner join FACT_TRANSACTIONS FT on FT.IDCustomer=DC.IDCustomer
		 inner join DIM_MODEL DM on DM.IDModel=FT.IDModel
		inner join DIM_MANUFACTURER DMM on DMM.IDManufacturer=DM.IDManufacturer
		group by year(ft.date),dc.Customer_Name 
		order by  dc.Customer_Name asc,year(ft.date) asc,avg(ft.TotalPrice)asc
		
		


--Q10--END
	