
<!--- check if code exists --->

 <cfquery name="entity" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
        SELECT * 
		FROM   Ref_Entity 
		WHERE EntityCode = '#url.entityCode#' 
 </cfquery>
 
 <cfquery name="check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_EntityAction
            WHERE      ActionCode = '#Entity.EntityAcronym##url.value#'			
</cfquery>

<cfif check.recordcount eq "0">

	<table><tr><td style="height:14px;width:14px;background-color:green"></td></tr></table>
	
<cfelse>

	<table><tr><td style="height:14px;width:14px;background-color:red"></td></tr></table>

</cfif>