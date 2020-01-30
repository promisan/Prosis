
<cf_screentop height="100%" scroll="Yes" html="No">

<input type="hidden" name="conditionvalue" id="conditionvalue">

<cfparam name="URL.Owner" default="">
<!--- <cfinclude template="ViewScript.cfm"> --->

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<!---
    <cfif url.id1 eq "Locate">
	<tr><td height="100">
		<cfinclude template="ViewLocate.cfm">
	</td></tr>
	<tr><td height="90%" valign="top">
		<cfdiv id="detail">
	</td></tr>
	<cfelse>--->
	<tr>
		<td height="100%" valign="top" id="detail"> 

		  <cfinclude template="ViewListing.cfm">

		</td>
	</tr>	
	<!---
	</cfif>
	--->
</table>

