<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"><HTML>
<HEAD><TITLE>Tax Maintenance</TITLE></HEAD>

<body leftmargin="3" topmargin="3" rightmargin="1">

<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Tax
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Tax Code">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=500, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id, "Edit", "left=80, top=80, width=500, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>


<table width="94%" class="navigation_table" align="center" cellspacing="0" cellpadding="0" align="center">

<tr class="labelmedium line">
    <td width="40" align="left"></td>
    <td align="left">Code</td>
	<td width="25%" align="left">Description</td>
	<td align="left">Percentage</td>
	<td align="left">Calculation</td>
	<td align="left">Rounding</td>
	<td align="left">Account Paid</td>
	<td align="left">Account Received</td>
	<td align="left">Officer</td>
    <td align="left">Entered</td>
</tr>

<cfset i = 0>
<cfoutput query="SearchResult">
    
    <tr class="navigation_row labelmedium line">
	<td align="center" style="padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#TaxCode#')">
	</td>
	<td height="23">#TaxCode#</td>
	<td>#Description#</td>
	<td style="padding-right:5px" align="right">#NumberFormat(Percentage*100,'.___')#%</td>
	<td>#TaxCalculation#</td>
	<td><cfif TaxRounding eq "1">Yes<cfelse>No</cfif></td>
	<td>#GLAccountPaid#</td>
	<td>#GLAccountreceived#</td>
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>

</table>

</cf_divscroll>
