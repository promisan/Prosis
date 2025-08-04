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

<cfparam name="URL.Search" default="">
<cfparam name="URL.role"   default="">

<!--- all units and mandates --->

<cfquery name="Tree" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

SELECT   A.Mission,         
		 O.MandateNo, 		
		 O.OrgUnitCode, 
		 O.OrgUnitName, 
		 O.HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description as ModuleName,
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction, 
		 Max(AccessLevel) as AccessLevel
FROM     OrganizationAuthorization A, 
         Ref_AuthorizationRole R,
		 System.dbo.Ref_SystemModule M,
		 Organization O
WHERE    A.Role = R.Role
  <cfif url.role neq "">
  AND   A.Role = '#url.role#'
  </cfif>
  AND    R.OrgUnitLevel IN ('Warehouse','Parent','All')
  AND    M.SystemModule = R.SystemModule
  AND    A.OrgUnit       = O.OrgUnit 
  AND    A.OrgUnitInherit = 0
  
  <cfif URL.Search neq "">
  AND    (R.Role LIKE '%#URL.Search#%'
       or R.Description LIKE '%#URL.Search#%'
	   or A.Mission LIKE '%#URL.Search#%'
	     )
  </cfif>
  AND    AccessLevel < '8'
  AND    A.UserAccount = '#URL.ID#' 
  AND    A.Mission is not NULL
  
  <cfif SESSION.isAdministrator eq "No">
  AND     ( R.RoleOwner IN (SELECT DISTINCT ClassParameter 
		                     FROM   OrganizationAuthorization A
							 WHERE  UserAccount = '#SESSION.acc#'
							 AND    Role = 'AdminUser') 
		OR R.RoleOwner is NULL
		OR A.Mission IN (SELECT DISTINCT Mission 
   	                     FROM OrganizationAuthorization A
						 WHERE UserAccount = '#SESSION.acc#'
						 AND Role = 'OrgUnitManager')		
		)	
   				 
  </cfif>	
  GROUP BY A.Mission,         
		 O.MandateNo, 		
		 O.OrgUnitCode, 
		 O.OrgUnitName, 
		 O.HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.ListingOrder,
		 R.SystemModule, 
		 M.Description, 
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction   
		 
  UNION 
  
  SELECT A.Mission,         
		 O.MandateNo, 		
		 O.OrgUnitCode, 
		 O.OrgUnitName, 
		 O.HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description as ModuleName,
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction, 
		 Max(AccessLevel) as AccessLevel
FROM     OrganizationAuthorizationDeny A, 
         Ref_AuthorizationRole R,
		 System.dbo.Ref_SystemModule M,
		 Organization O
WHERE    A.Role = R.Role
 <cfif url.role neq "">
  AND   A.Role = '#url.role#'
  </cfif>
  AND    R.OrgUnitLevel IN ('Warehouse','Parent','All')
  AND    M.SystemModule = R.SystemModule
  AND    A.OrgUnit       = O.OrgUnit 
  AND    A.OrgUnitInherit = 0
  <cfif URL.Search neq "">
  AND    (R.Role LIKE '%#URL.Search#%'
       or R.Description LIKE '%#URL.Search#%'
	   or A.Mission LIKE '%#URL.Search#%'
	     )
  </cfif>
  AND    AccessLevel < '8'
  AND    A.UserAccount = '#URL.ID#' 
  AND    A.Mission is not NULL
  
  <cfif SESSION.isAdministrator eq "No">
  AND     ( R.RoleOwner IN (SELECT DISTINCT ClassParameter 
		                     FROM   OrganizationAuthorization A
							 WHERE  UserAccount = '#SESSION.acc#'
							 AND    Role = 'AdminUser') 
		OR R.RoleOwner is NULL
		OR A.Mission IN (SELECT DISTINCT Mission 
   	                     FROM OrganizationAuthorization A
						 WHERE UserAccount = '#SESSION.acc#'
						 AND Role = 'OrgUnitManager')		
		)	
   				 
  </cfif>	
  GROUP BY A.Mission,         
		 O.MandateNo, 		
		 O.OrgUnitCode, 
		 O.OrgUnitName, 
		 O.HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule,
		 R.ListingOrder, 
		 M.Description, 
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction   		 
		 
  UNION  
  
         SELECT   
		 A.Mission,         
		 'All' as MandateNo, 
		 '' as orgUnitCode,
		 'All' as OrgUnitName, 
		 'Mission' as HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description as ModuleName,
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction, 
		 Max(AccessLevel) as AccessLevel
  FROM   OrganizationAuthorization A, 
         Ref_AuthorizationRole R,
		 System.dbo.Ref_SystemModule M
  WHERE    A.Role = R.Role
  <cfif url.role neq "">
  AND   A.Role = '#url.role#'
  </cfif>
  AND    R.OrgUnitLevel IN ('Warehouse','Parent','All')
  AND    M.SystemModule = R.SystemModule
  <cfif URL.Search neq "">
  AND      (R.Role LIKE '%#URL.Search#%' 
      or R.Description LIKE '%#URL.Search#%'
	   or A.Mission LIKE '%#URL.Search#%'
	  )
  </cfif>
  AND    AccessLevel < '8'
  AND    A.UserAccount = '#URL.ID#' 
  AND    (A.OrgUnit = '' or A.OrgUnit is NULL ) 
  AND    A.Mission is not NULL
  
  <cfif SESSION.isAdministrator eq "No">
  
  AND     ( R.RoleOwner IN (SELECT DISTINCT ClassParameter 
		                     FROM   OrganizationAuthorization A
							 WHERE  UserAccount = '#SESSION.acc#'
							 AND    Role = 'AdminUser') 
		OR R.RoleOwner is NULL
		OR A.Mission IN (SELECT DISTINCT Mission 
   	                     FROM OrganizationAuthorization A
						 WHERE UserAccount = '#SESSION.acc#'
						 AND Role = 'OrgUnitManager')		
		)						 
  </cfif>	
  GROUP BY A.Mission, 	
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description, 
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction 				 
 
UNION   SELECT   
		 A.Mission,         
		 'All' as MandateNo, 
		 '' as orgUnitCode,
		 'All' as OrgUnitName, 
		 'Mission' as HierarchyCode,
		 A.UserAccount, 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description as ModuleName,
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction, 
		 Max(AccessLevel) as AccessLevel
  FROM   OrganizationAuthorizationDeny A, 
         Ref_AuthorizationRole R,
		 System.dbo.Ref_SystemModule M
  WHERE  A.Role = R.Role
  AND    R.OrgUnitLevel IN ('Warehouse','Parent','All')
  AND    M.SystemModule = R.SystemModule
  <cfif URL.Search neq "">
  AND      (R.Role LIKE '%#URL.Search#%' 
      or R.Description LIKE '%#URL.Search#%'
	   or A.Mission LIKE '%#URL.Search#%'
	  )
  </cfif>
  AND    AccessLevel < '8'
  AND    A.UserAccount = '#URL.ID#' 
  AND    (A.OrgUnit = '' or A.OrgUnit is NULL ) 
  AND    A.Mission is not NULL
  
  <cfif SESSION.isAdministrator eq "No">
  
  AND     ( R.RoleOwner IN (SELECT DISTINCT ClassParameter 
		                     FROM   OrganizationAuthorization A
							 WHERE  UserAccount = '#SESSION.acc#'
							 AND    Role = 'AdminUser') 
		OR R.RoleOwner is NULL
		OR A.Mission IN (SELECT DISTINCT Mission 
   	                     FROM OrganizationAuthorization A
						 WHERE UserAccount = '#SESSION.acc#'
						 AND Role = 'OrgUnitManager')		
		)						 
  </cfif>	
  
  GROUP BY A.Mission, 	
		 A.UserAccount, 		 
		 A.Role, 
		 R.Description,
		 R.SystemModule, 
		 R.ListingOrder,
		 M.Description, 
		 A.ClassParameter, 
		 A.GroupParameter, 
		 A.ClassIsAction 				 
  
ORDER BY A.Mission, O.MandateNo, R.SystemModule, R.ListingOrder, A.Role, A.ClassParameter, O.OrgUnitCode

</cfquery>

<table width="99%" align="center" class="navigation_table">

<cfif Tree.recordcount eq "0">

 <tr><td height="4"></td></tr>
 <tr><td height="1" colspan="6" bgcolor="d4d4d4"></td></tr>
 <tr><td height="23" class="labelmedium" align="center"><font color="FF0000">No access to show in this view.</font></b></td></tr>
 <tr><td height="1" colspan="6" bgcolor="d4d4d4"></td></tr>

</cfif>

<cfset cnt = 0>
	
<cfoutput query="Tree" group="Mission">

<tr><td colspan="6" align="left" style="height:40px;padding-top:6px;padding-left:1px;font-size:25px" class="labelmedium">#Mission#</td></tr>

<cfoutput group="MandateNo">
<cfif MandateNo neq "All">

	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM Ref_Mandate 
		WHERE Mission = '#Mission#' 
		AND MandateNo = '#MandateNo#'
	</cfquery>

	<tr class="linedotted labelmedium" style="height:20px">
	<td></td>
	<td colspan="7" align="left" bgcolor="EAFAAB" style="padding-left:14px">Only for mandate: <b>#MandateNo#</b> (#dateFormat(Mandate.DateEffective,CLIENT.DateFormatShow)# - #dateFormat(Mandate.DateExpiration,CLIENT.DateFormatShow)#)</b></td>
	</tr>
</cfif>

	<cfoutput group="SystemModule">
		
		<cfinvoke component="Service.Access"  
		   method         = "useradmin" 
		   accesslevel    = "'1','2'"
		   mission        = "#Mission#"
		   treeaccess     = "Yes"		 
		   systemmodule   = "#SystemModule#"
		   returnvariable ="accessUserAdmin">
		
		<tr class="line fixlengthlist">
		<td width="25" height="17" style="padding-top:1px">
		
			<cfset cnt = cnt+1>
			
			<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">	
			
			<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="Detailed access" 
				id="tree#cnt#Exp" border="0" class="regular" height="20" 
				align="middle" style="cursor: pointer;" 
				onClick="more('#cnt#','tree','#Mission#','#MandateNo#','#SystemModule#','#url.search#')">
				
			<img src="#SESSION.root#/Images/ct_expanded.gif" 
				id="tree#cnt#Min" alt="" border="0" height="20" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="more('#cnt#','tree','#Mission#','#MandateNo#','#SystemModule#','#url.search#')">
				
			</cfif>	
			
		</td>
		<td width="95%" height="20" colspan="5" style="padding-left:5px;font-size:20px;height:36px" class="labelmedium">
		   
		   <cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">	
		      <a href="javascript: more('#cnt#','tree','#Mission#','#MandateNo#','#SystemModule#','#url.search#')">		  
		   		#ModuleName#			
			  </a>   
		   <cfelse>
			   #ModuleName#
		   </cfif>
		  
		</td>
		</tr>
			
		<cfoutput group="Role">
			  
			<cfoutput group="OrgUnitName">
				
				<tr class="line labelmedium2 fixlengthlist navigation_row">
				<td></td>
				<td style="padding-left:10px">#Description#</td>
				<td>#Role#</td>
				<cfif HierarchyCode neq "Mission">
				<td>#OrgUnitCode#</td>
				<td><cfif HierarchyCode neq "Mission">#OrgUnitName#</cfif></td>
				<cfelse>
				<td colspan="2"></td>
				</cfif>
				<td align="right">#accesslevel#
					<cfif AccessLevel eq "0">Read
				    <cfelseif AccessLevel eq "1">Edit
					<cfelse>All
					</cfif>&nbsp;
				</td>
				</tr>
				
			</cfoutput>
		</cfoutput>
	
	<tr><td></td><td colspan="5" style="padding-left:10px">
		<cfdiv id="itree#cnt#">
	</td></tr>
		
	</cfoutput>
</cfoutput>
</cfoutput>
</table>

<cfset ajaxonload("doHighlight")>