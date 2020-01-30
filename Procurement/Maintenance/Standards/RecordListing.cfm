<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Standard
	ORDER BY code
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Procurement Standards">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=580, height=440, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=680, height=440, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td colspan="8" class="linedotted"></td></tr>

<tr>
   
	<td width="5%">&nbsp;</td>
    <td class="labelit">Code</td>
	<td class="labelit">Description</td>
	<td class="labelit">Expiration</td>
	<td class="labelit">Enabled</td>
	<td class="labelit">Att.</td>
	<td class="labelit">Officer</td>
    <td class="labelit">Entered</td>
  
</TR>

<tr><td colspan="8" class="linedotted"></td></tr>

<cfoutput query="SearchResult">    
	
    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"  class="navigation_row"> 
		<TD align="center" style="padding-top:1px">
			<cf_img navigation="Yes" icon="open" onclick="recordedit('#Code#')">
		</TD>		
		<TD class="labelit"><a href="javascript:recordedit('#Code#')">#Code#</a></TD>
		<TD class="labelit">#Description#</TD>
		<td class="labelit">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
		<td class="labelit"><cfif Operational eq "0">No<cfelse>Yes</cfif></td>		
		
		    <cf_filelibraryCheck			    	
    					DocumentPath  = "Standards"
						SubDirectory  = "#Code#"
						Filter="">	
						
		<td>
		
		<cfif Files gte "1">
		
			<img src="#SESSION.root#/images/pdf_small.gif" alt="" border="0">
		
		</cfif>
		
		</td>				
				
		<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
		<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		
    </TR>
	
	<tr><td colspan="8" class="linedotted"></td></tr>
	
</CFOUTPUT>

</TABLE>

</td>

</TABLE>

</cf_divscroll>