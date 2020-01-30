
<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cf_listingscript>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">

<tr>
	<td style="height:35;padding-left:8px" class="labellarge">	
	<cfoutput>#screentoplabel#</cfoutput>		
	</td>
	
	<td height="10" align="right" style="padding-right:10px">
		<table>
			<tr>
			<td style="padding-left:10px;padding-right:7px" class="labelit">Lot:</td>
			<td><input type="text" id="transactionlot" size="20" class="regularxl enterastab">
		   </td>
		   <td style="padding-left:5px">
		   <input type="button" 
		          name="Show" 
				  value="Filter"
				  class="button10s" 
				  style="width:90px;height:25px" 
				  onclick="ColdFusion.navigate('WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#&transactionlot='+document.getElementById('transactionlot').value,'mymasterlist')">
		   </td>
		   </tr>
		</table>
	</td>
</tr>

<tr><td class="line" colspan="2"></td></tr>

<tr>
   <td colspan="2" height="100%" valign="top" style="padding-left:7px;padding-right:7px" id="mymasterlist">
	<cfdiv style="height:100%" bind="url:WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#">
   </td>
</tr>

</table>
</cfoutput>


