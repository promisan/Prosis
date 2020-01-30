
<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_condition 
	ORDER BY code
</cfquery>

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfset add          = "1">
<cfset Header       = "Condition">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<tr><td colspan="2">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td colspan="5" height="1" class="linedotted"></td></tr>
<tr>
   
    <TD class="labelit" width="5%">&nbsp;</TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Description</TD>
	<TD class="labelit">Officer</TD>
    <TD class="labelit">Entered</TD>
  
</TR>

<tr><td colspan="5" height="1" class="linedotted"></td></tr>

<cfoutput query="SearchResult">
	
    <TR class="navigation_row"> 
	<TD style="padding-top:1px;" align="center">
		<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</TD>		
	<TD class="labelit">#Code#</TD>
	<TD class="labelit">#Description#</TD>
	<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit" >#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	<tr><td colspan="5" height="1" class="linedotted"></td></tr>    
	
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>
