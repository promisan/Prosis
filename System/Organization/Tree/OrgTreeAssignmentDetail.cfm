
<!--- template used for load one user selects a tree, not on the fly --->

<cfparam name="url.mode" default="preload">

<cfoutput>
	<cfif URL.Summary eq "0">	
		<cfinclude template="OrgTreeAssignmentDetailList.cfm">				
	<cfelse>
		<cfinclude template="OrgTreeAssignmentDetailSummary.cfm">			
	</cfif>
</cfoutput>
