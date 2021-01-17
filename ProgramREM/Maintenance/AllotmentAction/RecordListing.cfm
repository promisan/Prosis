<cfquery name="qAllotmentAction"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentAction L
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "0">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=500, top=300, width=600, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<tr><td>

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">

	<tr class="labelmedium2 line fixrow">
	    <td width="30"></td>   
		<td>Code</td>
		<td>Entity Class</td>
		<td>Description</td>
		<td>Registered by</td>
	    <td>Date</td>	
	</tr>

	<cfoutput query="qAllotmentAction">
	      
		<tr class="navigation_row labelmedium2 line">
			
			<td align="center" height="22" width="25" style="padding-top:2px" >
			   <cf_img navigation="Yes" icon="select" onclick="recordedit('#Code#')">	
			</td>
			<td>#Code#</td>
			<td>#EntityClass#</td>
			<td>#Description#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
		</tr>
		
	</cfoutput>		

	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>
