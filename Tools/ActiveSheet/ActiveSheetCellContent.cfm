
<cfparam name="url.mode" default="collapsed">

<cfif url.module eq "CaseFile">
					
		<cfquery name="Element" 
		    datasource="appsCaseFile" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM   Element
			WHERE  ElementId = '#url.elementid#'
		</cfquery>	
			
		<cftry> 
			<cfinclude template="#url.module#/Cell/#element.elementclass#.cfm">
		<cfcatch>Content not found</cfcatch>
		</cftry>
			
<cfelse>
	
   <!--- other modules --->		
	
</cfif>

