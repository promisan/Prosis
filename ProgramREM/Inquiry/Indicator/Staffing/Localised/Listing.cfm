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

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  *,
	        1 as Positions,
			CASE WHEN PersonNo is NULL THEN 0 
				 ELSE 1 END AS Incumbent,	
			CASE WHEN PersonNo is NULL THEN 1 
				 ELSE 0 END AS Vacant		 			
	FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>	
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
				OrgUnitName, 
				sum(Positions) as Positions, 
				sum(Incumbent) as Incumbered,
				sum(Vacant) as Vacant
	FROM    Base
	GROUP BY HierarchyCode, OrgUnitOperational, OrgUnitName
	ORDER BY HierarchyCode</cfquery> 

<cfquery name="Nat" dbtype="query">
	SELECT  DISTINCT Nationality
	FROM    Base
	WHERE Nationality > ''
	ORDER BY Nationality		
</cfquery> 

<cfquery name="List" dbtype="query">
	SELECT  *
	FROM    Base
	WHERE   1= 1 
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	ORDER BY HierarchyCode	
</cfquery> 

<table width="100%" border="0" cellpadding="0" class="formpadding">

<tr>
	<td align="right">
		<cfinclude template="../../Template/ListingMenu.cfm">
	</td>
</tr>
<tr><td class="line"></td></tr>

<tr><td valign="top">
<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="6" align="center"><b>No records found</b></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<cfquery name="get"
	   dbtype="query">
		SELECT  sum(Positions) as Positions, 
				sum(Incumbent) as Incumbered,
				sum(Vacant) as Vacant
		FROM    Base
		WHERE OrgUnitOperational = #OrgUnitOperational#
	</cfquery> 

	<tr>
		<td colspan="6">#OrgUnitName#</td>
		<td align="right">
		<table align="right">
		<tr>
		<td width="20"><b>#get.Positions#</b></td>
		<td width="20"><font color="green">#get.Incumbered#</td>
		<td width="20"><b><font color="FF0000">#get.Vacant#</font></b></td>
		</tr>
		</table>
		</td>
	</tr>	
	<tr><td colspan="7" class="line"></td></tr>
	
	<cfoutput>
	
		<cfif PersonNo eq "">
		<cfset cl = "FF5B5B">
		<cfelse>
		<cfset cl = "ffffdf">
		</cfif>
		
		<tr bgcolor="#cl#">
			<td height="18" width="20"></td>
			<td width="20">#currentrow#.</td>
			<td><a href="javascript:EditPost('#PositionNo#')">#FunctionDescription#</a></td>
			<td>#PostClass#</td>
			<td>#PostGrade#</td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
			<td>#FullName#</td>
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
