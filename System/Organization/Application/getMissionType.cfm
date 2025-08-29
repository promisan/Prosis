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
<cfquery name="Topic" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_GroupMission
	  WHERE  Code IN (SELECT GroupCode FROM Ref_GroupMissionList)
	  
	  AND    Code IN (SELECT GroupCode FROM Ref_GroupMissionType WHERE MissionType = '#url.missionType#')
	  
</cfquery>
	
<cfif Topic.recordcount gt "0">

	<table cellspacing="0" cellpadding="0" class="formpadding">

	<cfoutput query="topic">
		
	<tr class="labelmedium">
		<td style="min-width:200px;padding-left:40px">#Description#: <font color="FF0000">*</font><cf_space spaces="40"></td>
		<td style="width:100%">
		
			<cfquery name="List" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT *
			   FROM    Ref_GroupMissionList
			   WHERE   GroupCode = '#Code#'
			</cfquery>
			
			<cfquery name="MissionTopic" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  TOP 1 *
			  FROM    Ref_MissionGroup
			  WHERE   Mission  = '#URL.Mission#'
			  AND     GroupCode = '#Code#'
		    </cfquery>
							
			<select name="ListCode_#Code#" id="ListCode_#Code#" class="enterastab regularxl">
			    <option value=""><cf_tl id="N/A"></option>
				<cfloop query="List">
				<option value="#GroupListCode#" <cfif MissionTopic.GroupListCode eq GroupListCode>selected</cfif>>#Description#</option>
				</cfloop>
			</select>
		
		</td>
	</tr>
	
	</cfoutput>
	
	</table>
	
	
</cfif>