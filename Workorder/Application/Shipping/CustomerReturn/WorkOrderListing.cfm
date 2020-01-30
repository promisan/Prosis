
<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cf_listingscript>

<cfoutput>

	<table width="100%" cellspacing="0" cellpadding="0" height="100%">
				
		<tr class="labelmedium">
		   <td colspan="2" height="100%" valign="top" style="padding-top:5px;padding-left:7px;padding-right:7px" id="mymasterlist">
		      
		   The return process is
		   Search and Select a customer that has one or more shippings<br>
		   <br>
		   Open Dialog<br>
		   	Show all items shipped over time and their total (Item/UoM) and then expand on the workorder/shipping
				workorderline
				warehouse/location
				quantity					
			<br>
			Entry the quantity to be return and process.<br>
			WorkOrder will show for credit note under [Credit Note]<br>
			 
			<!--- <cfdiv style="height:100%" bind="url:WorkOrderListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&Status=#url.status#">
			--->
		   </td>
		</tr>
	
	</table>
	
</cfoutput>


