
<!--- check if code exists --->
 
 <cfquery name="check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_EntityDocument
            WHERE      EntityCode = '#url.entityCode#'
			AND        DocumentCode = '#url.value#'		
</cfquery>

<cfif check.recordcount eq "0">

	<table><tr><td style="height:14px;width:14px;background-color:green"></td></tr></table>
	
<cfelse>

	<table><tr><td style="height:14px;width:14px;background-color:red"></td></tr></table>

</cfif>