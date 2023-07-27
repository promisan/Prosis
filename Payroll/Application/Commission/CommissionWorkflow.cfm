
<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">												
	SELECT      *
	FROM        Organization.dbo.OrganizationAction AS A 
	WHERE       OrgUnitActionId = '#url.ajaxid#'
</cfquery>	
				
<cfquery name="org" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT * FROM Organization.dbo.Organization WHERE OrgUnit = '#get.orgunit#'	
</cfquery>			

<cfset link = "Payroll/Application/Commission/CommissionListing.cfm?ajaxid=#url.ajaxid#&ID0=#org.OrgUnit#">
		
<cf_ActionListing 
	    EntityCode       = "OrgAction"
		EntityClass      = "Payroll"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#org.Mission#"
		OrgUnit          = "#org.OrgUnit#"
		ObjectReference  = "Miscellneous #org.OrgUnitName# #dateformat(get.CalendarDateEnd,'YYYY/MM')#"			    
		ObjectKey4       = "#URL.AjaxId#"
		AjaxId           = "#URL.AjaxId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "Yes">