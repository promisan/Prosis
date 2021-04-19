<cfparam name="url.WorkOrderId"    default="">
<cfparam name="url.Mission"        default="">
<cfparam name="URL.id1"			   default="HSA-PO-1550">

<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">
<cfset tmp = "WorkOrder/Application/WorkOrder/Invoice/WorkOrderInvoiceData.cfm"> 
<cfset URL.id1 = url.workorderid>

<cfoutput>	

<table border="0" align="center" cellpadding="0"  cellspacing="0" width="100%" >
		<td>
	<input type="button" 
	     id="glprocess" 
		 class="button10g"
		 style="width:100px"
		 value="print"
		 onclick="ptoken.navigate('../../../../Tools/Mail/MailPrepare.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#','bshow')">

		</td>
	</tr>
	<tr>
		<td id="bshow"></td>
	<tr>

</table> 

	
<!--- 	<script>
<cfinclude template="#SESSION.root#/Tools/Mail/MailPrepare.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#">
		ColdFusion.navigate('#SESSION.root#/Tools/Mail/MailPrepare1.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#');

	</script> --->

	
</cfoutput>			