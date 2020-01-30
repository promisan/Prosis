<cfset url.location = form.location>
<cfset url.itemno   = form.ItemNo>
<cfset url.uom      = form.UoM>
<cfset url.tratpe   = "2">

<cfinclude template="TransactionLogSheetPDFLoad.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('../Transaction/TransactionLogSheetPDF.cfm?warehouse=#url.warehouse#&location=#url.location#','boxpdf');
	</script>
</cfoutput>

<!--- show the detail lines --->
<cfinclude template="TransactionDetailLines.cfm">