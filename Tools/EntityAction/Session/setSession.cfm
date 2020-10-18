<cfquery name="get" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT  * 
		FROM    OrganizationObjectActionSession		
		WHERE   ActionId = '#url.ActionId#'	
		AND     EntityReference = '#url.entityReference#'
	</cfquery>
	
<cfoutput>
	
<cfif get.recordcount eq "0">	

	<img src="#session.root#/images/logos/system/communication.png" style="height:20px;width:22px" alt="Candidate communication" 
    border="0" onclick="workflowsession('#url.ActionId#','#url.entityReference#')">
	
<cfelse>

		<img src="#session.root#/images/logos/system/session.png" style="height:24px;width:22px" alt="Candidate communication" 
    border="0" onclick="workflowsession('#url.ActionId#','#url.entityReference#')">

</cfif>	

</cfoutput>	