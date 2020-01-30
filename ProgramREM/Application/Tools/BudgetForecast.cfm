
<!--- forecast recording --->

<cfparam name="URL.Period" default="">
<cfparam name="URL.Mission" default="">

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Period
	WHERE   Period = '#URL.Period#'
</cfquery>

SELECT      SalarySchedule, MAX(PayrollEnd) AS Expr1
FROM        SalarySchedulePeriod
WHERE       Mission = '#url.mission#' 
AND         CalculationStatus = '3'
GROUP BY    SalarySchedule



<!--- define until which period we have already data posted under this effective period 

clean the prior postings
loop through each month per program and make a posting 

--->







