<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_AddressZone 
	ORDER BY mission, code
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=490, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

	<table width="95%" align="center" class="navigation_table">
	
	<tr class="line labelmedium2">
	
	    <td></td>
		<td width="5%">&nbsp;</td>
	    <td>Code</td>
		<td>Description</td>	
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult" group="mission">
	
	   <tr class="line"><td colspan="6" style="height:40px;font-size:20px" class="labelmedium">#mission#</td></tr>
	  
	   <cfoutput>
	
		<cfset row = currentrow>		
	    <tr class="labelmedium2 line navigation_row"> 
			<td></td>
			<td height="20" style="padding-left:4px"><cf_img icon="open" navigation="Yes" onclick="recordedit('#code#')"></td>		
			<td>#Code#</td>
			<td>#Description#</td>		
			<td>#officerFirstName# #officerLastName#</td>		
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
	
		</cfoutput>
		
		<tr><td height="10"></td></tr>
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>

</td>
</tr>

</table>
