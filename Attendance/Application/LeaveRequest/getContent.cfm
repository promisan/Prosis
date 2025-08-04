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

<cfquery name="get" 
	datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT Status, DescriptionShort 
		FROM  PersonLeave P, Ref_LeaveTypeClass R
		WHERE PersonNo = '#url.personno#'
		AND   P.LeaveType = R.LeaveType
		AND   P.LeaveTypeClass = R.Code
		AND   Status IN ('0','1','2')
		AND   DateEffective <= #url.calendardate#
		AND   DateExpiration >= #url.calendardate#
</cfquery>

<cfif get.recordcount gte "1">
		
	<cfif get.Status eq "2">
		<cfset cl = "lime">
	<cfelseif get.status eq "1">
		<cfset cl = "yellow">
	<cfelse>
		<cfset cl = "white">		
	</cfif>
	<cfoutput>
	<table style="width:100%;height:10px">
	<tr style="height:10px">
	<td align="center" style="font-size:10px;border:1px solid b1b1b1;background-color:#cl#">#get.DescriptionShort#</td>
	</tr>
	</table>
	</cfoutput>
		
</cfif>
