

<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cfajaximport tags="cfdiv">

<cf_listingscript>

<table width="100%" cellspacing="0" cellpadding="0" height="100%">

<tr>
	<td style="padding-left:8px" class="labellarge">
	<table><tr class="labellarge"><td style="font-size:16px"><cf_tl id="Billing">:</td><td><cfoutput>#screentoplabel#</cfoutput></td></tr></table> 	
	</td>
</tr>

<tr><td height="100%" valign="top" style="padding:5px">   
	<cfinclude template="BillingListingContent.cfm">	
</td></tr>

</table>