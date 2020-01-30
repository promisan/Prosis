
<cfquery name="Combination"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT DISTINCT S.Mission, 
          S.SalarySchedule, 
		  S.DateEffective, 
		  L.LocationCode
   FROM   SalaryScheduleMission S,
		   Ref_PayrollLocationMission  L    
   WHERE  S.Mission = L.Mission		 
   ORDER BY S.Mission,S.SalarySchedule 
</cfquery>

<cfloop query="combination">
	
		<cfquery name="Check"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT *
		   FROM   SalaryScale
		   WHERE  Mission         = '#Mission#'
		   AND    SalarySchedule  = '#SalarySchedule#'
		   <!---
		   AND    ServiceLocation = '#LocationCode#'
		   --->
		   AND    SalaryEffective <= '#DateEffective#' 
		</cfquery>		
	
		<cfif Check.recordcount eq "0">
		
			<cfquery name="Insert"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO SalaryScale
				(SalarySchedule, 
				 Mission, 
				 ServiceLocation, 
				 SalaryEffective, 
				 SalaryFirstApplied, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
				 VALUES ('#Combination.SalarySchedule#', 
				         '#Combination.Mission#',
						 '#Combination.LocationCode#',
						 '#Combination.DateEffective#',
						 '#Combination.DateEffective#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')  
			</cfquery>
		
		</cfif>
		
</cfloop>
