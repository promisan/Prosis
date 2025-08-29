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
<cfparam name="URL.Mode" default="">

<cfinvoke component = "Service.Access"  
	method          = "useradmin" 
	role            = "'AdminUser'"
	returnvariable  = "access">	
	

<cfif url.scope eq "global">
						
	<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  R.*, S.Description as ModuleName, S.Hint,A.Description as ApplicationDescription
		FROM    Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S,
			    System.dbo.Ref_ApplicationModule AM,
			    System.dbo.Ref_Application A
		WHERE   R.SystemModule = S.SystemModule
		AND     S.Operational = '1'
		AND     S.SystemModule = AM.SystemModule
		AND     AM.Code = A.Code
		AND     A.Usage = 'System'
		<cfif access eq "EDIT" or access eq "ALL">
	    AND     R.OrgUnitLevel IN ('Global','Tree','Parent','All')
	    <cfelse>
	    AND     R.OrgUnitLevel IN ('Tree','Parent','All')
	    </cfif>
		<cfif SESSION.isAdministrator eq "No">
		AND     (R.RoleOwner IN (SELECT ClassParameter 
		                        FROM   OrganizationAuthorization
								WHERE  Role = 'AdminUser'
								AND    UserAccount = '#SESSION.acc#')
				OR R.RoleOwner is NULL)				
		</cfif>						
		AND     R.SystemModule != 'System'					
		ORDER BY A.ListingOrder,A.Description,S.MenuOrder, R.SystemModule, R.SystemFunction, R.Description
	</cfquery>
	
	<cf_divscroll>
	
	<table width="97%" align="center">
	
	<tr><td height="100%">
	
	
	<cfinclude template="OrganizationRolesDetail.cfm">
	
	
	</td></tr>
	
	</table>
	
	</cf_divscroll>
	
<cfelseif url.scope eq "system">	

	<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  R.*, S.Description as ModuleName, S.Hint, A.Description as ApplicationDescription
		FROM    Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S,
			    System.dbo.Ref_ApplicationModule AM,
			    System.dbo.Ref_Application A
		WHERE   R.SystemModule = S.SystemModule
		AND     S.Operational = '1'
		AND     S.SystemModule = AM.SystemModule
		AND     AM.Code = A.Code
		AND     A.Usage = 'System'
		AND     R.OrgUnitLevel IN ('Global','Tree','Parent','All')
		<cfif SESSION.isAdministrator eq "No">
		AND     R.RoleOwner IN (SELECT ClassParameter 
		                        FROM OrganizationAuthorization
								WHERE Role = 'AdminUser'
								AND  UserAccount = '#SESSION.acc#')
		</cfif>						
		AND     R.SystemModule = 'System'		
		ORDER BY A.ListingOrder,A.Description,R.Area, R.SystemModule, R.SystemFunction, R.Description
	</cfquery>
	
	<cf_divscroll>
	
	<table width="97%" align="center">
	
	<tr><td height="100%">
	
	<cfinclude template="OrganizationRolesDetail.cfm">
	
	</td></tr>
	
	</table>
	
	</cf_divscroll>
	
<cfelse>

	<cf_divscroll>
	
	<table width="97%" align="center">
	
	<tr><td height="1"></td></tr>
		
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  M.*, O.Description
	FROM    Ref_Mission M INNER JOIN Ref_AuthorizationRoleOwner O ON M.MissionOwner = O.Code
	<!--- only mission for modules/roles for which the mission is enabled --->
	WHERE  Mission IN (SELECT Mission 
	                   FROM Ref_MissionModule 
					   WHERE SystemModule IN (SELECT SystemModule FROM Ref_AuthorizationRole)) 
	<cfif SESSION.isAdministrator eq "No">				   
	<!--- only mission for which the user is authorised as tree maanger --->					                           
	AND     Mission IN (SELECT Mission 
	                    FROM   OrganizationAuthorization
						WHERE  Role = 'OrgUnitManager'
						AND    AccessLevel IN ('2','3')
						AND    UserAccount = '#SESSION.acc#')
	</cfif>
	AND    M.Operational = 1
	ORDER BY MissionOwner					
	</cfquery>
		
	<cfparam name="URL.Mission" default="#Mission.Mission#">
	<tr><td align="center" height="30" class="labelmedium">
	
	<cfif Mission.recordcount eq "0">	
	
		<font size="2" color="FF0000">
		<cf_tl id="You have no rights to assign access to any tree">
		</font>
	
	<cfelse>
		
		<table width="98%" border="0" class="formspacing" align="center">	
		
		<cfif url.mode eq "Direct">
		
		<cfelse>
		
			<tr><td height="5"></td></tr>	
			<tr>
			
			  <cfform>
				  <td width="20%" height="24">
				  <table>
				  <tr>
					  <td><img src="<cfoutput>#client.virtualdir#</cfoutput>/Images/Tree3.gif" align="absmiddle" alt="" border="0"></td>
					  <td style="padding-left:4px" class="labelit"><cf_tl id="Select Tree">:</td>
					  <td style="padding-left:4px">
					  
					  <cfselect name="mission"
					     class    = "regularxl"
				         group    = "Description"
						 onchange = "reloadform(this.value)"
				         query    = "Mission"
					     selected = "#url.mission#"
				         value    = "Mission"
				         display  = "Mission"/>		 
					
					  </td>
				  </tr>
				  </table>
			  </cfform>
			  
			</tr>			
			<tr><td height="5"></td></tr>
		
		</cfif>
		
		<tr><td height="2" height="20" class="labelit"><font color="gray">
		&nbsp;&nbsp;<cf_tl id="Grant access to the following enabled roles for this tree">:</font>
		</td></tr>		
		<tr><td id="treedet">
			<cfinclude template="OrganizationRolesDetail.cfm">
		</td></tr>
		</table>
		
	</cfif>	
		
	</td></tr>
			
	</table>	
	
	</cf_divscroll>

</cfif>
