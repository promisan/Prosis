
<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT M.Mission, M.MissionName, C.ConditionValue
	FROM   UserModuleCondition C RIGHT OUTER JOIN
           Organization.dbo.Ref_Mission M ON C.ConditionValue = M.Mission 
			AND C.SystemFunctionId = '#URL.ID#'
			AND C.Account          = '#SESSION.acc#'
			AND C.ConditionField   = 'Mission'
	WHERE   Mission IN (SELECT Mission 
                        FROM Organization.dbo.Ref_MissionModule 
					    WHERE SystemModule = 'Staffing')
	AND M.Operational = 1						
						
	<cfif session.isAdministrator neq "Yes">
		
	AND    ( 
	
			Mission IN (
	                   SELECT Mission 
	                   FROM   Organization.dbo.OrganizationAuthorization
	                   WHERE  UserAccount = '#SESSION.acc#'
					   AND    Role IN (SELECT Role 
									   FROM   Organization.dbo.Ref_AuthorizationRole 
							           WHERE  SystemModule = 'Staffing')									   
					  )	
					  
			<cfif SESSION.isLocalAdministrator neq "No">
				OR Mission IN (#preservesingleQuotes(SESSION.isLocalAdministrator)#)	
			</cfif>
			
			)			 

	</cfif>					
				
	AND    Mission in (SELECT Mission from Employee.dbo.Position WHERE Mission = M.Mission)						  
					 				 
</cfquery>

<cfparam name="URL.Mode" default="Portal">

<cfform action="../Topics/TopicsEditSubmit.cfm?mode=#url.mode#" method="POST">

<cfoutput>
	<input type="hidden" name="SystemFunctionId" value="#URL.ID#">
	<input type="hidden" name="ConditionField"   value="Mission">
</cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">

<tr><td>

<table width="100%" cellspacing="0" cellpadding="0">

<TR>
    <td height="26" colspan="3" style="padding-left:5px" class="labelit"><cf_tl id="Select only one entity for your topic"></td>
</TR>
<tr><td colspan="3" class="linedotted"></td></tr>

<cfset module = "">

<cfoutput query="List">

<cfif ConditionValue is ''>
   <tr class="regular" class="navigation_row line">
<cfelse>
   <tr class="highLight2" class="navigation_row line">
</cfif>   
   
    <td width="10%" align="center">
	<cfif ConditionValue is ''>
	<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#Mission#">
	<cfelse>
	<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#Mission#" checked>
	</cfif>
    </td>
    <td width="20%" class="labelmedium2">#Mission#</td>
	<TD class="labelmedium2">#MissionName#</TD>
 
</TR>

</CFOUTPUT>

<cfoutput>
	<input type="hidden" name="number" value="#List.recordcount#">
</cfoutput>

<tr><td colspan="3" height="35" align="center">  
   <input type="submit" class="button10g" name="Update" value="Save">
</td></tr>
</table>

</td></tr>

</table>
	
</CFFORM>

<cfset ajaxOnLoad("doHighlight")>
