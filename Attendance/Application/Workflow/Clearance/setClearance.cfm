<!--
    Copyright © 2025 Promisan B.V.

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
<cfif url.val eq "0">

	<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			DELETE 	FROM    OrganizationActionPerson
			WHERE   OrgUnitActionId  = '#url.id#' 
			AND     PersonNo         = '#url.personno#'
	</cfquery>	

<cfelse>

	<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationActionPerson
			WHERE   OrgUnitActionId  = '#url.id#' 
			AND     PersonNo         = '#url.personno#'
	</cfquery>	
	
	

	<cfif get.recordcount eq "1">
	
		<cfif get.actionstatus neq url.val>
		
			<cfquery name="edit" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  OrganizationActionPerson
				SET     ActionStatus     = '#url.val#',
				        OfficerUserId    = '#session.acc#',
						OfficerLastName  = '#session.last#',
						OfficerFirstName = '#session.first#',
						Created          = getDate()
				WHERE   OrgUnitActionId  = '#url.id#' 
				AND     PersonNo         = '#url.personno#'
			</cfquery>	
		
		</cfif>
	
	<cfelse>
	
		<cfquery name="insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO OrganizationActionPerson
			(OrgUnitActionId, PersonNo, ActionStatus, OfficerUserId, OfficerlastName, OfficerFirstName, Created)
			VALUES
			('#url.id#','#url.personno#','#url.val#','#session.acc#','#session.last#','#session.first#',getDate())		
		</cfquery>	
	
	</cfif>
	
</cfif>	

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationActionPerson
			WHERE   OrgUnitActionId  = '#url.id#' 
			AND     PersonNo         = '#url.personno#'
</cfquery>	

<cfoutput query="get">

<table>
<tr class="labelmedium2">
	<td style="height:20px;padding-left:8px;padding-top:3px">#dateformat(get.created,"MM/DD")# #timeformat(get.created,"HH:MM")# : #get.OfficerLastName#</td>
	
	<td align="right" style="padding-right;4px">
																			
		<img src="#SESSION.root#/Images/memo.png" height="22" alt="Enter remarks" 
		id="detail_#personno#Exp" border="0" class="regular" 						
		align="middle" style="cursor: pointer;" 
		onClick="memoshow('detail_#url.personno#','show','#url.id#','#url.personno#')">
	
	    <img src="#SESSION.root#/Images/arrowdown.gif" 
		id="detail_#personno#Min" alt="Hide remarks" border="0" 
		align="middle" class="hide" style="cursor: pointer;" 
		onClick="memoshow('detail_#url.personno#','hide','#url.id#','#url.personno#')">
			
	</td>
</tr>
</table>


</cfoutput>