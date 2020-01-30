<cfquery name="getMission" 
	datasource="AppsOrganization">
		SELECT 	*
		FROM 	Ref_Mission
		WHERE	Mission = '#url.mission#'
</cfquery>
		
<cfinclude template="OrgTreeView.cfm">		
	