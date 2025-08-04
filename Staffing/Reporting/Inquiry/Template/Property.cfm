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

<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.item" default="">
<cfparam name="url.select" default="All">

<!--- customise to show additional details in the left box  --->

<cfsavecontent variable="from">
	<cfoutput>
	FROM    #SESSION.acc#_AppStaffingDetail_#url.fileno# 
	WHERE   1=1 
		
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#'
	</cfif>
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	
	</cfoutput>	
</cfsavecontent>

<cfquery name="Position" 
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  count(*) as Position,
	        count(distinct OrgUnitName) as OrgUnit,
			count(distinct PersonNo) as Person
	#preservesingleQuotes(from)#
</cfquery>  

<cfquery name="PostClass" 
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  PostClass,
	        count(*) as Total
	#preservesingleQuotes(from)#
	GROUP BY PostClass
</cfquery>  

<cfquery name="Nationality" 
    datasource="AppsQuery" 
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
    datasource="AppsQuery" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  Gender,
	        count(*) as Total
	#preservesingleQuotes(from)#	
	AND     PersonNo > ''
	GROUP BY Gender
</cfquery>  

<table width="100%" height="100%">

<tr><td bgcolor="white" valign="top" style="padding:4px">

<table width="99%" class="formspacing" align="center">

<tr><td valign="top" width="50%">
	
	<table width="95%" border="0" align="center" class="formpadding">
	<cfoutput>
	<tr><td class="labelit" colspan="1">#url.item#:</td><td align="right" class="labelit"><b>#URL.Select#</b></td></tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>
	</cfoutput>
	
	<tr>
	<td class="labelit">Units:</td>
	<td class="labelit" align="right"><cfoutput>#Position.OrgUnit#</cfoutput></td>
	</tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>
	<tr><td height="20"></td></tr>
	
	<tr class="line"><td class="labelit"><b>Positions:</td>
		<td class="labelit" align="right"><cfoutput><b>#Position.Position#</cfoutput></td>
	</tr>
	
	<cfoutput query="PostClass">
	<tr class="line"><td class="labelit">#PostClass#</td>
		<td class="labelit" align="right">#Total#</td>
	</tr>
	</cfoutput>
	<tr><td height="1" colspan="2" class="line"></td></tr>
	<tr><td height="20"></td></tr>
	<tr class="line"><td class="labelit"><b>Gender</td>
		<td class="labelit" align="right"><cfoutput><b>#Position.Person#</cfoutput></td>
	</tr>
	
	<cfoutput query="Gender">
	<tr class="line"><td class="labelit">#Gender#</td>
		<td class="labelit" align="right">#Total#</td>
	</tr>	
	</cfoutput>
	
	</table>
	
</td>

<td valign="top" width="50%">
	<table width="95%" border="0" align="center">
		<tr><td class="labelit"><b>Staff:</td>
			<td align="right" class="labelit"><cfoutput><b>#Position.Person#</cfoutput></td>
		</tr>
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<cfoutput query="Nationality">
		<tr style="height:12px" class="labelit line">
		    <td>#Nationality#</td>
			<td align="right">#Total#</td>
		</tr>
		</cfoutput>
		
	</table>
</td>

</tr>
</table>

</td>
</tr>
</table>

	