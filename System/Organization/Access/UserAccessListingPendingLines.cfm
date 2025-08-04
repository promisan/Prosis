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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfquery name="Pending" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 50 A.AccessId,
	         R.SystemModule, 
			 A.Mission, 
			 A.OrgUnit, 
			 Org.OrgUnitName, 
			 Org.MandateNo,
			 A.Role, 
			 R.Description, 
			 R.RoleOwner, 
			 A.ClassParameter, 
			 A.GroupParameter, 
			 A.ClassIsAction, 
	         A.AccessLevel, A.Source, A.OfficerLastName, A.OfficerFirstName, A.Created
	FROM     OrganizationAuthorization A INNER JOIN
	         Ref_AuthorizationRole R ON A.Role = R.Role LEFT OUTER JOIN
	         Organization Org ON A.OrgUnit = Org.OrgUnit
	WHERE    A.UserAccount = '#URL.ID#' 
	<cfif URL.Search neq "">
	AND      (R.Role LIKE '%#URL.Search#%' or R.Description LIKE '%#URL.Search#%')
	</cfif>
	AND      A.AccessId NOT IN (SELECT AccessId 
	                            FROM   UserAuthorizationActionLog
								WHERE  UserAccount = '#URL.ID#'
								AND    ActionStatus IN ('1','9')) 
	<cfif SESSION.isAdministrator eq "No">
	AND     R.RoleOwner IN (SELECT ClassParameter 
	                        FROM   OrganizationAuthorization
							WHERE  Role = 'AdminUser'
							AND    AccessLevel = '2'
							AND    UserAccount = '#SESSION.acc#') 
	AND     R.SystemModule != 'System'						
	</cfif>
	ORDER BY R.SystemModule, R.Description, A.Mission, Org.OrgUnitName, Org.MandateNo, A.AccessId 
</cfquery>

<cfif Pending.recordcount neq "0">
	  <cfset dis = "False">
<cfelse>
      <cfset dis = "True">
</cfif>		
	
<form method="post" name="pendinglines">
		
	<table width="100%" align="center" class="navigation_table">
		  
		<tr><td height="6"></td></tr>
		<tr class="labelmedium2 line">
		 <td>&nbsp;</td>
		 <td>Module</td>
		 <td>Tree</td>
		 <td>Unit</td>
		 <td>Source</td>
		 <td>Level</td>
		 <td>Granted by</td>
		 <td>Date</td>
		 <td>Clear</td>
		 <td>Deny</td>
		</tr>
					
		<cfif Pending.recordcount eq "0">
			<tr><td colspan="10" style="padding-top:4px" class="labelmedium" align="center"><font color="gray">There are no more items to show in this view.</td></tr>
		</cfif>
				
			<cfoutput query="Pending" group="SystemModule">
			
			<tr class="labelmedium2 fixrow">
			 <td>&nbsp;</td>
			 <td><b>#SystemModule#</b></td>
			 <td colspan="8"></td>
			</tr> 
			
			<cfoutput group="Description">
			
			<tr class="labelmedium2 fixrow2">
			 <td>&nbsp;</td>
			 <td>&nbsp;&nbsp;#Description#</td>
			 <td colspan="8"></td>
			</tr>
			
			<cfoutput>		
						
			<tr class="labelmedium2 navigation_row line">
			 <td>&nbsp;</td>
			 <td></td>
			 <td><cfif #Mission# eq "">Global<cfelse>#Mission#</cfif></td>
			 <td><cfif #OrgUnitName# neq "">#OrgUnitName# (#MandateNo#)</cfif></td>
			 <td>#Source#</td>
			 <td align="center">#AccessLevel#</td>
			 <td>#OfficerFirstName# #OfficerLastName#</td>
			 <td>#DateFormat(Created,CLIENT.DateFormatShow)#</td>
			 <td><input type="radio" class="radiol" name="a#currentRow#" id="a#currentRow#" value="1" checked></td>
			 <td><input type="radio" class="radiol" name="a#currentRow#" id="a#currentRow#" value="9"></td>			
			 <td></td>
			</tr>						
			
			<cfif ClassParameter neq "">
			
				<tr class="labelmedium navigation_row_child">
				 <td>&nbsp;</td>
				 <td></td>
				 <td></td>
				 <td colspan="8" class="labelit">
				 
				 <cfif ClassIsAction eq "1">
				  
					  <cfif ClassIsAction eq "1">
					  
					    <cfquery name="Workflow" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * FROM Ref_EntityAction
							WHERE ActionCode = '#ClassParameter#'
						</cfquery>
						workflow action : #Workflow.ActionDescription#
					  
					  </cfif>
			 
				<cfelse>
			
					 #ClassParameter#
					
				</cfif>
			 
				</tr>
							
			</cfif>
					
			</cfoutput>
			</cfoutput>			
			</cfoutput>
			
			<cfif pending.recordcount gte "1">
			<cfoutput>
			<tr><td colspan="10" height="30" align="center">			
				<input type="button"  
				   value="Submit" 
				   class="button10g" 
				   name="Submit" 
				   id="Submit" 
				 onclick="ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingProcess.cfm?search=#url.search#&id=#URL.ID#','processlist','','','POST','pendinglines')">
			</td></tr>
			</cfoutput>
			</cfif>
					
	</table>
		
</form>	

<cfset ajaxonload("doHighlight")>
