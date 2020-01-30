	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.SalaryEffective#">
	<cfset eff = #dateValue#>

	<cfquery name="Delete"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE   FROM SalaryScale
	WHERE    SalarySchedule  = '#URL.Schedule#'
	   AND   Mission         = '#URL.Mission#'
	   AND   ServiceLocation = '#URL.Location#'
	    AND  SalaryEffective   = #eff#  
	</cfquery>

	<cfquery name="Check"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM SalaryScale
	WHERE    SalarySchedule  = '#URL.Schedule#'
	   AND   Mission         = '#URL.Mission#'
	   AND   ServiceLocation = '#URL.Location#'
	   AND   Operational = 1	  
	</cfquery>

	<cfoutput>
	<script language="JavaScript">
	    parent.ColdFusion.navigate('RateViewTree.cfm?mission=#url.mission#&schedule=#url.schedule#&location=#url.location#','treebox') 
    	window.location = "RateEdit.cfm?Effective=#DateFormat(check.SalaryEffective, client.DateSQL)#&Schedule=#URL.Schedule#&Mission=#URL.Mission#&Location=#URL.Location#&mode=Grade&operational=1"
	</script>
	</cfoutput>
