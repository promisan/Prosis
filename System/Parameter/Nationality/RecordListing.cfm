<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Nationality</TITLE></HEAD>

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM  Ref_Nation
  ORDER BY Continent
</cfquery>

<cf_divscroll>

<cfset Page = "0">
<cfset Header = "Nations">
<cfinclude template="../HeaderParameter.cfm"> 
 
<cfoutput> 

<script>

function reloadForm(page){
	window.location="RecordListing.cfm?Page=" + page; 
}

function recordadd(grp){
    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>
	
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr class="line">
    <TD align="center" class="labelit">Area</TD>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Name</TD>
	<td></td>
    <TD class="labelit">Code</TD>
	<TD class="labelit">Name</TD>
	<td></td>
	<TD class="labelit">Code</TD>
	<TD class="labelit">Name</TD>
	
</TR>

<cfoutput query="SearchResult" group="Continent">

<cfif continent neq "">
<tr><td colspan="7" class="labelit line" style="font-size:23px;padding-left:4px;height:45">#Continent#</font></td></tr>
</cfif>

<cfset cnt  = "0">

<cfoutput>
   
    <cfset cnt = cnt+1>
    <cfif cnt eq "1">
	<TR bgcolor="white">
	</cfif>
	
    <td align="center" style="height:16px;padding-top:2px">
	  <cf_img icon="edit" onclick="recordedit('#Code#')">	 
	</td>		
	<TD style="padding-left:2px" class="labelit"><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
	<TD style="padding-left:2px" class="labelit">#name#</TD>	
	<cfif cnt eq "3">
    </TR>
	<tr><td height="1" colspan="9" class="line"></td></tr>
	<cfset cnt = 0>
	</cfif>
	
</CFOUTPUT>

</cfoutput>

</TABLE>

</cf_divscroll>

</BODY></HTML>

