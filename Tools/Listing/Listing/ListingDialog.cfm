<cfoutput>

	<!--- -------------- --->
	<!--- - dialog wf  - --->
	<!--- -------------- --->	
	<cfset l = len(url.ajaxid)>
	
	<cfif l eq 37 and mid(url.ajaxId,1,1) eq "c">	
		<cfset id = mid(url.ajaxid, 2, l-1)>			
	<cfelse>
		<cfset id = url.ajaxid>		
	</cfif>		
	
			
	<script>
	try {		
		//applyfilter('1','','#id#')			
	} catch(e) {}			
	</script>		
			    		
	<cfquery name="Doc" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  OrganizationObject
		WHERE ObjectKeyValue4 = '#id#' 
		AND   Operational = 1
	</cfquery>
		
	<cfif Doc.recordcount gte "1">
						
	   <cf_ActionListing 
	    TableWidth       = "100%"
	    EntityCode       = "#Doc.EntityCode#"
		EntityClass      = "#Doc.EntityClass#"
		EntityGroup      = "#Doc.EntityGroup#"
		Mission          = "#Doc.Mission#"
		OrgUnit          = "#Doc.OrgUnit#"
		Communicator     = "Yes"
		Annotation       = "No"
		ObjectReference  = "#Doc.ObjectReference#"
		ObjectKey4       = "#id#"
		AjaxId           = "#url.ajaxid#">		
		
	</cfif>	
	
</cfoutput>	
	