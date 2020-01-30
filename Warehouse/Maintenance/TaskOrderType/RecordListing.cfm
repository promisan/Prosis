<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_TaskType
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="98%"  border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0"  >  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTaskOrderType", "left=80, top=80, width= 600, height= 450, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTaskOrderType", "left=80, top=80, width= 800, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">
	
	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
		
		<tr><td colspan="6" height="30" class="labelit">
		
			The type defined for shipping of the taskorder : by Internal facility or External contractor. For each entity defined
		
		</td></tr>
		
		<tr class="labelit">
		    <TD></TD> 
		    <TD class="labelit">Code</TD>
			<td class="labelit">Description</td>
			<TD class="labelit">Officer</TD>
		    <TD class="labelit">Entered</TD>  
		</TR>
		
		<tr><td height="1" colspan="6" class="line"></td></tr>	
		
		<cfoutput query="SearchResult">
		    
			
		    <TR class="labelmedium navigation_row"> 
				<td height="20" width="5%" align="center" style="padding-top:1px">
				  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
				</td>		
				<TD class="labelit">#Code#</TD>
				<TD class="labelit">#Description#</TD>
				<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
				<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
		    
			<tr><td class="line" colspan="6"></td></tr>	
		
		</CFOUTPUT>
		
	</TABLE>
		
	</td>
	</tr>

</TABLE>

</cf_divscroll>