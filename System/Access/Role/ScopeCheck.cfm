<cf_compression>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_AuthorizationRole
	WHERE Role = '#url.Role#'
</cfquery>
   
<cfif Check.OrgUnitLevel neq url.OrgUnitLevel>
   
   <font color="FF0000">ALERT: Change of the Scope will purge all Authorization entries for this role!</font>
        
</cfif>