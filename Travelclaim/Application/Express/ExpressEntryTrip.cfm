
<cfquery name="Parameter" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Trip" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     T.*
	FROM       ClaimEvent E, ClaimEventTrip T
	WHERE      ClaimId = '#IDClaim#'
	AND        E.ClaimEventId = T.ClaimEventId
	ORDER BY   LocationDate   
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center">
<tr bgcolor="ffffff"><td height="23" colspan="6">Please indicate when you were provided with a vehicle</td></tr>
<tr><td colspan="6" bgcolor="EAEAEA"></td></tr>
<tr>
<td height="18"><b>&nbsp;No</td>
<td><b>Arr/Dep</td>
<td><b>City / Country</td>
<td><b>Date</td>
<td><b>Indicator</td>
<td>
<cfoutput query="trip">
	<tr><td colspan="6" bgcolor="EAEAEA"></td></tr>
	<tr>
		<td>&nbsp;#CurrentRow#</td>
		<td>#ClaimTripMode#</td>
		<td>#LocationCity# [#LocationCountry#]</td>
		<td>#DateFormat(LocationDate, CLIENT.DateFormatShow)#</td>
		<td>				
		<cf_ClaimEventEntryIndicatorPointer 
		   fld="#currentrow#_"
		   category = "'#claimtripmode#'"
		   tripid = "#ClaimTripId#">		
		  
		</td>
	</tr>
</cfoutput>
<cfset trm = #trip.recordcount#>
</table>
