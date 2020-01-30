
<cfoutput>

<script language="JavaScript">

	if (confirm("Remove Record ?")) {
	ColdFusion.navigate('#SESSION.root#/warehouse/maintenance/warehouselocation/List.cfm?action=delete&access=ALL&systemfunctionid=#url.systemfunctionid#&Warehouse=#URL.Warehouse#&ID2=#URL.id2#','f#url.warehouse#_list')
	}
	
</script>

</cfoutput>
