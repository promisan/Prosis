
<cfif url.objectid neq "">
    
    <cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  OrganizationObject
			WHERE ObjectId = '#URL.objectid#' or ObjectKeyValue4 = '#URL.ObjectId#'
    </cfquery>		
			
	<cfif Object.ObjectId neq "">
	
	<cfset url.objectid = Object.ObjectId>
		
	<cfif url.item eq "Mail">	
	 	<cfinclude template="Notes/NoteView.cfm"> 
	<cfelseif url.item eq "Cost">
		<cfinclude template="Cost/CostView.cfm">
	</cfif>
	
	<cfelse>
	
	 <cf_screentop html="No" title="Problem">	
	 <table align="center"><tr><td class="labelt" align="center" height="40">Annotation feature could not be initialised as no workflow object has been created.</td></tr></table>
	 
	</cfif>
	
<cfelse>
		
	 <cf_screentop html="No" title="Problem">
	 <table align="center"><tr><td class="labelt" align="center" height="40">Annotation feature has not been initialised for this document.</td></tr></table>
		
</cfif>

	