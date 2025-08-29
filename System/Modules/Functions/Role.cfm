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
<cfsilent>
 <proUsr>administrator</proUsr>
�<proOwn>Dev van Pelt</proOwn>
 <proDes>Function Menu Role Access</proDes>
 <!--- specific comments for the current change, may be overwritten --->
�<proCom>Added provision for role level verification</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.ID1" default="">

<cfquery name="Roles" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT A.*, A.Description+' ['+A.Role+']'  as Label, M.MenuOrder, M.SystemModule
    FROM  Ref_AuthorizationRole A, System.dbo.Ref_SystemModule M
	WHERE A.SystemModule = M.SystemModule
	AND  M.Operational = '1'
	AND A.Role NOT IN (SELECT Role 
	                     FROM System.dbo.Ref_ModuleControlRole 
						 WHERE SystemFunctionId = '#URL.ID#')
	<cfif SESSION.isAdministrator eq "No">  					 
	AND A.RoleOwner IN (SELECT ClassParameter
						FROM   OrganizationAuthorization A
						WHERE  A.UserAccount = '#SESSION.acc#'
						  AND  A.Role = 'AdminSystem')			 
	</cfif>					  
	ORDER BY M.MenuOrder, M.SystemModule
</cfquery>

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_ModuleControlRole R
	WHERE  R.Operational = 1
	AND    SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, A.Description, A.AccessLevels, A.AccessLevelLabelList
    FROM   Ref_ModuleControlRole R, 
	       Organization.dbo.Ref_AuthorizationRole A 
	WHERE  R.Role = A.Role
	AND    SystemFunctionId = '#URL.ID#'
</cfquery>

<cfform action="#SESSION.root#/System/Modules/Functions/RoleSubmit.cfm?ID=#URL.ID#&ID1=#URL.ID1#" method="POST" name="role">
	
<table width="100%" height="100%" align="center" class="navigation_table">
		    
	  <tr>
	    <td valign="center" width="100%" class="regular" style="padding-top:4px">
	    <table width="100%">
			
		<cfoutput>
		<cfloop query="Detail">
		
			<cfset l = accessLevels>
					
			<cfquery name="Level" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ModuleControlRoleLevel
				WHERE  SystemFunctionId = '#URL.ID#'
				AND    Role             = '#Role#'				
			</cfquery>		
			
		     <!--- check if any access to the level was granted --->
			 
			 <cfif level.recordcount eq "0">
			 
				 <cfloop index="lvl" from="0" to="#accessLevels-1#">
				 
					 <cfquery name="Add" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO Ref_ModuleControlRoleLevel
						(SystemFunctionId, Role,AccessLevel)
						VALUES
						('#URL.ID#','#Role#','#lvl#')				
					</cfquery>	
				 
				 </cfloop>
			 
			 </cfif>
			 
			 <cfquery name="Level" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ModuleControlRoleLevel
				WHERE  SystemFunctionId = '#URL.ID#'
				AND    Role             = '#Role#'				
			</cfquery>					  										
			
			<cfset accessLevelList = "">
			
			<cfloop query="Level">
			 <cfif accessLevelList eq "">
			    <cfset accessLevelList = "#AccessLevel#">
			 <cfelse>
			    <cfset accessLevelList = "#accessLevelList#-#AccessLevel#">
			 </cfif>
			</cfloop>		
		
			<cfset rl = "#Description# [#Role#]">
			<cfset op = Operational>
			<cfset label = ListToArray(AccessLevelLabelList)>
													
			<cfif URL.ID1 eq Role>
										
				<TR class="labelmedium line2 fixlengthlist" style="height:30px" bgcolor="ffffcf">				   		       					   						 						  
				   <td style="font-size:17px;padding-left:4px">#Role#<input type="hidden" name="Role" id="Role" value="#Role#"></td>
				   <td>
				   
				    <table>
					  <tr>
					  
					     <cfif accesslevels eq "2">
						 
						 	<cfloop index="lvl" from="1" to="#accessLevels#">
							  
							    <cftry>
								<td class="labelmedium" style="padding-left:4px">#label[lvl]#:<cfcatch>l:#lvl#</cfcatch></td>							
								</cftry>
					    		<td style="padding-left:4px;padding-right:6px"><input class="radiol" type="checkbox" name="AccessLevelList" id="AccessLevelList" <cfif Find(lvl, accessLevelList)>checked</cfif> value="#lvl#"></td>				       
								
						   </cfloop>	
						 
						 <cfelse>
					 				 					  			   
						    <cfloop index="lvl" from="0" to="#accessLevels-1#">
							  
							    <cftry>
								<td class="labelmedium" style="padding-left:4px">#label[lvl+1]#:<cfcatch>l:#lvl#</cfcatch></td>							
								</cftry>
					    		<td style="padding-left:4px;padding-right:6px"><input class="radiol" type="checkbox" name="AccessLevelList" id="AccessLevelList" <cfif Find(lvl, accessLevelList)>checked</cfif> value="#lvl#"></td>				       
								
						   </cfloop>	
						   
						</cfif>   
					   
					  </tr>
					  </table>	 				   
				  		  				   
				   </td>					   				   
				   <td align="center" width="5%">
				   
				   <cf_securediv id="divRoleMission_#URL.ID#_#Role#" bind="url:#SESSION.root#/System/Modules/Functions/Role_Mission.cfm?ID=#URL.ID#&role=#role#"></td>
				   <td align="left" width="50" style="padding-right:4px" title="Enable or Disabled">
				   
				   	   <input class="radiol" type="checkbox" name="Operational" id="Operational" value="1" <cfif "1" eq Detail.Operational>checked</cfif>>					   
					
					</td>
				   <td align="right" style="padding-right:4px"><input type="submit" style="width:50;height:25" value="Save" class="button10g"></td>	
			    </TR>				
						
			<cfelse>
						
				<TR class="labelmedium2 line navigation_row fixlengthlist" style="height:30px">
								
				   <td style="font-size:17px;padding-left:4px;<cfif op eq '0'>background-color:##ff808080<cfelse>background-color:##80ff8050</cfif>;padding-left: 4px">#rl#</td>
				   <td style="padding-left:8px">				   
				   
					  <table>
					  <tr class="fixlengthlist">		
					  
					  	 <cfif accesslevels eq "2">
						 
						 	 <cfloop index="lvl" from="1" to="#l#">
							   <cfif Find(lvl, accessLevelList)>
							    <cftry><td class="labelmedium">#label[lvl]#;<cfcatch>l;#lvl#</cfcatch></td></cftry>
					    		<td></td>				       
								</cfif>
						    </cfloop>	
						 
						 <cfelse>			    
					   
						    <cfloop index="lvl" from="0" to="#l-1#">
							   <cfif Find(lvl, accessLevelList)>
							    <cftry><td class="labelmedium">#label[lvl+1]#;<cfcatch>l;#lvl#</cfcatch></td></cftry>
					    		<td></td>				       
								</cfif>
						    </cfloop>	
							
						</cfif>	
					   
					  </tr>
					  </table>	   
				   
				   </td>		
				   
				   <td title="operational"><cfif op eq "0">No</cfif></td>													
				  				   
				   <td colspan="3" align="right" style="min-width:80px">		
					   <table align="right">
					    <tr class="labelmedium2 fixlengthlist">
						   	<td style="padding-left:3px;padding-right:8px"><cf_securediv id="divRoleMission_#URL.ID#_#Role#" bind="url:#SESSION.root#/System/Modules/Functions/Role_Mission.cfm?ID=#URL.ID#&role=#role#"></td>
							<td align="right">#OfficerUserId#&nbsp;(#dateformat(created,CLIENT.DateFormatShow)#)</td>				 
						   	<td style="padding-left:7px;padding-right:3px">
								<table cellspacing="0" cellpadding="0">
									<tr>
										<td>
										<cf_img icon="open" onclick="ptoken.navigate('#SESSION.root#/System/Modules/Functions/Role.cfm?ID=#URL.ID#&ID1=#role#','irole')">
										</td>
										<td style="padding-left:5px;">
										<cf_img icon="delete" onclick="ptoken.navigate('#SESSION.root#/System/Modules/Functions/RolePurge.cfm?ID=#URL.ID#&ID1=#role#','irole')">
										</td>
									</tr>
								</table>
							</td>
							
						</tr>
					   </table>
				  </td>		
					   
			    </TR>	
			
			</cfif>
		
				
		</cfloop>
		</cfoutput>
						
		<cfif URL.ID1 eq "">
								
		   <TR style="height:35px">				 	   
			
		   <td width="24%">
		   
		   <table><tr><td title="Enable or Disabled">			   
			       <input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			      </td>		   
		   <td>
			
		   <cfselect name="Role"
	          group="SystemModule"
	          queryposition="below"
	          query="Roles"
	          value="Role"
	          display="Label"
	          visible="Yes"
			  class="regularxxl"
	          enabled="Yes"
	          onchange="ptoken.navigate('#SESSION.root#/System/Modules/Functions/RoleAdd.cfm?role='+this.value,'roleadd')"
	          style="width:320px">
		  
		      <option  value="">--- select ---</option>
          
	   	   </cfselect>
		   
		   </td></tr></table>
		   </td>
		   
		   <td  width="50%" id="roleadd"></td>
			 		  
			<td colspan="3" align="right">
			
			    <input type="submit" name="add" id="add" value="Add" class="hide" style="width:90;height:25px">
				
			</td>
			    
			</TR>	
								
		</cfif>	
		
		</table>
		
		</td>
		</tr>		
				
		<cfif check.recordcount eq "0">
		<tr><td height="2" colspan="5" class="labelmedium"><b><font color="FF0000">Attention:</font></b> No active roles defined. This function is not restricted by roles</td></tr>		
		</cfif>
					
	</table>	
	
</cfform>

<cfset ajaxonload("doHighlight")>