<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_TextArea
	Order  By TextAreaDomain, ListingOrder 
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfset Header       = "Text Areas">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
<cfoutput>
 
<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=540, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=540, height=400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	
	
</cfoutput>


<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

	<tr class="labelmedium2 line">
	    <td></td> 
	    <td>Code</td>
		<td>Description</td>
		<td>Memo</td>
		<td>Rw</td>
		<td>St</td>		
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult" group="TextAreaDomain">
	
	   <tr><td height="1" colspan="7" class="labellarge" style="height:40px">#TextAreaDomain#</b></td></tr>	
  
	   <cfoutput>
		    <tr class="labelmedium linedotted navigation_row">
				<td width="3%" style="padding-top:2px" align="center">
					  <cf_img icon="select" onclick="recordedit('#Code#')" navigation="Yes">
				</td>		
				<td style="padding-right:5px">#Code#</td>
				<td>#Description#</td>
				<td width="60%">#Explanation#</td>
				<td>#NoRows#</td>
				<td align="center">#ListingOrder#</td>				
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>

		</cfoutput>
	
	</cfoutput>
		
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>

