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
<table width="98%" align="center" class="navigation_table">

<tr><td height="4"></td></tr>

<cfparam name="url.scope" default="tree">

<cfif url.scope eq "tree">

	<!--- show only roles 
	
	1. relevant for this mission based on the enabled modules	
	2. user is authorised for the ownership as carried by the mission	
	--->
		
	<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	SELECT  R.*, S.Description as ModuleName, S.Hint, A.Description as ApplicationDescription
	FROM    Ref_AuthorizationRole R, 
	        System.dbo.Ref_SystemModule S,
			System.dbo.Ref_ApplicationModule AM,
			System.dbo.Ref_Application A
	WHERE   R.SystemModule = S.SystemModule
	AND     S.Operational = '1'
	AND     R.GrantAllTrees = '0'
	AND     S.SystemModule = AM.SystemModule
	AND     AM.Code = A.Code
	AND     A.Usage = 'System'
	AND     R.OrgUnitLevel NOT IN ('Global','Fly')
	AND     R.SystemModule != 'System'			
	AND     R.SystemModule IN (SELECT SystemModule 
	                           FROM Ref_MissionModule 
							   WHERE Mission = '#URL.Mission#')		
							   
	<cfif SESSION.isAdministrator eq "No">						   
	AND     (R.RoleOwner is NULL 
	              OR	R.RoleOwner IN 	(SELECT ClassParameter 
					                    FROM    OrganizationAuthorization
										WHERE   Role = 'OrgUnitManager'
										AND     UserAccount = '#SESSION.acc#'
										AND     Mission = '#URL.Mission#')
			)						  
	</cfif>			  			   	
	ORDER BY A.ListingOrder,A.Description, S.MenuOrder, R.SystemModule, R.ListingOrder 
	
	
	</cfquery>

</cfif>

<cfset sys = "">

<cfoutput query="Role" group="ApplicationDescription">

	<tr><td colspan="8" style="padding-top:10px;height:46px;font-size:26px;font-weight:250" class="labelmedium">#ApplicationDescription#</td></tr>

	<cfoutput group="SystemModule">
		
		<cfif url.scope neq "System">
				
			<tr class="line">
			
				<td style="min-width:30px;width:30px;padding-left:10px" align="center">		
						
				  <cfif SystemModule neq sys>	
				  
				  <!--- onMouseOver="document.#SystemModule#Exp.src='#CLIENT.VirtualDir#/Images/Logo/System/ListCollapsed.png'" 
					    onMouseOut="document.#SystemModule#Exp.src='#CLIENT.VirtualDir#/Images/Logo/System/ListCollapsed.png'" --->
				 
				  	<img src="#client.virtualdir#/Images/Logos/System/ListCollapsed.png" alt="Expand" 					    
						name="#SystemModule#Exp" id="#SystemModule#Exp" class="regular" 
						align="absmiddle" style="cursor: pointer;height:21px" onClick="show('#SystemModule#')">
					
					<!---	
					onMouseOver="document.#SystemModule#Min.src='#CLIENT.VirtualDir#/Images/collapse-over.gif'" 
						onMouseOut="document.#SystemModule#Min.src='#CLIENT.VirtualDir#/Images/collapse5.gif'"
						--->
						
					<img src="#client.virtualdir#/Images/Logos/System/ListExpanded.png" 						
						name="#SystemModule#Min" id="#SystemModule#Min" alt="Collapse"  
						align="absmiddle" class="hide" style="cursor: pointer;height:21px"	onClick="show('#SystemModule#')">  			
							
				  </cfif>			  
				  	   
				</td>
				
				<td style="min-width:100%;height:30px;padding-left:7px" colspan="7">
				 <table border="0" width="100%">
				  <tr class="labelmedium2">
				  <td style="font-size:18px"><a href="javascript:show('#SystemModule#')">#ModuleName#</a></td>
				  <td valign="bottom" align="right" class="labelit">#hint#</td>
				  </tr>
				  </table>
				</td>
				
			</tr>
						
		</cfif>
	
		<cfset row = 0>
	
		<cfoutput>
		
			<cfset row = row + 1>
			
			<cfif url.scope eq "System">
				<tr id="g#SystemModule#" name="g#SystemModule#" class="regular labelmedium2 navigation_row line fixlengthlist">
			<cfelse>
				<tr id="g#SystemModule#" name="g#SystemModule#" class="hide labelmedium2 navigation_row line fixlengthlist">
			</cfif>
			 
			  <td height="18"></td>
			  <td align="center">#row#.</td>
			  <td style="padding-top:3px" align="center">
			  	<cf_img icon="select" navigation="yes" onclick="javascript:show#scope#role('#Role#')">
			  </td>
			  <td style="cursor:pointer" title="#rolememo#">#Description# (#Role#)</td>
			  <td>
				  <table>
				  <tr><td height="18" width="30">
				  
					  <cfif RoleMemo neq "">
					  
					    <img width="13" height="13" src="#client.VirtualDir#/Images/Info.png" 
						  alt="" 
						  align="absmiddle" 
						  border="0" 
						  style="cursor: pointer;" 
						  onClick="javascript:showtext('#scope#_t#currentrow#')">
						  
					  </cfif>
				  </td>
				  <td class="labelit"><cfif OrgUnitLevel eq "All">Unit <cfelse>#OrgUnitLevel# </cfif>
				      <cfif Parameter neq "">/ #Parameter#</cfif>
					  <cfif ParameterGroup neq "">/ #ParameterGroup#</cfif>		  
				  </td> 	  
				  </tr>
				  </table>  
			  </td>
			  <td><cfif Parameter eq "Entity"><font color="2CBAD8">WF</cfif></td>
			  <td>#RoleOwner#</td>
			  <td>#AccessLevelLabelList#</td>
			</tr>
			
			<cfif RoleMemo neq "">
			
				<tr class="hide" id="#scope#_t#currentrow#">
					<td colspan="1"></td>
					<td colspan="7" align="left">
						<table width="100%" id="g#SystemModule#" name="g#SystemModule#">
						<tr>
					    <td width="30" align="center"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
					    <td>
						<table bgcolor="FFFFCF" class="formpadding">
							<tr><td class="labelit">#RoleMemo#</td></tr>
						</table>
						</td>
						</tr>
						</table>
					</td>
				</tr>
			
			</cfif>
		
			<cfset sys = SystemModule>
		
		</cfoutput>
	
	</cfoutput>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
