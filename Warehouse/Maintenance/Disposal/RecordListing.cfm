<!--- Create Criteria string for query from data entered thru search form --->


<cfset Page         = "0">
<cfset add          = "1">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Disposal
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
       ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>
	
	<table width="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line fixrow">
	    <TD align="left"></TD>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>
		<TD><cf_tl id="Officer"></TD>
	    <TD><cf_tl id="Entered"></TD>
	</TR>
	
	<cfoutput query="SearchResult">
	    
	    <TR class="navigation_row labelmedium2 line"> 
		<td align="center" style="padding-top:1px">
		   <cf_img icon="open" navigation="yes" onclick="recordedit('#Code#');">
		</td>
		<TD class="labelit"><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
		<TD class="labelit">#Description#</TD>
		<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
		<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
		
	</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

