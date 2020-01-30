
<cfoutput>

	<script language="JavaScript">
		 
	   window.location="InvoiceViewView.cfm?time=#now()#&Period=" + parent.document.getElementById('PeriodSelect').value + 
	                       "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#"
	</script>

</cfoutput>

