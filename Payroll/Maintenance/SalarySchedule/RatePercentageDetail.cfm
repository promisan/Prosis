
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="350" cellspacing="0" cellpadding="0">

<cfparam name="url.mode" default="Month">

<cfoutput>

<cfif url.mode eq "Month">
	
	<tr>
	<td>Month</td>
	<td>Percentage</td>
	</tr>
	<cfloop index="mth" from="1" to="12">
	
		<tr>
		<td>#Mth#</td>
		<td>
		<input type="text" name="#Mth#_Percentage" size="6" maxlength="6">		
		</td>
		
		</tr>
		
	</cfloop>

</cfif>

</cfoutput>

</table>
