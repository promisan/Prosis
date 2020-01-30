
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