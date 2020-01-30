<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Incoterms</TITLE></HEAD>

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_incoterm 
	ORDER BY code
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function deditico(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Condition">
<cfinclude template = "../HeaderMaintain.cfm"> 


<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr>
   
    <TD class="labelit" width="5%"></TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Description</TD>
	<TD class="labelit">Officer</TD>
    <TD class="labelit">Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
 
    <TR class="navigation_row"> 
	<TD class="linedotted" align="center">
	    	<cf_img icon="edit" navigation="Yes" onclick="deditico('#Code#')">
	</TD>		
	<TD class="labelit linedotted">#Code#</TD>
	<TD class="labelit linedotted">#Description#</TD>
	<TD class="labelit linedotted">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit linedotted">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
		
</CFOUTPUT>

<tr><td height="1" colspan="5" class="linedotted"></td></tr>

</TABLE>

</cf_divscroll>

