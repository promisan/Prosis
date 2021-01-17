<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

	function recordadd(grp) {
		ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "AddWorkAction", "left=80, top=80, width= 7000, height=450, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
		ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditWorkAction", "left=80, top=80, width=700, height=450, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordpurge(id1) {
		if (confirm('Do you want to remove this action ?')) {
			ptoken.navigate('RecordPurge.cfm?id1='+id1,'detail');
		}
	}

</script>

</cfoutput> 
	
<tr>
	<td colspan="2">
		<cf_divscroll>
		<cf_securediv id="detail" bind="url:RecordListingDetail.cfm">
		</cf_divscroll>
	</td>
</tr>	

</table>

