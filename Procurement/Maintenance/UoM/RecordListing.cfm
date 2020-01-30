<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_UoM 
ORDER BY code
</cfquery>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
 
<cfoutput>
 
<script>

function reloadForm(page){
     window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp){
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1){
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:4px">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr>
    <TD class="labelit" width="5%">&nbsp;</TD>
    <TD class="labelit" width="80">Code</TD>
	<TD class="labelit" width="50%">Description</TD>
	<td class="labelit" align="center">Default</td>
	<TD class="labelit">Officer</TD>
    <TD class="labelit">Entered</TD>
</TR>

<tr><td height="1" colspan="10" class="linedotted"></td></tr>

<cfoutput query="SearchResult">

    <TR class="navigation_row"> 
	<TD style="padding-top:1px;" align="center">
		 <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</TD>			
	<TD class="labelit">#Code#</TD>
	<TD class="labelit">#Description#</TD>
	<td class="labelit" align="center"><cfif fieldDefault eq 0>No<cfelse><b>Yes</b></cfif></td>
	<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
	<tr><td height="1" colspan="10" class="linedotted"></td></tr>
		
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>


</BODY></HTML>
