
<cfoutput>

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">
	
	   window.location="ReceiptViewView.cfm?time=#now()#&Period=" + parent.window.receipt.PeriodSelect.value + 
	                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#"
	</script>

<cfelse>

	<script language="JavaScript">
	
	   window.location="ReceiptViewListing.cfm?time=#now()#&Period=" + parent.window.receipt.PeriodSelect.value + 
	                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#"
	</script>

</cfif>

</cfoutput>

