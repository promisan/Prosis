
<!--- close a workflow step to be be combined with wfExtenral --->

<cfparam name="Attributes.Datasource"   default="appsOrganization">
<cfparam name="Attributes.Action"   default="skip">
<cfparam name="Attributes.ActionId" default="">
<cfparam name="Attributes.Memo" default="">

<cfif attributes.actionId neq "">
	
	<cfif attributes.action eq "skip">
	
		<cfquery name="get" 
		   datasource="#attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#"> 
			SELECT  R.ActionType
			FROM    Organization.dbo.OrganizationObjectAction A INNER JOIN
	                Organization.dbo.Ref_EntityActionPublish R ON A.ActionPublishNo = R.ActionPublishNo AND A.ActionCode = R.ActionCode
			WHERE   A.ActionId = '#attributes.actionid#'
		</cfquery>	
		
		<cfif get.ActionType eq "Action">
			<cfset st = "2">		
		<cfelse>
			<cfset st = "2y">		
		</cfif>
		
		<cfquery name="ProcessStep" 
		   datasource="#attributes.DataSource#" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#"> 
		    UPDATE Organization.dbo.OrganizationObjectAction
		    SET    ActionStatus     = '#st#',
		           ActionMemo       = '#attributes.memo#',
		           OfficerUserId    = '#session.acc#',
		           OfficerLastName  = 'Agent',
		           OfficerFirstName = 'System',            
		           OfficerDate      = getDate()          
		    WHERE  ActionId         = '#attributes.ActionId#'
		    AND    ActionStatus     = '0'    
		</cfquery>
	
	</cfif>

</cfif>

