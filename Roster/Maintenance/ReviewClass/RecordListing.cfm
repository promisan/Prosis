
<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	R.*,
				ISNULL((SELECT ISNULL(COUNT(*),0) FROM Ref_ReviewClassOwner WHERE Code = R.Code),0) as CountOwners
		FROM 	Ref_ReviewClass R
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Header = "Review class">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>
	 
	<cfoutput>
	 
	<script language = "JavaScript">
	
	function recordadd(grp) {
	          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 600, height= 600, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
	          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 600, height= 600, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	</script>	
	
	</cfoutput>

<tr><td style="height:100%">
	
	<cf_divscroll>
	
	<table width="96%" align="center" class="formpadding navigation_table">
	
		<tr class="line labelmedium2">
		    <td align="left"></td>
		    <td>Code</td>
			<td>Description</td>
			<td align="center">Operational</td>
			<td align="center">Owners</td>
			<td>Officer</td>
		    <td>Entered</td>
		</tr>
	
		<cfoutput query="SearchResult">
		
		    <tr class="navigation_row line labelmedium2"> 
				<td width="5%" align="center">
					<cf_img icon="select" onclick="recordedit('#Code#')" navigation="Yes">
				</td>		
				<td>#Code#</td>
				<td>#Description#</td>
				<td align="center"><cfif #Operational# eq "1">Yes</cfif></td>
				<td align="center">#CountOwners#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
			
		</cfoutput>
		
	</table>
	
	</cf_divscroll>
	
</td></tr>  

</table>

