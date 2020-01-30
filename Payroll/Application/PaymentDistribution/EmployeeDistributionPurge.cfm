<cfset dateValue = "">
<cf_DateConvert Value="#url.dateEffective#">
<cfset vDateEffective = dateValue>

<cfquery name="remove" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		DELETE
		FROM 	PersonDistribution
		WHERE 	PersonNo = '#url.id#'	
		AND 	Operational = 1
		AND 	DateEffective = #vDateEffective#
</cfquery>

<script>
	reloadDist('view');
</script>