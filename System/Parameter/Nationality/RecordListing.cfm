<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM  Ref_Nation
  ORDER BY Continent
</cfquery>

<cfset Page = "0">
<cfset Header = "Nations">
 
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

<table style="height:100%;width:100%">
<tr><td>
<cfinclude template="../HeaderParameter.cfm"> 
</td></tr>

<tr><td style="height:100%">

<cf_divscroll>
	
	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr class="line fixrow labelmedium">
	    <TD align="center">Area</TD>
	    <TD>Code</TD>
		<TD>Name</TD>
		<td></td>
	    <TD>Code</TD>
		<TD>Name</TD>
		<td></td>
		<TD>Code</TD>
		<TD>Name</TD>
		
	</TR>
	
	<cfoutput query="SearchResult" group="Continent">
	
	<cfif continent neq "">
	<tr class="fixrow2"><td colspan="7" class="labelit line" style="font-size:23px;padding-left:4px;height:45">#Continent#</font></td></tr>
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

</td></tr>
</table>

