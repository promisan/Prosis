
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
