<!--- Create Criteria string for query from data entered thru search form --->
<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="95%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=", "AddBusinessRule", "left=80, top=80, width=500, height=475, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditBusinessRule", "left=80, top=80, width=500, height=475, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cfdiv id="rulesListing" bind="url:RecordListingDetail.cfm?idmenu=#url.idmenu#">

</td>

</TABLE>

</cf_divscroll>