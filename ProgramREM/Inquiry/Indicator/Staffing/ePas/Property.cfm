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

<cfparam name="url.Nationality" default="">
<cfparam name="url.item" default="">
<cfparam name="url.select" default="All">
<cfparam name="url.OrgUnitOperational" default="">

<!--- customise to show additional details in the left box  --->

<cfsavecontent variable="from">
	<cfoutput>	
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#'
	AND     PersonNo is not NULL 
	#preservesingleQuotes(OrgFilter)#
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#'
	</cfif>
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	AND       IndexNo NOT IN
	              (SELECT   Indexno
	               FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaOther neq "">
				   AND      #preserveSingleQuotes(indicator.IndicatorCriteriaOther)#
				   </cfif>		
				   AND      (ePASCreateDate <= '#Audit.AuditDate#')
				   )  
	</cfoutput>	
</cfsavecontent>

<cfquery name="Position" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  count(*) as Position,
	        count(distinct OrgUnitName) as OrgUnit,
			count(distinct PersonNo) as Person
	#preservesingleQuotes(from)#
</cfquery>  

<cfquery name="PostClass" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  PostGradeBudget,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY PostOrderBudget, PostGradeBudget
</cfquery>  

<cfquery name="Nationality" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  top 13 Nationality,
	        count(*) as Total
	#preservesingleQuotes(from)#
	AND     Nationality > ''
	GROUP BY Nationality
	ORDER BY Total DESC
</cfquery>  

<cfquery name="Gender" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  Gender,
	        count(*) as Total
	#preservesingleQuotes(from)#	
	AND     PersonNo > ''
	GROUP BY Gender
</cfquery>  

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td colspan="2" height="20" align="center"><input type="button" class="button10g" name="Close" onclick="javascript:ColdFusion.Window.hide('rightpanel')" value="Close"></td></tr>
<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
<tr><td valign="top">
	
	<table width="99%" border="0" bordercolor="silver" align="center" border="2" cellpadding="0" class="formpadding">
	<cfoutput>
	<tr><td colspan="1">#url.item#:</td><td align="right"><b>#URL.Select#</b></td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</cfoutput>
	
	<tr>
	<td>Units:</td>
	<td align="right"><cfoutput>#Position.OrgUnit#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	
	<tr><td><b>Positions:</td>
		<td align="right"><cfoutput><b>#Position.Position#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	<cfoutput query="PostClass">
	<tr><td>#PostGradeBudget#</td>
		<td align="right">#Total#</td>
	</tr>
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	<tr><td><b>Gender</td>
		<td align="right"><cfoutput><b>#Position.Person#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<cfoutput query="Gender">
	<tr><td>#Gender#</td>
		<td align="right">#Total#</td>
	</tr>	
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	</table>
	
</td>

<td valign="top">
	<table width="99%" border="0" bordercolor="silver" align="center" border="0" cellpadding="0" class="formpadding">
		<tr><td><b>Staff:</td>
			<td align="right"><cfoutput><b>#Position.Person#</cfoutput></td>
		</tr>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		<cfoutput query="Nationality">
		<tr><td>#Nationality#</td>
			<td align="right">#Total#</td>
		</tr>
		</cfoutput>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</table>
</td>

</tr>
</table>

	