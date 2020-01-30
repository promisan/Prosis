<!--- Create Criteria string for query from data entered thru search form --->

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<HTML><HEAD><TITLE>Job Category</TITLE></HEAD>

<cfset add          = "1">
<cfset Header       = "Condition">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script>

function recordadd(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {     
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<body leftmargin="2"
      topmargin="2"
      rightmargin="2"
      bottommargin="2">

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_JobCategory
	ORDER BY code
</cfquery>

<cf_divscroll>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr class="line labelmedium">   
    <TD width="5%"></TD>
    <TD>Code</TD>
	<TD>Description</TD>
	<TD>Officer</TD>
	<TD>Entered</TD>  
</TR>

<cfoutput query="SearchResult">
   
    <TR class="labelmedium linedotted navigation_row">
	<TD align="center" style="padding-top:1px;">
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</TD>		
	<TD><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
	<TD>#Description#</TD>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
		
</cfoutput>

</TABLE>

</cf_divscroll>
