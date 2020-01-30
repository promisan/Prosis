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
	                            FROM UserAuthorizationActionLog
								WHERE UserAccount = '#URL.ID#'
								AND   ActionStatus IN ('1','9')) 
	<cfif SESSION.isAdministrator eq "No">
	AND     R.RoleOwner IN (SELECT ClassParameter 
	                        FROM OrganizationAuthorization
							WHERE Role = 'AdminUser'
							AND  AccessLevel = '2'
							AND  UserAccount = '#SESSION.acc#') 
	AND     R.SystemModule != 'System'						
	</cfif>
	ORDER BY R.SystemModule, R.Description, A.Mission, Org.OrgUnitName, Org.MandateNo, A.AccessId 
</cfquery>

<cfif Pending.recordcount neq "0">
	  <cfset dis = "False">
<cfelse>
      <cfset dis = "True">
</cfif>		
	
<form action="UserAccessListingProcess.cfm?search=<cfoutput>#url.search#&id=#URL.ID#</cfoutput>" 
	  method="post" name="pendinglines" id="pendinglines">
		
	<table width="100%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">
		  
		<tr><td height="6"></td></tr>
		<tr class="labelit linedotted">
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
			<tr><td colspan="10" style="padding-top:4px" class="labelmedium" align="center"><font color="gray"><i>There are no more items to show in this view.</td></tr>
		</cfif>
				
			<cfoutput query="Pending" group="SystemModule">
			
			<tr>
			 <td>&nbsp;</td>
			 <td class="labelmedium"><b>#SystemModule#</b></td>
			 <td colspan="8"></td>
			</tr> 
			
			<cfoutput group="Description">
			
			<tr>
			 <td>&nbsp;</td>
			 <td class="labelmedium">&nbsp;&nbsp;#Description#</td>
			 <td colspan="8"></td>
			</tr>
			
			<cfoutput>
			
						
			<tr class="labelit navigation_row">
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
			
				<tr class="labelit navigation_row_child">
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
			<tr><td colspan="10" height="30" align="center">
				<input type="submit"  value="Submit" class="button10g" name="Submit" id="Submit">
			</td></tr>
			</cfif>
					
	</table>
		
</form>	
