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