<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script>

	function recordadd(grp) {
		window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "AddContributionClass", "left=80, top=80, width=550, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
		window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditContributionClass", "left=80, top=80, width=550, height=300, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordpurge(id1) {
		if (confirm('Do you want to remove this contribution class ?')) {
			ColdFusion.navigate('RecordPurge.cfm?id1='+id1,'detail');
		}
	}

</script>


</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr>
	<td colspan="2">
		<cfdiv id="detail" bind="url:RecordListingDetail.cfm">
	</td>

</table>

</cf_divscroll>