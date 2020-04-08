<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Make
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">

<table height="100%" width="99%" align="center" cellspacing="0" cellpadding="0">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 220, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput> 
	
<tr><td valign="top">

	<cf_divscroll>
	
	<table align="center" width="97%" class="navigation_table">
	
	<tr class="fixrow labelmedium line">
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>
			
	<cfoutput query="SearchResult">
	 		
	    <tr class="navigation_row labelmedium line" style="height:20px"> 
			<td align="center" style="padding-top:2px">
			   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>			
	    </tr>
			
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>
	
	</td>
</tr>

</table>

