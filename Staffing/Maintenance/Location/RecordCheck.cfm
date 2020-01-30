
<!--- checking --->

<cfquery name="Verify" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Location
		WHERE  LocationCode  = '#url.code#' 
	</cfquery>
	
<cfif verify.recordcount gte "1">

	<font color="FF0000">Code in use</font>

</cfif>	