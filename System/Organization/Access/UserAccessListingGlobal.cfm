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
<table width="100%" border="0" align="center" bordercolor="silver">
<tr><td height="5"></td></tr>
	
	<cfquery name="Global" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   A.*, R.Description, R.SystemModule, M.Description as ModuleName, R.Role
		FROM     OrganizationAuthorization A, 
		         Ref_AuthorizationRole R,
				 System.dbo.Ref_SystemModule M
		WHERE    A.Role = R.Role
		  AND    R.SystemModule = M.SystemModule 
		  AND    AccessLevel < '8'
		  <cfif URL.Search neq "">
		  AND      (R.Role LIKE '%#URL.Search#%' or R.Description LIKE '%#URL.Search#%')
		  </cfif>
		  AND    UserAccount = '#URL.ID#' 
		  AND    R.OrgUnitLevel = 'Global'
		  <cfif SESSION.isAdministrator eq "No">
			  AND   ( R.RoleOwner IN (SELECT DISTINCT ClassParameter 
		    	                     FROM   OrganizationAuthorization A
									 WHERE  UserAccount = '#SESSION.acc#'
									 AND    Role = 'AdminUser') 
					OR R.RoleOwner is NULL )				 
		  </cfif>						
		ORDER BY R.SystemModule, A.Role, A.AccessLevel
	</cfquery>
		
	<tr>	
   	<td colspan="4">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<cfset module = "0">
	
	<cfif Global.recordcount eq "0">
	 
	 <tr><td height="10"></td></tr>
	
	 <tr><td height="43" class="labelmedium" align="center"><font color="808080">No authorization records to show in this view.</td></tr>
	 <tr><td class="linedotted"></td></tr>
	
	</cfif>
	
	<cfset cnt = 0>
	
	<cfoutput query="Global" group="SystemModule">
	
		<cfinvoke component="Service.Access"  
	   method         = "useradmin" 
	   accesslevel    = "'1','2'"
	   treeaccess     = "Yes"	
	   systemmodule   = "#SystemModule#"
	   returnvariable ="accessUserAdmin">
	   
	   	<tr><td height="4"></td></tr>
	
		<tr class="line">
		<td width="25" height="17">
	
		<cfset cnt = cnt+1>
		
		<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">	
		
		<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="Detailed access" 
			id="global#cnt#Exp" border="0" class="regular" 
			align="middle" style="cursor: pointer;" 
			onClick="more('#cnt#','global','','all','#SystemModule#','')">
			
		<img src="#SESSION.root#/Images/ct_expanded.gif" 
			id="global#cnt#Min" alt="" border="0" 
			align="middle" class="hide" style="cursor: pointer;" 
			onClick="more('#cnt#','global','','all','#SystemModule#','')">
			
		</cfif>	
		
		</td>
		<td width="95%" colspan="3" class="labellarge">
	   
		   <cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">	
		      <a href="javascript: more('#cnt#','global','','all','#SystemModule#','')">
		   		#ModuleName#
			  </a>   
		   <cfelse>
			   #ModuleName#
		   </cfif>
		  
		</td>
		</tr>
		
		<cfoutput group="Role">
		
			<tr class="line labelmedium"><td></td>
			<td width="30%" style="padding-left:5px">#Description#</td>
			<td width="100">#Role#</td>
			<td align="right" style="padding-right:14px">
			   <cfif AccessLevel eq "0">Read
			   <cfelseif AccessLevel eq "1">Edit
			   <cfelse>All
			   </cfif>
			</td>
			</tr>
		
		</cfoutput>
	
	<tr><td></td><td colspan="4" style="padding-left:5px">
		<cfdiv id="iglobal#cnt#">
	</td></tr>
		
	</cfoutput>
		
	</table>
	
</tr>

<tr><td height="5"></td></tr>

</table>	
