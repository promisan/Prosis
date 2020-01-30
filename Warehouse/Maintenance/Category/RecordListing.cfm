<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop jquery="yes" html="no">

<cf_divscroll>

<cfajaximport tags="cfdiv,cfform">

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 
	
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

<table width="97%" align="center">

<tr><td colspan="2" style="padding-top:4px">
	<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm">
</td>

</TABLE>

</cf_divscroll>