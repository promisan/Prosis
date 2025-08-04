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

<cfquery name="Actions" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  #preservesinglequotes(myact)#
  ORDER BY ActionFlowOrder ASC
</cfquery>

<cfset prior    = Object.Created>
<cfset keepdate = Object.Created>

<cfoutput query="Actions">

	<cfif OfficerDate neq "" and prior neq "">	   
						
			<cfset leadtime = DateDiff("n", "#prior#", "#OfficerDate#")>
			<cfset leadtime = numberformat(leadtime/60,"_._")> 
						
			<cfset keepdate = OfficerDate>	
						
			<cfif ActionConcurrent eq "0">			   
				<cfset prior = keepdate>	
			<cfelse>
			    <!--- compare the concurrent action against the last sequence time 
				so we do not change prior --->	
			</cfif>	
			
			<cfif OfficerLeadTime neq LeadTime>
			
					<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					UPDATE OrganizationObjectAction 
					SET    OfficerLeadTime = '#leadtime#'					
					WHERE  ActionId        = '#ActionId#'				
				</cfquery>
				
			</cfif>
											
	</cfif>
	
</cfoutput>