
<HTML><HEAD><TITLE>Event category</TITLE></HEAD>

<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	R.*,
				ISNULL((SELECT ISNULL(COUNT(*),0) FROM Ref_ReviewClassOwner WHERE Code = R.Code),0) as CountOwners
		FROM 	Ref_ReviewClass R
</cfquery>

<cf_divscroll>

<cfset Header = "Review class">
<cfinclude template="../HeaderRoster.cfm">  
 
<cfoutput>
 
<script language = "JavaScript">

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 600, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 600, height= 600, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable formpadding navigation_table">

<thead>
	<tr>
	    <td align="left"></td>
	    <td>Code</td>
		<td>Description</td>
		<td align="center">Operational</td>
		<td align="center">Owners</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">

    <tr class="navigation_row"> 
		<td width="5%" align="center">
			<cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
		</td>		
		<td>#Code#</td>
		<td>#Description#</td>
		<td align="center"><cfif #Operational# eq "1">Yes</cfif></td>
		<td align="center">#CountOwners#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>
</tbody>
  
</table>


</cf_divscroll>
