<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfquery name="SearchResult"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT count(*) FROM Journal WHERE Speedtype = S.Speedtype) as Used
	FROM   Ref_Speedtype S
</cfquery>

<cfset add          = "1">
<cfset Header       = "transaction Speed type">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=890, height=620, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id) {
    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id, "Edit", "left=80, top=80, width=890, height=620, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="96%" align="center" cellspacing="0" class="navigation_table" cellpadding="0" align="center">

<thead>
	<tr class="labelmedium">
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>Used</td>
		<td>Vendor tree</td>
		<td>Cost center</td>
		<td>Tax Code</td>
		<td>Accounts</td>		
	    <td>Entered</td>
	</tr>
</thead>

<cfset i = 0>

<tbody>

<tr><td colspan="9" style="height:40px" class="labelmedium linedotted">Journal speedtypes are meant to assign to a your in order to control and ease manual entry interface</td></tr>
<cfoutput query="SearchResult">
	
	<cfquery name="Parent"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_SpeedTypeParent
		WHERE Speedtype = '#speedtype#'
	</cfquery>	
    
    <tr class="navigation_row labelmedium line">
	<td align="center" style="width:40">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Speedtype#')">
	</td>
	
	<td>#Speedtype#</td>
	<td>#Description#</td>
	<td>#Used#</td>
	<td>#Institutiontree#</td>
	<td><cfif CostCenter eq "1">Yes<cfelse>No</cfif></td>
	<td><cfif TaxCode eq "1">Yes<cfelse>No</cfif></td>
	<td><cfloop query="Parent"><cfif currentrow neq "1">,</cfif>#AccountParent#</cfloop></td>	
	<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>
</tbody>

</table>


</cf_divscroll>