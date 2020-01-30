<cfset vQuery = trim(UCase(CellValueQuery))>
<cfset vCellResultString = "--">

<cfif vQuery neq "">

	<cfset vQuery = replace(vQuery, "@ID", "#url.systemfunctionid#", "ALL")>
	<cfset vQuery = replace(vQuery, "@MISSION", "#url.mission#", "ALL")>
	<cfset vQuery = replace(vQuery, "@USER", "#session.acc#", "ALL")>
	<cfset vQuery = replace(vQuery, "@TODAY", "GETDATE()", "ALL")>
	
	<cfquery name="getCellResult" 
		datasource="#CellValueDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		 
			#preserveSingleQuotes(vQuery)#
	</cfquery>
	
	<cfset vCellResult = evaluate("getCellResult.#CellValueField#")>
	
	<cfif lcase(CellValueFormat) eq "number">
		<cfset vCellResultString = lsNumberFormat(vCellResult, ",")>
	</cfif>
	
	<cfif lcase(CellValueFormat) eq "currency">
		<cfset vCellResultString = lsNumberFormat(vCellResult, ",.__")>
		<cfset vCellResultString = "#application.baseCurrency# #vCellResultString#">
	</cfif>
	
	<cfif lcase(CellValueFormat) eq "text">
		<cfset vCellResultString = vCellResult>
	</cfif>

</cfif>