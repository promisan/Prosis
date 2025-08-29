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
<cfoutput>
<cfquery name="Details" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM         ClaimLineDSA    
		WHERE ClaimId = '#IdClaim#'
		AND  LocationCode is not NULL
		AND  PersonNo = '#PersonNo#' 
		ORDER BY CalendarDate
		</cfquery>
		
		<cfset dsa = dsa+Details.recordcount>
				
		<table width="100%" align="center" border="0" cellspacing="1" cellpadding="2">
		<tr>
		<td width="40"></td>
		<td width="100"><b>Date</b></td>
		<td width="100"><b>DSA Location</b></td>
		<td align="right" width="70"><b>Period</b></td>
		<td align="right" width="60"><b>Curr</b></td>
		<td width="15%" align="right"><b>Rate</b></td>
		<td width="15%" align="right"><b>Percentage</b></td>
		<td width="15%" align="right"><b>Amount</b></td>
		<td width="15%" align="right"><b>Payment</b></td>
		
		</tr>
		<tr><td colspan="9" bgcolor="C0C0C0"></td></tr>
		<cfset dt = "">
		<cfset row = 0>
		<cfloop query="Details">
		
		<cfif dt neq CalendarDate>
			<cfset row = row+1>
		</cfif>
		
		<tr bgcolor="ffffdf">
		<td><cfif dt neq CalendarDate>#row#.</cfif></td>
		<td><cfif dt neq CalendarDate>#DateFormat(CalendarDate, CLIENT.DateFormatShow)#</cfif></td>
		<td><cfif dt neq CalendarDate>#LocationCode#</cfif></td>
		
		<td align="right">
		<cfif dt neq CalendarDate>
			<cfif #RatePointer# eq "999"><cfelse>#RatePointer#&nbsp;day</cfif>
		</cfif>
		</td>
		<td align="right">#Currency#</td>
		<td align="right">#numberFormat(Rate,"__,__.__")#</td>
		<td align="right">#numberFormat(Percentage,"__._")#%</td>
		<td align="right">#numberFormat(Amount,"_,__.__")#</td>
		<td align="right">#numberFormat(AmountPayment,"__,__.__")#</td>
		</tr>
			<cfif CurrentRow neq "#Recordcount#">
			<tr><td height="1" colspan="9" bgcolor="e4e4e4"></td></tr>
			</cfif>
		<cfset dt = CalendarDate>	
		</cfloop>
		</table>
</cfoutput>		