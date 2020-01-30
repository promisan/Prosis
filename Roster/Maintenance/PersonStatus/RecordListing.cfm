
<HTML><HEAD><TITLE>Person Status</TITLE></HEAD>

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PersonStatus
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Candidate Status">
<cfinclude template = "../HeaderRoster.cfm"> 

<cfoutput>
  
<script LANGUAGE = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td style="cursor: pointer;"><cf_UIToolTip tooltip="Color in roster searches">Color</cf_UIToolTip></td>
		<td style="cursor: pointer;"><cf_UIToolTip tooltip="Hide Candidate in roster searches">Hide</cf_UIToolTip></td>
		<td>Officer</td>
	    <td align="right">Entered&nbsp;</td>  
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
		<tr class="navigation_row">
			<td width="5%" align="center">
				  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
			</td>		
			<td>#Code#</td>
			<td><a href="javascript:recordedit('#Code#')">#Description#</a></td>
			<td bgcolor="#InterfaceColor#">&nbsp;#InterfaceColor#</td>
			<td><cfif RosterHide eq "1">Yes<cfelse>No</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#&nbsp;</td>
	    </tr>
	</cfoutput>
</tbody>

</table>

</cf_divscroll>

</BODY></HTML>