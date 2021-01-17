<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop layout="webapp" 			  
			  html="No"			 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_incoterm 
	ORDER BY code
</cfquery>

<table width="100%" height="100%">

<cfset add          = "1">
<cfset Header       = "Incoterms">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function deditico(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

<table width="94%" align="center" class="navigation_table">

<tr class="line labelmedium2">
   
    <TD width="5%"></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>
  
</TR>

<cfoutput query="SearchResult">
 
    <TR class="navigation_row line labelmedium2"> 
	<TD align="center">
	    	<cf_img icon="edit" navigation="Yes" onclick="deditico('#Code#')">
	</TD>		
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
		
</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td></tr>

</table>

