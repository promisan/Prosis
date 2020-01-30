<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Terms maintenance</TITLE></HEAD>

<body leftmargin="3" topmargin="3" rightmargin="3" bottommargin="3">

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Terms
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Payment Terms">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<SCRIPT LANGUAGE = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Description</font></td>
		<td>Net days</font></td>
		<td>Discount days</font></td>
		<td>Percentage</font></td>
		<td>Officer</font></td>
	    <td>Entered</font></td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
    <tr class="navigation_row">
		<td align="center" style="padding-top:1px;width:30">
	 	   <cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">
		</td>
		<td>#Description#</a></td>
		<td>#NumberFormat(Paymentdays,'____')#</td>
		<td>#NumberFormat(Discountdays,'____')#</td>
		<td>#NumberFormat(Discount*100,'____._')#%</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>
</tbody>

</table>

</cf_divscroll>

</BODY></HTML>