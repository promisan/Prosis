
<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cfajaximport tags="cfdiv">

<cf_listingscript>

<table width="100%" height="100%">

<tr class="line">
	<td style="height:33px;padding-left:8px" class="labellarge">
	<table><tr class="labellarge"><td style="font-size:18px"><cfoutput>#screentoplabel#</cfoutput></td></tr></table> 	
	</td>
</tr>

<tr>
	<td style="padding-left:10px;padding-right:10px;padding-bottom:10px">
	<cfinclude template="WorkOrderListingContent.cfm">
	</td>
</tr>

</table>