
<cf_screentop html="No" jQuery="Yes">

<cf_listingscript>
<cf_dialogworkorder>

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" height="100%">

<tr>

	<td style="height:35;padding-left:8px" class="labellarge">
	
		<cfif status eq "pending">
			<cf_tl id="WorkOrder Pending shipment">
		<cfelse>
			<cf_tl id="Receive returns">
		</cfif>
		
	</td>
	
	<td height="10" align="right" style="padding-right:10px">
		<table>
			<tr>
			<td style="padding-left:10px;padding-right:7px" class="labelit"><cf_tl id="Lot">:</td>
			<td><input type="text" id="transactionlot" size="20" class="regularxl enterastab">
		   </td>
		   <td style="padding-left:5px">
		  		 <input type="button" 
		        	  name="Show" 
					  value="Filter"
					  class="button10g" 
					  style="width:90px;height:25px" 
					  onclick="ptoken.navigate('WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&transactionlot='+document.getElementById('transactionlot').value,'mymasterlist')">
		   </td>
		   </tr>
		</table>
	</td>
</tr>

<tr><td class="line" colspan="2"></td></tr>

<tr>
   <td colspan="2" height="100%" valign="top" style="padding-left:7px;padding-right:7px" id="mymasterlist">
	<cf_securediv style="height:100%" bind="url:WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#">
   </td>
</tr>

</table>

</cfoutput>