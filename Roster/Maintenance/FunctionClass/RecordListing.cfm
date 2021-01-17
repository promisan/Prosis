
<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_FunctionClass
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">
	
	<cfset Page         = "0">
	<cfset add          = "1">
	<cfset Header       = "Functional title Class">
	<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

	<cfoutput>
	
	<script language = "JavaScript">
	
	function recordadd(grp) {
	          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=550, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>

	<tr><td>
	
		<cf_divscroll>

		<table width="97%" align="center" class="navigation_table">
		
			<tr class="labelmedium2 line">
			    <td></td>
			    <td>Class</td>
				<td>Owner</td>	
			    <td>Entered</td>  
			</tr>
		
			<cfoutput query="SearchResult">
				<tr class="navigation_row labelmedium2 line">
					<td width="5%" align="center">
					<cfif FunctionClass neq "Standard">
					   <cf_img icon="open" onclick="recordedit('#FunctionClass#')" navigation="Yes">
					</cfif>			  
					</td>	
					<td><a href="javascript:recordedit('#FunctionClass#')">#FunctionClass#</a></td>
					<td>#Owner#</td>	
					<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			    </tr>
			</cfoutput>
								  
		</table>
		
		</cf_divscroll>	
		
	</td>
</tr>		
