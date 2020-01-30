<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_UoM
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0" >

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
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">
	
	<table align="center" width="97%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<tr>
	    <td align="left" class="labelit"></td>
	    <td align="left" class="labelit">Code</td>
		<td align="left" class="labelit">Description</td>
		<td align="left" class="labelit">Order</td>
		<td align="left" class="labelit">Officer</td>
	    <td align="left" class="labelit">Entered</td>
	</tr>
	
	<cfoutput query="SearchResult">
	 		
	    <tr class="navigation_row"> 
			<td align="center" class="line" style="padding-left:4px;padding-top:0px;padding-right:4px">
			   <cf_img icon="edit" navigation="yes" onclick="recordedit('#Code#');">
			</td>
			<td class="line labelit">#Code#</td>
			<td class="line labelit">#Description#</td>
			<td class="line labelit">#ListingOrder#</td>
			<td class="line labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="line labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
	    </tr>
			
	</CFOUTPUT>
	
	</table>
	
	</td>
</tr>

</table>

</cf_divscroll>