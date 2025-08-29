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
<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT DISTINCT M.Mission, M.Warehouse, M.WarehouseName, C.ConditionValue
	FROM   UserModuleCondition C RIGHT OUTER JOIN
           Materials.dbo.Warehouse M ON C.ConditionValue = M.Warehouse 
			AND C.SystemFunctionId = '#URL.ID#'
			AND C.Account          = '#SESSION.acc#'
			AND C.ConditionField   = 'Warehouse'
	WHERE   M.Mission IN (SELECT Mission 
                          FROM Organization.dbo.Ref_MissionModule 
					      WHERE SystemModule = 'Warehouse')
	AND    SaleMode IN ('1','2','3')				
	<!--- has access somehow to procurement --->	
	
	<cfif session.isAdministrator neq "Yes">
		
	AND    ( 
	
			Mission IN (
	                   SELECT Mission 
	                   FROM   Organization.dbo.OrganizationAuthorization
	                   WHERE  UserAccount = '#SESSION.acc#'
					   AND    Role IN (SELECT Role 
									   FROM   Organization.dbo.Ref_AuthorizationRole 
							           WHERE  SystemModule = 'Warehouse')									   
					  )	
			
			<cfif SESSION.isLocalAdministrator neq "No">
				OR Mission IN (#preservesingleQuotes(SESSION.isLocalAdministrator)#)	
			</cfif>
			
			)
			 

	</cfif>
	
	ORDER BY Mission, Warehouse
						 				 
</cfquery>

<cfparam name="URL.Mode" default="Portal">

<cfform action="../Topics/TopicsEditSubmit.cfm?mode=#url.mode#" method="POST">

<cfoutput>
<input type="hidden" name="SystemFunctionId" value="#URL.ID#">
<input type="hidden" name="ConditionField"   value="Warehouse">
</cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">

<tr><td>

<table width="100%" cellspacing="0" cellpadding="0">

<TR>
    <td height="26" colspan="3" style="padding-left:5px" class="labelit">Select one or more Warehouses for your topic</td>
</TR>
<tr><td colspan="3" class="linedotted"></td></tr>

<cfset module = "">

<cfoutput query="List" group="Mission">

   <tr><td colspan="2" class="labelmedium"><b>#Mission#</td></tr>
	
	<cfoutput>		
		
		<cfif ConditionValue is ''>
		   <tr class="regular" class="navigation_row linedotted">
		<cfelse>
		   <tr class="highLight" class="navigation_row linedotted">
		</cfif>   
		   
		    <td style="padding-left:10px" width="10%" align="center">
			<cfif ConditionValue is ''>
			<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#Warehouse#">
			<cfelse>
			<input type="checkbox" class="radiol" name="Value_#List.currentrow#" value="#Warehouse#" checked>
			</cfif>
		    </td>
		    <td width="20%" class="labelmedium">#Warehouse#</td>
			<TD class="labelmedium">#WarehouseName#</TD>
		 
		</TR>
		
	
	</cfoutput>

</cfoutput>

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
