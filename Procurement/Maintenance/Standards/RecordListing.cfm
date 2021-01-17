<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Standard
	ORDER BY code
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Procurement Standards">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=580, height=400, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=400, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>

<table width="94%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
   
	<td width="5%">&nbsp;</td>
    <td>Code</td>
	<td>Description</td>
	<td>Expiration</td>
	<td>Enabled</td>
	<td>Att.</td>
	<td>Officer</td>
    <td>Entered</td>
  
</TR>

	<cfoutput query="SearchResult">    
		
	    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"  class="navigation_row labelmedium2 line"> 
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
			
	</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

