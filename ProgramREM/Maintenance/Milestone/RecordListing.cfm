<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>

<HTML>

<HEAD>

<TITLE>Program Sector</TITLE>
	
</HEAD>


<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_subPeriod
</cfquery>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>


<cf_divscroll>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Short</td>
		<td>Order</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
   
	<tr class="navigation_row">
	    <td align="center" width="5%">
			<cf_img icon="open" onclick="recordedit('#Subperiod#')" navigation="yes">
		</td>	
		<td height="20"><a href="javascript:recordedit('#Subperiod#')">#Subperiod#</a></td>
		<td>#Description#</td>
		<td>#DescriptionShort#</td>
		<td>#DisplayOrder#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>
</tbody>

</table>

</cf_divscroll>


</BODY></HTML>