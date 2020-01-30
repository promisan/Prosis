<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Action 
	ORDER BY ActionSource
</cfquery>

<cfoutput>
	
	<script>
		
		function recordadd(grp) {
		    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height= 330, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height= 330, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>	

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelheader linedotted">
    <td>Area</td>   
	<td></td>
    <td>Code</td>
	<td>Description</td>	
	<td>Class</td>
	<td>Workflow</td>
	<td>Mode</td>
	<td>Op.</td>
	<td>Officer</td>
    <td>Entered</td>
</tr>

<cfset prior = "">

<cfoutput query="SearchResult" group="ActionSource">

	<tr><td style="height:15px"></td></tr>

	<cfoutput>
	        
		<tr class="navigation_row linedotted">
		
			<td class="labelmedium" style="height:19px">
			<cfif ActionSource neq prior>
				<font color="6688aa">#ActionSource#
			</cfif>
			</td>
			
			<td width="30" align="center" style="padding-top:1px">
		 		<cf_img icon="edit" navigation="Yes" onclick="recordedit('#ActionCode#')">
			</td>		
			
			<td class="cellcontent">#ActionCode#</td>
			<td class="cellcontent">#Description#</td>
			<td class="cellcontent">#ActionClass#</td>
			<td class="cellcontent">#EntityClass#</td>
			<td class="cellcontent">
				<cfif ModeEffective eq "0">Validate<cfelseif ModeEffective eq "1">Allow overlap<cfelseif ModeEffective eq "9">Disable Edit</cfif>
			</td>
			<td class="cellcontent"><cfif operational eq "1">Yes<cfelse>No</cfif></td>
			<td class="cellcontent">#OfficerFirstName# #OfficerLastName#</td>
			<td class="cellcontent">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
		<cfset prior = actionsource>
		
	</cfoutput>	

</cfoutput>

</table>

</cf_divscroll>