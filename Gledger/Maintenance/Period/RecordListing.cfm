<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Account Period Maintenance</TITLE></HEAD>

<body leftmargin="3" topmargin="3" rightmargin="1">

<cf_divscroll>

<table width="100%" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Account Period">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Period
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,id2) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 +"&ID2=" + id2, "Edit", "left=80, top=80, width=600, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<thead>
<tr class="line labelmedium">
    <td></td>
    <td>Period</td>
	<td>Description</td>
	<td>Year</td>
	<td>Reconciliation<br> future periods</td>
	<td>Status</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">

   	<tr class="navigation_row line labelmedium" style="height:24px">
	<td align="center" style="padding-top:2px;">
		  <cf_img icon="edit" navigation="yes" onclick="recordedit('#AccountPeriod#')">
	</td>
   	<td>#AccountPeriod#</td>
	<td>#Description#</td>
	<td>#AccountYear#</td>
	<td> <cfif Reconcile eq 1>Yes<cfelse>No</cfif></td>
	<td><cfif ActionStatus is "0">open<cfelse><b>closed</cfif></td>
	<td>#OfficerFirstName# #OfficerLastName#</td>
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</CFOUTPUT>
</tbody>

</table>

</cf_divscroll>
