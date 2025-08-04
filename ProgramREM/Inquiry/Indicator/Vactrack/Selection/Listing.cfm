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

<cfinclude template="../../Template/IndicatorTarget.cfm">

  <cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      EmployeeSnapShot.dbo.HRPO_AppSelectionDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	<cfif url.item neq "" and url.select neq "">
	AND     #URL.Item#      = '#URL.Select#'	
	</cfif>
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>		
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>		
	<cfif url.OrgUnitOperational neq "">
	AND OrgUnitOperational = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND Nationality = '#URL.Nationality#'
	</cfif>	
   </cfquery>	
			
 <cfquery name="Unit"
   dbtype="query">
	SELECT  DISTINCT HierarchyCode, OrgUnitOperational, OrgUnitName
	FROM    Base
	ORDER BY HierarchyCode</cfquery> 
	
<cfquery name="Contact" dbtype="query">
	SELECT  DISTINCT OfficerUserId,OfficerLastName,OfficerFirstName
	FROM    Base  
</cfquery>  	

<cfquery name="List" dbtype="query">
	SELECT  *
	FROM    Base
	WHERE   1= 1 
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URL.OrgUnitOperational# 
	</cfif>
	<cfif URL.OfficerUserid neq "">
	AND     OfficerUserid = '#URL.OfficerUserid#' 
	</cfif>
	ORDER BY NumDays DESC, DocumentNo DESC
</cfquery> 
 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td align="right" bgcolor="f4f4f4">
		<cfinclude template="../../Template/ListingMenu.cfm">
	</td>
</tr>
<tr><td class="line"></td></tr>

<tr><td valign="top">
<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="8" align="center"><b>No records found</b></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<tr><td colspan="8">#OrgUnitName#</td></tr>	
	
	<cfoutput>
	
		<cfif Numdays gt "30">
		<cfset cl = "FF8080">
		<cfelse>
		<cfset cl = "ffffdf">
		</cfif>
		
		<tr bgcolor="#cl#">
			<td height="18" width="20"></td>
			<td width="20">#currentrow#.</td>
			<td><a href="javascript:showdocument('#DocumentNo#','')">#DocumentNo#</a></td>
			<td>#FunctionDescription#</td>
			<td>#PostGradeBudget#</td>
			<td>#DateFormat(Started, CLIENT.DateFormatShow)#</td>
			<td>#DateFormat(Completed, CLIENT.DateFormatShow)#</td>
			<td>#NumDays#</td>
		</tr>
		<tr><td colspan="8" bgcolor="d0d0d0"></td></tr>
	
	</cfoutput>
	<tr><td height="20"></td></tr>
	
</cfoutput>
</table>
</td></tr></table>
