
<!--- get the active date --->

 <cfquery name="Period" 
		datasource="AppsPayroll"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    TOP 1 Mission, SalarySchedule, PayrollStart, PayrollEnd
			FROM      SalarySchedulePeriod
			WHERE     Mission = '#url.mission#' 
			AND       CalculationStatus IN ('0', '1', '2') 
			AND       SalarySchedule = '#url.schedule#' 
  </cfquery>	

<cfoutput>	  
  #dateformat(Period.PayrollEnd,client.dateformatshow)#
</cfoutput>  
