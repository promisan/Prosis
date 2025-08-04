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
<cfif url.customerid eq "">
	<cfset url.customerid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT   *
	FROM      WorkOrder W, ServiceItem S
	WHERE     Customerid = '#url.customerid#'
	AND       W.ServiceItem = S.Code
	AND       Mission = '#url.mission#'
	AND       ActionStatus = '1'
	ORDER By  OrderDate
</cfquery>	

<cfoutput>

<table width="100%" cellspacing="6" cellpadding="6">

	<input type="hidden" id="workorderid" name="workorderid" value="#workorder.workorderid#">
	
	<cfloop query="workorder">
	
	<tr>
		<td><input type="radio" name="selected" id="selected" style="width:18;height:18"
		           onclick="document.getElementById('workorderid').value='#workorderid#'" 
				   value="#workorderid#" <cfif currentrow eq "1">checked</cfif>>
	    </td>
		<td class="labellarge"><i>#Description#</td>
		<td class="labellarge"><i>#Reference#</td>
		<td class="labellarge" align="center"><i>#dateformat(OrderDate,CLIENT.DateFormatShow)#</td>
	</tr>
	
	</cfloop>

</table>

</cfoutput>