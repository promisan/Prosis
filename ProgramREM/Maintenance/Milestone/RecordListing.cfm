<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cf_PreventCache>

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>


<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_subPeriod
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 260, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>


<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
	<thead>
		<tr class="labelmedium2 line">
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
	   
		<tr class="navigation_row labelmedium2 line">
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

</td>
</tr>
</table>