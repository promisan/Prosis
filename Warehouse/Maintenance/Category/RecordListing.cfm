<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop jquery="yes" html="no">
	
<cfset Page         = "0">
<cfset add          = "1">

<table width="97%" align="center" style="height:100%">

<tr><td style="height:10px">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>

<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=790, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, id1);
	}
	
	function recordpurge(id1) {
		if (confirm('Do you want to remove this category ?')) {
			ptoken.navigate('RecordPurge.cfm?id1='+id1, 'divDetail');
		}
	}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:4px" style="height:100%">
	<cf_divscroll>
		<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm">
	</cf_divscroll>
</td>

</TABLE>

