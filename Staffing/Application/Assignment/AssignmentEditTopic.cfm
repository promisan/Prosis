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

<cfparam name="editmode" default="edit">

<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	     FROM  Ref_PersonGroup
		 WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)
		 
		 AND   Operational = 1
		 
		 AND   Context = 'Assignment'
		 AND   Code != 'AssignEnd'
		 		 
		 <cfif getAdministrator(Position.mission) eq "1">
	
		<!--- no filtering --->

		 <cfelse>		
		 
		 AND   Code IN (SELECT GroupCode 
		                FROM   Ref_PersonGroupRole						
						WHERE  Role IN (SELECT DISTINCT Role 
		                                FROM   Organization.dbo.OrganizationAuthorization
										WHERE  UserAccount = '#SESSION.acc#')
						)	
											
		 AND   Code IN (SELECT GroupCode
		                FROM   Ref_PersonGroupOwner				
						WHERE  Owner IN (SELECT MissionOwner
						                 FROM   Organization.dbo.Ref_Mission
										 WHERE  Mission = '#Position.Mission#')
										
					   )									   
														   
		 </cfif>	
		 											   
</cfquery>

<cfparam name="url.id1" default="">
	
<cfif Topic.recordcount gt "0">
	
	<cfoutput query="topic">
	
		<tr>
			<td class="labelmedium">#Description#:</td>
			<td>
			
			<cfquery name="PersonTopic" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT TOP 1 G.*,L.Description
					  FROM  PersonAssignmentTopic G, Ref_PersonGroupList L
					  <cfif url.id1 neq "">
					  WHERE G.AssignmentNo  = '#URL.ID1#' 
					  <cfelse>
					  WHERE 1 = 0
					  </cfif>
					  AND   G.GroupCode     = '#Code#'
					  AND   L.GroupCode     = G.GroupCode
					  AND   G.GroupListCode = L.GroupListCode
			    </cfquery>
			
			<cfif editmode eq "view">
			
				<cfif PersonTopic.Description eq "">n/a<cfelse>
				<cfoutput>#PersonTopic.Description#</cfoutput>
				</cfif>
			
			<cfelse>
					
				<cfquery name="List" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT  *
					  FROM     Ref_PersonGroupList
					  WHERE    GroupCode = '#Code#'
					  AND      Operational = 1
					  ORDER BY GroupListOrder
				</cfquery>						
								
				<select name="ListCode_#Code#" required="No" class="regularxl" 
					onchange="<cfif ActionCode neq ''>checkaction('#Code#',this.value,'group')</cfif>">
					<cfloop query="List">
					<option value="#GroupListCode#" <cfif PersonTopic.GroupListCode eq "#GroupListCode#">selected</cfif>>#Description#</option>
					</cfloop>
				</select>
			
			</cfif>
			
			</td>
				
		</tr>	
				
	</cfoutput>
	
</cfif>