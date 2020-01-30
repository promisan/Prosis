
<!--- print content --->

<cf_systemscript>

<iframe name="printFrame" id="printFrame" width="0px" height="0px" frameborder="0" marginheight="0" marginwidth="0" scrolling="No"></iframe>
		
<cf_printcontent>		
	<cfinclude template="../../../../../Custom/BCN/Warehouse/Invoice/Invoice.cfm">
</cf_printcontent>

<table></table>

<cfoutput>
	<script>
		printDiv('printthis');
		<!--- doTheIframe('#SESSION.root#/Custom/BCN/Warehouse/Invoice/Invoice.cfm?batchId=#url.batchId#', '100%', '100%'); --->
	</script>
</cfoutput>