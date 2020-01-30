<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Contact 
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr style="height:20px;" class="line labelmedium">
	    <td></td>
		<td width="5%">&nbsp;</td>
	    <td>Code</td>
		<td>Description</td>	
		<td>Mask</td>	
		<td>Self-Service</td>		
		<td>Order</td>			
		<td>Officer</td>
	    <td>Entered</td>
	</tr>

<cfoutput query="SearchResult">
	<cfset row = currentrow>		
    <tr class="line navigation_row labelmedium" style="height:20px"> 
		<td></td>
		<td style="padding-top:4px">
			<cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">
		</td>		
		<td>#Code#</td>
		<td>#Description#</td>		
		<td>#CallSignMask#</td>
		<td><cfif SelfService eq "1">True<cfelse>False</cfif></td>
		<td>#ListingOrder#</td>		
		<td>#officerFirstName# #officerLastName#</td>		
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
</cfoutput>

</table>

</td>
</tr>

</table>

</cf_divscroll>