<cfquery name="getCustomers" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT	*
	FROM	Customer
	WHERE  	Mission = '#url.mission#'
	ORDER BY CustomerName
	
</cfquery>

<select name="Crit2_Value" id="Crit2_Value" class="regularxl">
	<option value="">- All -</option>
	<cfoutput query="getCustomers">
		<option value="#getCustomers.CustomerId#">#getCustomers.CustomerName#</option>
	</cfoutput>
</select>	