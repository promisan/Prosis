<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cf_divscroll>

<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_AreaGLedger
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%"  border="0" align="center" bordercolor="silver" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddAreaGLedger", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAreaGLedger", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="labelmedium line">
    <TD></TD> 
    <TD><cf_tl id="Code"></TD>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Listing Order"></td>
    <TD><cf_tl id="Entered"></TD>
  
</TR>

<cfoutput query="SearchResult">
    
    <TR class="labelmedium line navigation_row"> 
	<td height="20" width="5%" align="center" style="padding-top:3px;">
		<cf_img icon="open" onclick="recordedit('#Area#');" navigation="Yes">
	</td>		
	<TD>#Area#</TD>
	<TD>#Description#</TD>
	<TD align="center">#listingOrder#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>    

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>