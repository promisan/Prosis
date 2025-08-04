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
<cfparam name="url.mission" default="">
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ModuleControlRoleMission
			    (SystemFunctionId,
				 Role,
				 Mission,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
			  ('#URL.functionId#',
				'#URL.Role#',
				'#URL.Mission#',
				'#SESSION.acc#',
		   		'#SESSION.last#',
		   		'#SESSION.first#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM Ref_ModuleControlRoleMission
		  WHERE  SystemFunctionId = '#URL.functionId#' 
		  AND    Role = '#URL.Role#'
		  AND	 Mission = '#URL.Mission#'
	</cfquery>
		
</cfif>

<cfquery name="MissionRole" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*, R.MissionName, R.MissionType				 	
		  FROM   Ref_ModuleControlRoleMission M,
		  		 Organization.dbo.Ref_Mission R
		  WHERE  M.Mission = R.Mission
		  AND    M.SystemFunctionId = '#URL.functionId#' 
		  AND    M.Role = '#URL.Role#'
		  AND	 M.Mission is not null
		  ORDER BY R.MissionType, M.Mission
</cfquery>
	
   <table width="99%" align="center" class="navigation_table">
  
   <tr class="labelmedium line fixlengthlist">
   		<td></td>
   		<td>No.</td>
		<td>Mission</td>
		<td>Officer</td>
		<td>Created</td>
		<td></td>
   </tr>			
    			   
   <cfif MissionRole.recordCount eq 0>
   <tr><td style="height:40px" colspan="5" align="center" class="labelmedium2"><font color="gray">Enabled for any entities</font></td></tr>
   </cfif>
   
   <cfoutput query="MissionRole" group="MissionType">
	  
	  <tr><td colspan="6" class="labelmedium"><b>#MissionType#</b></td></tr>
	  
	  <cfoutput>
		
	   <tr class="line labelmedium2 navigation_row fixlengthlist">
	   	  <td></td>
	   	  <td>#currentrow#.</td>
	      <td>[#Mission#] #MissionName#</td>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#dateformat(created,CLIENT.DateFormatShow)#</td>			   
		  <td style="padding-top:5px"><cf_img icon="delete" onclick="javascript:ptoken.navigate('#SESSION.root#/System/Modules/Functions/RecordMission.cfm?action=delete&functionId=#URL.functionId#&role=#url.Role#&mission=#URLEncodedFormat(Mission)#','MissionRole')"></td>		  
	   </tr>  
	   
       </cfoutput>
   </cfoutput>   
   
   <tr><td height="10"></td></tr>
   <tr>
   		<td colspan="6" align="center">		
		<cfoutput>
		<table class="formspacing"><tr><td>
			<input type="Button" value="Clear" class="button10g" onclick="javascript: if (confirm('This action will remove all entities assigned, continue ?')) { ptoken.navigate('RecordMissionAssignAll.cfm?ID=#URL.functionId#&ID1=#url.role#&type=Remove','MissionRole') }">			
			</td>
			<td>
   			<input type="Button" value="Close" class="button10g" onclick="ptoken.navigate('#SESSION.root#/System/Modules/Functions/Role_Mission.cfm?ID=#URL.functionId#&role=#url.role#', 'divRoleMission_#URL.functionId#_#url.role#'); ProsisUI.closeWindow('mydialog');">						
			</td>
			</tr>
		</table>	
		</cfoutput>
		</td>
	</tr>
   
   </table>
   
   <cfset ajaxonload("doHighlight")>