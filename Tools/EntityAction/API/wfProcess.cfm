<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<!--- close a workflow step to be be combined with wfExtenral --->

<cfparam name="Attributes.Datasource"   default="appsOrganization">
<cfparam name="Attributes.Action"       default="skip">
<cfparam name="Attributes.ActionId"     default="">
<cfparam name="Attributes.Memo"         default="">

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

