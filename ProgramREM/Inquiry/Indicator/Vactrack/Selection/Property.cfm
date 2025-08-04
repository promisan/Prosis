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
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.item" default="">
<cfparam name="url.select" default="All">

<!--- customise to show additional details in the left box  --->

<cfsavecontent variable="from">
	<cfoutput>	
	FROM      EmployeeSnapShot.dbo.HRPO_AppSelectionDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND      Status = '1'
	<cfif url.item neq "" and url.select neq "">
	AND     #URL.Item#      = '#URL.Select#'	
	</cfif>
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>			
	</cfoutput>	
</cfsavecontent>

<cfquery name="Track" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  count(distinct documentNo) as Track,
	        count(distinct OrgUnitName) as OrgUnit,
			count(distinct OfficerUserId) as Contact,
			count(distinct FunctionNo) as FunctionNo
	#preservesingleQuotes(from)#
</cfquery>  

<cfquery name="PostClass" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  PostGradeBudget, PostOrderBudget,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY PostGradeBudget, PostOrderBudget
	ORDER BY PostOrderBudget
</cfquery>  

<cfquery name="Contact" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  OfficerUserId,OfficerLastName,OfficerFirstName,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY OfficerUserId,OfficerLastName,OfficerFirstName
</cfquery>  

<cfquery name="Function" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  FunctionNo, FunctionDescription,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY FunctionNo, FunctionDescription
	ORDER By FunctionDescription
</cfquery>  


<table width="100%" height="100%">
<tr><td bgcolor="white">

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td colspan="2" height="26" align="center"><input type="button" class="button10g" name="Close" onclick="ColdFusion.Window.hide('rightpanel')" value="Close"></td></tr>
<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
<tr><td valign="top">
	
	<table width="99%" border="0" bordercolor="silver" align="center" border="0" cellpadding="0" class="formpadding">
	<cfoutput>
	<tr><td colspan="1">#url.item#:</td><td align="right"><b>#URL.Select#</b></td></tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</cfoutput>
	
	<tr>
	<td>Units:</td>
	<td align="right"><cfoutput>#Track.OrgUnit#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	
	<tr><td><b>Tracks:</td>
		<td align="right"><cfoutput><b>#Track.Track#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	<cfoutput query="PostClass">
	<tr><td>#PostGradeBudget#</td>
		<td align="right">#Total#</td>
	</tr>
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<tr><td height="20"></td></tr>
	<tr><td><b>Contact</td>
		<td align="right"><cfoutput><b>#Track.Contact#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	<cfoutput query="Contact">
	<tr><td>#OfficerFirstName# #OfficerLastName#</td>
		<td align="right">#Total#</td>
	</tr>	
	</cfoutput>
	<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	
	</table>
	
</td>

<td valign="top">
	<table width="99%" border="0" bordercolor="silver" align="center" border="0" cellpadding="0" class="formpadding">
		<tr><td><b>Function:</td>
			<td align="right"><cfoutput><b>#Track.FunctionNo#</cfoutput></td>
		</tr>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		<cfoutput query="Function">
		<tr><td>#FunctionDescription#</td>
			<td align="right">#Total#</td>
		</tr>
		</cfoutput>
		<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
	</table>
</td>

</tr>
</table>
</td>
</tr>
</table>

	