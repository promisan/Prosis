<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_TextArea
	Order  By TextAreaDomain, ListingOrder 
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Text Areas">
<cfinclude template = "../HeaderRoster.cfm"> 
 
<cfoutput>
 
<script>

function recordadd(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=540, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=540, height=400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	
	
</cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelheader line">
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td></td>
		<td>Sort</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult" group="TextAreaDomain">
	
	   <tr><td height="1" colspan="6" style="height:40px" class="labellarge">&nbsp;#TextAreaDomain#</b></td></tr>	
  
	   <cfoutput>
		    <tr class="labelmedium linedotted navigation_row" style="height:22px">
				<td width="5%" align="center">
					  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
				</td>		
				<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td><a href="javascript:recordedit('#Code#')">#Description#</a></td>
				<td width="30%">#Explanation#</td>
				<td>#ListingOrder#</td>
				<td>#OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>

		</cfoutput>
	
	</cfoutput>

</table>

</cf_divscroll>
