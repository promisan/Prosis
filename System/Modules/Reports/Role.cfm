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

<cfparam name="URL.ID1" default="">
<cfparam name="URL.Status" default="0">

<cfinvoke component="Service.AccessReport"  
    method="editreport"  
	ControlId="#URL.ID#" 
	returnvariable="accessedit">

<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  DISTINCT A.*, M.MenuOrder
    FROM    Ref_AuthorizationRole A, 
	        System.dbo.Ref_SystemModule M
	WHERE   A.SystemModule = M.SystemModule
	AND     M.Operational = '1'
    AND     A.Role NOT IN (SELECT Role 
	                       FROM   System.dbo.Ref_ReportControlRole 
						   WHERE  ControlId = '#URL.ID#') 
						 
	<cfif SESSION.isAdministrator eq "No" and accessEdit neq "EDIT">  	
					 
	AND A.RoleOwner IN (SELECT ClassParameter
						FROM   OrganizationAuthorization A
						WHERE  A.UserAccount = '#SESSION.acc#'
						AND    A.Role = 'AdminSystem')			 
	</cfif>					
	  
	ORDER BY MenuOrder, A.SystemModule
</cfquery>

<cfquery name="OwnerList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRoleOwner	
</cfquery>

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM   Ref_ReportControlRole R,  
	       Organization.dbo.Ref_AuthorizationRole A
	WHERE  R.Operational = 1  
	AND    R.Role = A.Role
	AND    ControlId = '#URL.ID#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, A.Description, A.OrgUnitLevel
    FROM Ref_ReportControlRole R, 
	     Organization.dbo.Ref_AuthorizationRole A 
	WHERE R.Role = A.Role
	AND  ControlId = '#URL.ID#'
</cfquery>

<table width="100%" lign="center" class="formpadding">
    <tr><td>
	
	<table width="100%" align="center" class="navigation_table">
	    
	  <tr>
	    <td width="100%">
		
	    <table width="100%">
			
	    <TR class="line labelmedium2 fixlengthlist">
		   <td style="padding-left:3px;font-size:19px">Grant access to the following ROLES</td>
		   <td style="cursor:pointer;"><cf_UIToolTip tooltip="Limit access to users with the owner assigned for the selected<br>Note:</b>Mostly for system roles">Owner</cf_UIToolTip></td>
		   <td style="cursor:pointer;"><cf_UIToolTip tooltip="Limit access to users with the mission assigned for the selected role"><cf_tl id="Entity"></cf_UIToolTip></td>
		   <td style="cursor:pointer;"><cf_UIToolTip tooltip="Delegate the option to grant security access for this report to users assigned to this role"><cf_tl id="Delegation"></cf_UIToolTip></td>
		   <td style="color:909090;">Active</td>
		   <td align="center" colspan="2">
		   		<cfoutput>
		   		<a title="Add Role" href="javascript:editrole('#url.status#','#url.id#','');">					
					[<cf_tl id="Add role">]					
				</a>
				</cfoutput>
		   </td>
	    </TR>	
				
		<cfoutput>
		<cfloop query="Detail">
		
		<cfset rl = Role>
		<cfset op = operational>
													
		<cfif URL.ID1 eq Role>
									
			<TR class="navigation_row line labelmedium fixlengthlist">
						    					   						 						  
			   <td height="20" style="padding-left:3px!important"">#Role# - #Description#</td>
			   <td width="80">
			   <cfif ClassParameter eq "Owner">
				   <select style="width:80" name="classparameter" id="classparameter">
				   <option>All</option>
		           <cfloop query="OwnerList">		    
				     <option value="#Code#" <cfif Owner eq ClassParameter>selected</cfif>>#Code#</option>
				   </cfloop>	 
				   </select>	
			   <cfelse>
			    <input type="hidden" name="classparameter" id="classparameter">	
				N/A   
			   </cfif>		  
			   </td>	
			   <td>
			   <cfif OrgUnitLevel neq "Global">
			   
				   <select name="missionsel" id="missionsel" multiple style="width:120">
				   
				   		<cfquery name="Check" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT Mission
								    FROM  System.dbo.Ref_ReportControlRoleMission
									WHERE ControlId = '#url.id#'
									AND   Role = '#Role#'													
						</cfquery>				   		
				    
						<cfquery name="MissionList" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT R.*,
									(SELECT Mission
								    FROM  System.dbo.Ref_ReportControlRoleMission
									WHERE ControlId = '#url.id#'
									AND   Role = '#Role#'
									AND   Mission = R.Mission) as Selected
						    FROM  Ref_Mission R 	
							WHERE R.Operational = 1	
							
						</cfquery>
						
					   <option <cfif missionlist.recordcount eq "0">selected</cfif>>Any</option>	
					   
			           <cfloop query="MissionList">		
					   	     <option value="#Mission#" <cfif selected neq "">selected</cfif>>#Mission#</option>
					   </cfloop>	
					    
				   </select>	
				   
			   <cfelse>
			   
			   	 <input type="hidden" name="missionsel" id="missionsel">N/A   
				 
			   </cfif>		  
			   </td>	
			   <td><input type="checkbox" class="radiol" name="roledelegation" id="roledelegation" value="1" <cfif "1" eq Detail.Delegation>checked</cfif>></td>
			   <td><input type="checkbox" class="radiol" name="roleoperational" id="roleoperational" value="1" <cfif "1" eq Detail.Operational>checked</cfif>></td>
			  
			   <td colspan="2" align="right" height="30" style="padding-right:4px">
			   
			   		<input type="button" 
					       class="button10g" 
						   onclick="rolesubmit('#url.id1#')" 
						   value="Save" 
						   style="width:50" 
						   name="btn_role"
						   id="btn_role">
			   </td>

		    </TR>	
					
		<cfelse>
		
			<TR class="navigation_row line labelmedium">
			
			   <td style="padding-left:3px!important">#rl# - #Description#</td>
			   <td>#ClassParameter#</td>
			   <td>
			   
			   		<cfquery name="MissionList" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT Mission
					    FROM  System.dbo.Ref_ReportControlRoleMission
						WHERE ControlId = '#url.id#'
						AND   Role      = '#Role#'
					</cfquery>
					
					<table cellspacing="0" cellpadding="0">
						<cfloop query="MissionList">
						<tr class="labelmedium"><td>#Mission#</td></tr>
						</cfloop>
					</table>				   
			   </td>
			   
			   <td><cfif detail.delegation eq "0"><font color="red">No<cfelse>Yes</cfif></td>
			   <td><cfif op eq "0"><font color="red">No<cfelse>Yes</cfif></td>
			  
			     <cfif URL.status eq "0">
			     <td align="right">						 				      		   
					 <cf_img icon="edit" onclick="editrole('#url.status#','#url.id#','#role#');">
				 </td>
				 <td style="padding-left:4px;padding-top:2px;padding-right:1px">				   		   
			        <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('RolePurge.cfm?status=#url.status#&ID=#URL.ID#&ID1=#Role#','rolebox')">					
				 </td>			   
				  
			  </cfif>
			   
		    </TR>	
		
		</cfif>
		
		</cfloop>
		</cfoutput>
								
		<cfif URL.ID1 eq "" and URL.status eq "0">											
									
			<TR bgcolor="ffffcf" class="hide">
			
			<td height="30">&nbsp;
			   <select style="width:60%" name="role" id="role" onChange="show(this.value,'btn_role')">
			   <option>---Select---</option>
	           <cfoutput query="Role" group="MenuOrder">
			      <cfoutput group="SystemModule">
			     <option value="">#SystemModule#</option>
				 <cfoutput>
			     <option value="#Role#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- #Description#</option>
				 </cfoutput>
			   </cfoutput>	 
			   </cfoutput>
		   	   </select>
			</td>
			
			<td width="80">
			   <cfdiv bind="url:RoleOwner.cfm?role={role}">
			</td>
			
			<td>
			   <cfdiv bind="url:RoleMission.cfm?role={role}">
			</td>
			
			<td width="40">
				<input type="checkbox" class="radiol" name="roledelegation" id="roledelegation" value="1">
			</td>			
				   
			<td width="40">
				<input type="checkbox" class="radiol" name="roleoperational" id="roleoperational" value="1" checked>
			</td>
											   
			<td colspan="2" align="center">
			
				<input name="btn_role" id="btn_role" 
						style="width:50" 
						type="button" 
						class="hide" 
						onclick="rolesubmit('')" 
						value="Add" 
						class="hide">
						
			</td>
			    
			</TR>	
													
		</cfif>	
		
		</table>
		
		</td>
		</tr>
		
		<tr class="hide"><td height="1" colspan="6"></td></tr>	
		
		<cfif check.recordcount eq "0">
		<tr><td height="6" colspan="6"></td></tr> 
		
		<tr><td colspan="6" align="center" height="50" bgcolor="ffffff" class="labelmedium"><b><font color="FF0000">Attention:</font></b> No active roles defined.</td></tr>
				
		</cfif>
					
	</table>	
		
	</td></tr>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
	
