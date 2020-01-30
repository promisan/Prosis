<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *, (SELECT count(*) FROM Ref_Object WHERE ObjectUsage = L.ObjectUsage) as ObjectCount
	FROM      Ref_AllotmentVersion L
	ORDER BY  Mission,ListingOrder
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=570, height=460, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=570, height=460, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>

<table width="96%" cellpadding="0" cellspacing="0" align="center" class="navigation_table">

<tr class="labelmedium line">
	    <td width="30"></td>   
		<td>Code</td>		
		<td>Description</td>
		<td>Entity/tree</td>
		<td>Class</td>
		<td>Object Usage</td>		
		<td>Registered by</td>
	    <td>On</td>	
</tr>

<cfoutput query="SearchResult">
	<tr class="navigation_row line labelmedium">
		<td align="center" height="22" style="padding-top:5px">
		   <cf_img icon="edit" onclick="recordedit('#Code#')" navigation="yes">	
		</td>
		<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>			
		<td>#Description#</td>
		<td><cfif Mission eq "">any<cfelse>#Mission#</cfif></td>
		<td>#ProgramClass#</td>
		<td>#ObjectUsage# (#ObjectCount#)</td>			
		<td>#OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	</tr>	
</cfoutput>		

</table>

</cf_divscroll>
