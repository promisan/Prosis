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
<cfquery name="Report" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_ReportControl
	 WHERE  Controlid = '#URL.id#'	  
</cfquery>

<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>

<cfif class.recordcount gt 0>
	
	<cfif Class.OrgUnitLevel neq "Global">
	
	    <!--- only for roles that are tree enabled --->
		   
		<cfquery name="MissionList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	R.*,
							(SELECT Mission
						    FROM  System.dbo.Ref_ReportControlRoleMission
							WHERE ControlId = '#url.id#'
							AND   Role = '#url.role#'
							AND   Mission = R.Mission) as Selected
				    FROM  	Ref_Mission R 	
					WHERE 	R.Operational = 1	
					AND     R.Mission IN (SELECT Mission 
					                      FROM   Ref_MissionModule 
										  WHERE  SystemModule = '#Report.SystemModule#')
		</cfquery>
		   
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
		   		<cfoutput>
				<tr>
				<cfset cnt = 0>
				<cfset mcols = 5>
				<cfloop query="MissionList">
					<cfset cnt = cnt + 1>
					<cfset vMission = replace(mission, "-", "_", "ALL")>
					<td class="labelit" width="#100/mcols#%" id="td_#vMission#" <cfif selected eq mission>style="background-color:'E7FEEA';"</cfif>>
					    <table><tr><td>
						<label onclick="selectcell('#vMission#');">
							<input class="radiol" type="checkbox" name="mission_#vMission#" id="mission_#vMission#" value="1" <cfif selected eq mission>checked</cfif>> 
						</label>						
						</td>
						<td style="height:22px;padding-left:4px" class="labelmedium">#Mission#</td>
						</tr></table>
					</td>
					<cfif cnt eq mcols>
						</tr>
						<tr>
						<cfset cnt = 0>
					</cfif>
				</cfloop>
				</tr>
				</cfoutput>
		</table>	
		   
   <cfelse>
	   
   	 N/A   
		 
   </cfif>		
 
<cfelse>

	<cf_compression>	 	   
   
</cfif>   