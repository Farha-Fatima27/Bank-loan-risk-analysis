select * from [dbo].[bank_loan_data_cleaned]

select top 10 * from [dbo].[bank_loan_data_cleaned]

--Section 1 : Customer Profile Analysis
--1:Total Customers
select count(*) [Total_Customers] from [dbo].[bank_loan_data_cleaned]

--2:Customer gender Distribution
select person_gender,count(*) [Total_Customers],cast(round(count(*) * 100.0 /sum(count(*)) over(),2) as decimal(5,2)) [Percentage] from [dbo].[bank_loan_data_cleaned]
group by person_gender
order by [Total_Customers] desc

--3:Age Group Distribution
with Age_CTE as(
select person_gender,
case 
when person_age between 18 and 25 then '18-25'
when person_age between 26 and 35 then '26-35'
when person_age between 36 and 45 then '36-45'
when person_age between 46 and 55 then '46-55'
else '56+' end as Age_Group
from [dbo].[bank_loan_data_cleaned])
select Age_Group,count(*) [Total_Customers] from Age_CTE
group by Age_Group
order by [Total_Customers] desc

--4:Education Level Distribution
select person_education,count(*) Total_Customers from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Total_Customers

--5:Home Ownership Distribution
select person_home_ownership,count(*) Total_Customers from [dbo].[bank_loan_data_cleaned]
group by person_home_ownership
order by Total_Customers

--6:Average Income by Education
select person_education,round(avg(person_income),2) Average_Income from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Average_Income desc

--7:Average Income by Home Ownership
select person_home_ownership,round(avg(person_income),2) Average_Income from [dbo].[bank_loan_data_cleaned]
group by person_home_ownership
order by Average_Income desc

--8:Average Credit Score by Education
select person_education,round(avg(credit_score),2) Average_Credit_Score from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Average_Credit_Score desc

--9:Customer Income Segmentation
with Income_CTE as (
select
case 
when person_income < 30000 then 'Low Income'
when person_income between 30000 and 60000 then 'Middle Income'
when person_income between 60001 and 100000 then 'Upper Middle'
else 'High Income' end Income_Group
from [dbo].[bank_loan_data_cleaned])
select Income_group ,count(*) Total_Customers from Income_CTE
group by Income_Group
order by Total_Customers desc

--10:Average Employment Experience by Age Group
with Age_CTE as(
select person_emp_exp,
case 
when person_age between 18 and 25 then '18-25'
when person_age between 26 and 35 then '26-35'
when person_age between 36 and 45 then '36-45'
when person_age between 46 and 55 then '46-55'
else '56+'
end as Age_Group
from [dbo].[bank_loan_data_cleaned])

select Age_Group,round(avg(person_emp_exp),2) Average_emp_exp
from Age_CTE
group by Age_Group
order by Average_emp_exp desc

--Section 2 : Loan portfolio Analysis
--11 : total Loan Amount Distributed
select sum(loan_amnt) Total_Loan_Amount from [dbo].[bank_loan_data_cleaned]

--12:Average Loan Amount
select round(avg(loan_amnt),2) Average_Loan_Amount from [dbo].[bank_loan_data_cleaned]

--13:Loan Intent Distribution
select loan_intent,count(*) Total_loan from [dbo].[bank_loan_data_cleaned]
group by loan_intent
order by Total_loan desc

--14:Average Loan Amount by Loan Intent
select loan_intent,round(avg(loan_amnt),2) Average_Loan_Amount from [dbo].[bank_loan_data_cleaned]
group by loan_intent
order by Average_Loan_Amount desc

--15:Average Interset Rate by loan Intent
select loan_intent,round(avg(loan_int_rate),2) Average_Interest_Loan from [dbo].[bank_loan_data_cleaned]
group by loan_intent
order by Average_Interest_Loan desc

--16:Loan Approval VS Rejection
select loan_status,count(*) Total_Applications,cast(round(count(*) * 100.0 / sum(count(*)) over(),2) as decimal(5,2))  [Percentage] from [dbo].[bank_loan_data_cleaned]
group by loan_status
order by [Percentage] desc

--17:Average Loan Amount by Education
select person_education,round(avg(loan_amnt),2) Average_Loan_Amount from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Average_Loan_Amount desc

--18:Average Loan Amount by Home Ownership
select person_home_ownership,round(avg(loan_amnt),2) Average_Loan_Amount from [dbo].[bank_loan_data_cleaned]
group by person_home_ownership
order by Average_Loan_Amount desc

--19:Top 10 Highest Loan Amount
select top 10
person_age,person_gender,person_income,loan_amnt,loan_intent,credit_score from [dbo].[bank_loan_data_cleaned]
order by loan_amnt

--20:Average Loan Percentage of Income
select round(avg(loan_percent_income),2) Average_Loan_Percentage from [dbo].[bank_loan_data_cleaned]

--Section 3 : Credit Risk Analysis
--21 : Average credit score by education
select person_education,round(avg(credit_score),2) Average_Credit_Score from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Average_Credit_Score desc

--22:Credit Score Categories
with Credit_Score_CTE as(
select case
when credit_score < 600 then 'Poor'
when credit_score between 600 and 699 then 'Fair'
when credit_score between 700 and 749 then 'Good'
else 'Excellent'
end as Credit_Category
from [dbo].[bank_loan_data_cleaned])
select Credit_Category,count(*) Total_Customers from Credit_Score_CTE
group by Credit_Category
order by Total_Customers desc

--23:Previous Loan defaults
select previous_loan_defaults_on_file ,cast(round(count(*) * 100.0 /sum(count(*)) over() ,2) as decimal(5,2)) [Percentage] from [dbo].[bank_loan_data_cleaned]
group by previous_loan_defaults_on_file
order by [Percentage] desc

--24:Average Credit Score by Home Ownership
select person_home_ownership,round(avg(credit_score),2) Average_Credit_Score from [dbo].[bank_loan_data_cleaned]
group by person_home_ownership
order by Average_Credit_Score desc

--25:Average Interest rate by Credit Score Category
with Credit_Score_CTE as(
select case
when credit_score < 600 then 'Poor'
when credit_score between 600 and 699 then 'Fair'
when credit_score between 700 and 749 then 'Good'
else 'Excellent'
end as Credit_Category,loan_int_rate
from [dbo].[bank_loan_data_cleaned])
select Credit_Category,round(avg(loan_int_rate),2) Average_Loan_int_rate from Credit_Score_CTE
group by Credit_Category
order by Average_Loan_int_rate desc

--26:Top 10 customers with Highest Credit Score
select person_age,person_gender,person_income,credit_score,loan_amnt from [dbo].[bank_loan_data_cleaned]
order by credit_score desc

--Secton 4: Advance Business Analysis
--27:Rank Loan Intents by Average Loan Amount
select loan_intent,round(avg(loan_amnt),2) Average_Loan_Amount ,
rank() over(order by avg(loan_amnt) desc) as Loan_Rank
from [dbo].[bank_loan_data_cleaned]
group by loan_intent

--28:Top 5 Highest Income Customers within Each Education level
with Income_Rank as (
select person_education,person_income,credit_score,loan_amnt,
ROW_NUMBER() over(partition by person_education order by person_income desc) as RN
from [dbo].[bank_loan_data_cleaned])
select * from Income_Rank 
where RN <=5

--29:Income vs Overall Average Income
select 
person_age,person_income,
case when 
person_income > (select avg(cast(person_income as bigint)) from [dbo].[bank_loan_data_cleaned])
then 'Above average'
else 'Below Average'
end as Income_Category
from [dbo].[bank_loan_data_cleaned]

--30:Customer Risk Category
select person_income,credit_score,previous_loan_defaults_on_file,
case when credit_score <600 and previous_loan_defaults_on_file = 1
then 'High Risk'
when credit_score between 600 and 699 then 'Medium Risk'
else 'Low Risk' end as Risk_Category 
from [dbo].[bank_loan_data_cleaned]

--31:Average Loan by Income Category
with Income_CTE as (
select
case 
when person_income < 30000 then 'Low Income'
when person_income between 30000 and 60000 then 'Middle Income'
when person_income between 60001 and 100000 then 'Upper Middle'
else 'High Income' end Income_Group,loan_amnt
from [dbo].[bank_loan_data_cleaned])
select Income_Group,round(avg(loan_amnt),2) Avg_loan from Income_CTE
group by Income_Group
order by Avg_loan

--32:Highest Credit Score in Each Education level
select person_education,max(credit_score) Highest_Credit_Score from [dbo].[bank_loan_data_cleaned]
group by person_education
order by Highest_Credit_Score desc