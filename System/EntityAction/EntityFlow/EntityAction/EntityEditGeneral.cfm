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
 <table border="0" width="95%" align="center" class="formpadding">
		
		<tr><td height="10"></td></tr>
				
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200"><cf_tl id="Identification"></td></tr>
		<tr>
					
		<TR>
	    <input type="Hidden" name="EntityCode" id="EntityCode" value="<cfoutput>#Entity.EntityCode#</cfoutput>">
		<td class="labelmedium">Name: </td>
		<td><cfinput type="Text" name="EntityDescription" value="#Entity.EntityDescription#" onchange="validate()" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
		</td>
		</TR>				
		
		<cfquery name="Role" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_AuthorizationRole
				WHERE  Role = '#Entity.Role#'
		</cfquery>	
			
		<TR class="labelmedium2">
	    <td width="160"><cf_tl id="Authorization Role">:</td>
		<td height="20"><cfoutput>#Entity.Description# / #Role.SystemModule#</cfoutput></td>
		</TR>			
			
		<TR class="labelmedium2">
	    <td><cf_tl id="Acronym">:</td>
		<td height="20"><cfoutput>#Entity.EntityAcronym#</cfoutput></td>
		</TR>	
		
		<tr class="labelmedium2">	
		<td><cf_tl id="Operational">:</td>		    
		<td><table>
		    <tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Operational" id="Operational" onclick="validate()" value="1" <cfif "1" eq Entity.Operational>checked</cfif>></td>
			<td style="padding-left:4px">Yes</td>
			<td><input type="radio" class="radiol" name="Operational" id="Operational" onclick="validate()" value="0" <cfif "0" eq Entity.Operational>checked</cfif>></td>
			<td style="padding-left:4px">No</td>
			</tr>
			</table>	
	    </td>
		</TR>
				
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200"><cf_tl id="Features"></td></tr>		
				
		<tr class="labelmedium2" style="height:20px;">		
		<td style="min-width:200"><cf_UIToolTip tooltip="Option to measure workflow performance for this document">Performance Management:</cf_UIToolTip></td>
		<td width="80%">
		    <input type="checkbox" class="radiol" name="EnablePerformance" id="EnablePerformance" onclick="validate()" value="1" <cfif "1" eq Entity.EnablePerformance>checked</cfif>>&nbsp;
		  </td>
		</TR>	
		
		
				
		<tr class="labelmedium2" style="height:20px">		
		<td style="cursor:pointer"><cf_UIToolTip tooltip="Option to define a program or project to be assicuated with the workflow">Associate Program/Project:</cf_UIToolTip></td>
		<td>
		    <input type="checkbox" class="radiol" name="EnableProgram" id="EnableProgram" onclick="validate()" value="1" <cfif "1" eq Entity.EnableProgram>checked</cfif>>&nbsp;
		  </td>
		</TR>	
				
		<tr class="labelmedium2" style="height:20px">		
		<td style="cursor:pointer"><cf_UIToolTip tooltip="Option to define, set (due method) workflow object status"><cf_tl id="Object status">:</cf_UIToolTip></td>
		<td>
		    <input type="checkbox" class="radiol" name="EnableStatus" id="EnableStatus" onclick="validate()" value="1" <cfif "1" eq Entity.EnableStatus>checked</cfif>>&nbsp;
		  </td>
		</TR>	
				
		<tr class="labelmedium2" style="height:20px">		
		<td style="cursor:pointer"><cf_UIToolTip tooltip="Option to define my clearances settings">My Clearances:</cf_UIToolTip></td>
		<td>
		<table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="ProcessMode" id="ProcessMode" onclick="validate()" value="0" <cfif "0" eq Entity.ProcessMode>checked</cfif>></td>
			<td style="padding-left:5px">Standard</td>
			<td style="padding-left:10px"><input type="radio" class="radiol" name="ProcessMode" id="ProcessMode" onclick="validate()" value="1" <cfif "1" eq Entity.ProcessMode>checked</cfif>></td>
			<td style="padding-left:5px">Messenger enabled</td>
			<td style="padding-left:10px"><input type="radio" class="radiol" name="ProcessMode" id="ProcessMode" onclick="validate()" value="9" <cfif "9" eq Entity.ProcessMode>checked</cfif>></td>
			<td style="padding-left:5px">Disable</td>
			</tr>
			</table>
		  </td>
		</TR>	
		
		<tr class="labelmedium2" style="height:20px;">		
		<td style="min-width:200"><cf_UIToolTip tooltip="Option to measure workflow performance for this document"><cf_tl id="Visible in PORTAL">:</cf_UIToolTip></td>
		<td width="80%">
		    <input type="checkbox" class="radiol" name="EnablePortal" id="EnablePortal" onclick="validate()" value="1" <cfif "1" eq Entity.EnablePortal>checked</cfif>>&nbsp;
		  </td>
		</TR>	
				
		<tr><td height="8"></td></tr>
		<tr class="line"><td colspan="2" style="font-size:28px;font-weight:200"><cf_tl id="Usage"></td></tr>
												
		<!--- currently limited to procurement only --->	
		
				
		<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Mission
				WHERE  Operational = 1
				<!--- enabled --->
				AND    Mission IN (SELECT Mission 
				                   FROM   Ref_MissionModule
								   WHERE  SystemModule = '#Role.SystemModule#'
								   <!--- diaabled AND    SystemModule IN ('Procurement','Staffing','Workorder')	--->
								  ) 	
								  
				<cfif session.isAdministrator eq "No" and SESSION.isLocalAdministrator neq "No">
				
				AND Mission IN (#preservesingleQuotes(SESSION.isLocalAdministrator)#)
				
				</cfif>				  
				ORDER BY MissionType				  
								  
		 </cfquery>
		
		<cfif mission.recordcount gte "1">
				
			<tr>
						
				<td colspan="2">
				
				<table width="100%">
				
				<tr class="line">
				   <td></td>
				   <td></td>
				   <td align="center" style="min-width:50px" class="labelit">Ena</td>
				   <td align="center" style="min-width:50px;cursor:pointer" class="labelit">&nbsp;<cf_UIToolTip  tooltip="Pointer to define if Completion of the workflow is required or if the workflow is optional <br> Example optional : Procurement Collaboration request Roster Status Review. <br>Needs to be used in code to enable"><font color="0080FF">Force</cf_UIToolTip></td>
				   <td></td>
				   <td></td>
				   <td align="center" tyle="min-width:50px" class="labelit">Ena</td>
				   <td align="center" style="min-width:50px;cursor:pointer" class="labelit"><cf_UIToolTip  tooltip="Pointer to define if Completion of the workflow is required or if the workflow is optional <br> Example optional : Procurement Collaboration request Roster Status Review. <br>Needs to be used in code to enable"><font color="0080FF">Force</cf_UIToolTip></td>
				   <td></td>
			       <td></td>
				   <td align="center" style="min-width:50px" class="labelit">Ena</td>
				   <td align="center" style="min-width:50px;cursor:pointer" class="labelit"><cf_UIToolTip  tooltip="Pointer to define if Completion of the workflow is required or if the workflow is optional <br> Example optional : Procurement Collaboration request Roster Status Review. <br>Needs to be used in code to enable"><font color="0080FF">Force</cf_UIToolTip></td>
			    </tr>
									  
				<cfoutput query="Mission" group="MissionType">
				
				<!---
				<tr class="labelmedium"><td colspan="12">#MissionType#</td></tr>
				--->
				
				<cfset row = 0>
				
					<cfoutput>
								
					<cfset row = row+1>
					
					<cfif row eq "1">
					<tr style="height:20px" class="line">
					<td style="border-left: 0px solid Silver;"></td>
					<cfelse><td style="border-left: 1px solid Silver;"></td>
					</cfif>			
					
					<td style="width:34%;padding-left:5px">#Mission#:</td>					
					
					<cfquery name="Enabled" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_EntityMission
						WHERE  EntityCode = '#Entity.EntityCode#'
						AND    Mission = '#Mission#'
					 </cfquery>
					 
					<td align="center" width="35"> 					
					  
						 <input type="checkbox" class="radiol"
						  name="WorkflowEnabled_#currentrow#" 
						  id="WorkflowEnabled_#currentrow#"
						  value="1" <cfif Enabled.WorkflowEnabled eq "1">checked</cfif>
						  onClick="savedet(this,this.checked)">
											 
					 </TD>
								 
					 <td align="center" width="35"> 					 
						
						 <input type="checkbox" class="radiol"
						  name="WorkflowEnforce_#currentrow#" 
						  id="WorkflowEnforce_#currentrow#"
						  value="1" <cfif Enabled.WorkflowEnforce eq "1">checked</cfif>
						  onClick="savedet(this,this.checked)">
						
					 
					 </TD>
					 			 
					 <cfif row eq "3">
					 	</tr>
						<cfset row = 0>
					 </cfif>
					
					</cfoutput>
					
				</cfoutput>	
				
				</table>			
				</td>					
			</tr>
			
		</cfif>	
					
		</table>		  