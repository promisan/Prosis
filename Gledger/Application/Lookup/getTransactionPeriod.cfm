
<!--- gets the account periods based on the entity, fiscalyear and type of report --->

<cfparam name="url.mission"    default="">
<cfparam name="url.period"     default="">
<cfparam name="url.pap"        default="">

<cfquery name="Period"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT TransactionPeriod
	FROM      TransactionHeader
	WHERE     Mission       = '#url.mission#' 
	<cfif url.period neq "all">
	AND       AccountPeriod = '#url.period#'	
	</cfif>
	ORDER BY  TransactionPeriod DESC
</cfquery>

<select id="transactionperiod" name="TransactionPeriod" class="regularxl" style="border:0px" onchange="reloadForm()">

    <option value="" selected>All</option>
	<cfoutput query="Period">
		<option value="#TransactionPeriod#" <cfif url.pap eq transactionperiod>selected</cfif>>#TransactionPeriod#</option>
	</cfoutput>

</select>
	
