<cfparam name="url.useraccount" default="">

<cfquery name="get" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT  * 
		FROM    OrganizationObjectActionSession		
		WHERE   ActionId        = '#url.ActionId#'	
		<cfif url.useraccount neq "">
		AND     UserAccount     = '#url.useraccount#'
		</cfif>
		AND     EntityReference = '#url.entityReference#'
	</cfquery>
	
<cfoutput>
	
<cfif get.recordcount eq "0">	

	<img src="#session.root#/images/logos/system/communication.png" style="height:20px;width:22px" title="Candidate communication not enabled" 
    onclick="workflowsession('#url.ActionId#','#url.entityReference#','#url.useraccount#')">
	
<cfelse>

		<img src="#session.root#/images/logos/system/session.png" style="height:24px;width:22px" title="Candidate communication enabled" 
    onclick="workflowsession('#url.ActionId#','#url.entityReference#','#url.useraccount#')">

</cfif>	

</cfoutput>	