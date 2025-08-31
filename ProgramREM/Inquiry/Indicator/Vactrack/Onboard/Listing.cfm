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
<cfparam name="url.print" default="0">
<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfinclude template="../Template/IndicatorTarget.cfm">

  <cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *, 0 as Pending, 1 as Attended
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType = 'International'
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#'	
	</cfif>
	AND       PersonNo NOT IN
	              (SELECT   PersonNo
	               FROM     EmployeeSnapShot.dbo.HRPO_AppStaffDevelopmentDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaBase neq "">
				   AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
				   </cfif>		
				   AND      DateCompleted <= '#Audit.AuditDate#'
				  ) 
	
 </cfquery>	
		
 <cfquery name="Unit"
   dbtype="query">
	SELECT  DISTINCT HierarchyCode, OrgUnitOperational, OrgUnitName
	FROM    Base
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

<cfoutput>

<cfif url.print eq "0">

<tr>
	<td align="right">
	<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr>
	  <td>Unit</td>
	  <td>
	  <input type="hidden" name="item1" value="OrgUnitOperational">
	  <select name="select1" onchange="reloadlisting()">
				<option value="" SELECTED></option>
				<cfloop query="Unit">
				<cfset l = len(hierarchycode)>
				#OrgUnitOperational#
				<option value="#OrgUnitOperational#" <cfif url.orgunitoperational eq orgunitoperational>selected</cfif>><cfloop index="itm" from="1" to="#l-4#">&nbsp;&nbsp;</cfloop>#OrgUnitName#</option>
				</cfloop>				
	  </select>
	  </td>
	  <td>Nationality</td>
	  <td>
	   <input type="hidden" name="item2" value="Nationality">
	  <select name="select2" onchange="reloadlisting()">
		<option value="" SELECTED></option>
			<cfloop query="Nat">
			<option value="#Nationality#" <cfif url.nationality eq nationality>selected</cfif>>#Nationality#</option>
			</cfloop>				
	  </select>
	  </td>
	  <td align="right" width="60%">
	  
	   <cfinclude template="../../Template/ListingMenu.cfm">
	  	  
		

    </td>
	</tr></table>
</tr>
<tr><td class="line"></td></tr>

<cfelse>

	<tr><td><cfinclude template="../../../ProgramREM/Application/Indicator/Details/DetailViewBaseTop.cfm"></td></tr>
	<tr>
	<td align="center"><cfinclude template="TrainingGraphData.cfm"></td>
	</tr>
	<tr><td>&nbsp;Filter : <b>#URL.Select#</b></td></tr>

	<script> print() </script>

</cfif>

</cfoutput>

<tr><td valign="top">
<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="6" align="center"><b>No records found</b></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<tr><td colspan="6">#OrgUnitName#</td></tr>	
	
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
			<td>#PostGrade#</td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
			<td>#FullName#</td>
		</tr>
		<tr><td colspan="7" bgcolor="d0d0d0"></td></tr>
	
	</cfoutput>
	<tr><td height="20"></td></tr>
	
</cfoutput>
</table>
</td></tr></table>
