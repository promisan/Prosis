
<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cfajaximport tags="cfdiv">

<cf_listingscript>

<table width="100%" height="100%">

<tr>
	<td style="padding-left:8px" class="labellarge">
	<cfoutput>#screentoplabel#</cfoutput>	
	</td>
</tr>

<tr><td height="100%" valign="top">
	<cfinclude template="ShipmentListingContent.cfm">
</td></tr>

</table>