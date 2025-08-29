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
<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfquery name="List" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *
	FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>	
	AND     Gender = 'F'
	#preservesingleQuotes(OrgFilter)#
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#' 
	</cfif>
	<cfif url.OrgUnitOperational neq "">
	AND OrgUnitOperational = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND Nationality = '#URL.Nationality#'
	</cfif>	
	ORDER BY HierarchyCode	
</cfquery>  

 <cfquery name="Unit"
   dbtype="query">
	SELECT  DISTINCT HierarchyCode, 
	            OrgUnitOperational, 
				OrgUnitName
	FROM    List
	GROUP BY HierarchyCode, OrgUnitOperational, OrgUnitName
	ORDER BY HierarchyCode</cfquery> 

<cfquery name="Nat" dbtype="query">
	SELECT  DISTINCT Nationality
	FROM    List
	WHERE Nationality > ''
	ORDER BY Nationality		
</cfquery> 

<table width="100%" border="0" cellpadding="0" class="formpadding">
<tr>
	<td align="right">
		<cfinclude template="../../Template/ListingMenu.cfm">
	</td>
</tr>
<tr><td class="line"></td></tr>

<tr><td valign="top">
<table width="99%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="6" align="center"><b>No female representation</b></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<tr>
	<td colspan="6">#OrgUnitName#</td>
	</tr>	
	
	<cfoutput>
	
		<cfif PersonNo eq "">
		<cfset cl = "FF8080">
		<cfelse>
		<cfset cl = "ffffdf">
		</cfif>
		
		<tr bgcolor="#cl#">
			<td height="18" width="20"></td>
			<td width="20">#currentrow#.</td>
			<td><a href="javascript:EditPost('#PositionNo#')">#FunctionDescription#</a></td>
			<td>#PostClass#</td>
			<td>#AssignPostGrade#</td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#FullName#</a></td>
		</tr>
		<tr><td colspan="7" bgcolor="d0d0d0"></td></tr>
		
		<!--- provision for export --->
		<cfif id neq "">
			<cfset id = "#id#,'#recordno#'">	
		<cfelse>
		    <cfset id = "'#recordno#'">	
		</cfif>
	
	</cfoutput>
	<tr><td height="20"></td></tr>
	
</cfoutput>
</table>

<cfinclude template="../../Template/ListingBottom.cfm">

</td></tr></table>
