<cf_divscroll>

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*,
			(SELECT Description FROM Ref_TransactionClass WHERE Code = T.TransactionClass) as TransactionClassDescription,
			(SELECT Description FROM Ref_AreaGLedger WHERE Area = T.Area) as AreaDescription
	FROM 	Ref_TransactionType T
</cfquery>

<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%"  align="center">  

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddTransactionType", "left=80, top=80, width= 590, height= 285, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditTransactionType", "left=80, top=80, width= 590, height= 285, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">
	
	<table width="96%" align="center" class="formpadding navigation_table">
	
	<tr class="labelmedium2 fixrow line">
	    <TD></TD> 
	    <TD>Code</TD>
		<td>Description</td>
		<td>Class</td>
		<td>Area</td>
		<td>Report template</td>
	    <TD>Entered</TD>  
	</TR>
		
	<cfoutput query="SearchResult">
	
	    <TR class="navigation_row labelmedium2 line" bgcolor="FFFFFF"> 
			<td height="20" width="5%" align="center">
			  <cf_img icon="open" onclick="recordedit('#TransactionType#');">
			</td>		
			<TD>#TransactionType#</TD>
			<TD>#Description#</TD>
			<TD>#TransactionClassDescription#</TD>
			<TD>#AreaDescription#</TD>
			<td>#ReportTemplate#</td>
			<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
	
	</CFOUTPUT>
	
	</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>