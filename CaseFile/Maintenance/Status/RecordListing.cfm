<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Status
	ORDER BY StatusClass
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header       = "Case file status">
<tr style="height:10px"><td><cfinclude template = "../HeaderCaseFile.cfm"></td></tr>
 
<cfoutput>
 
<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function statusedit(id1,id2) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1+"&ID2="+id2, "Edit", "left=80, top=80, width= 550, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>
	
<table width="97%" align="center" class="navigation_table" >
	
	<tr class="labelmedium2 fixrow line">			   
	    <td width="5%"></td>
	    <td><cf_tl id="Class"></td>
	    <td><cf_tl id="Code"></td>	
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>			  
	</tr>
		
	<cfoutput query="SearchResult">
			<tr class="navigation_row labelmedium2 line">
				<td align="center">
					<cf_img icon="open" navigation="yes" onclick="statusedit('#StatusClass#','#Status#')">
				</td>	
				<td>#StatusClass#</td>
				<td>#Status#</td>	
				<td>#Description#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>				
		    </tr>	 
	</cfoutput>
	
</table>

</cf_divscroll>

</td></tr>

</table>

