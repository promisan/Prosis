
<!--- redirect to the receipts --->

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif URL.ID1 eq "Pending">

	<tr><td>
	<iframe src="#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptViewListing.cfm?mission=#url.mission#&warehouse=#url.warehouse#&id=STA&id1=pending" 
	    width="100%" 
		height="100%" 
		scrolling="no" 
		frameborder="0"></iframe>
	</td></tr>

<cfelse>

	<tr><td>
	<iframe src="#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptViewView.cfm?actionstatus=#url.actionstatus#&mission=#url.mission#&warehouse=#url.warehouse#&id=STA&id1=locate" 
	    width="100%" 
		height="100%" 
		scrolling="no" 
		frameborder="0"></iframe>
	</td></tr>

</cfif>

</table>

</cfoutput>