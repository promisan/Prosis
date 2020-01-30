<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Procurement Clause">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Clause
</cfquery>

<cfoutput>

<script>

function reloadForm(page) {
     window.location="RecordListing.cfm?Page=" + page; 
}
  
function recordadd(grp)
{
	w = #CLIENT.width# - 60;
	h = #CLIENT.height# - 120;
    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id)
{
	w = #CLIENT.width# - 60;
	h = #CLIENT.height# - 120;
    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1="+id, "Edit", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
<tr><td colspan="2">

	<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr>
	   
	    <td width="5%"></td>
	    <TD class="labelit">Code</TD>
		<TD class="labelit">Name</TD>
		<td class="labelit">Language</td>
		<td class="labelit">Operational</td>
		<TD class="labelit">Officer</TD>
	    <TD class="labelit">Entered</TD>
	  
	</TR>
	
	<tr><td colspan="7" height="1" class="linedotted"></td></tr>
	
		<cfoutput query="SearchResult">
		    
		    <TR class="navigation_row">
				<td align="center" style="padding-top:1px;">
					<cf_img icon="open" navigation="yes" onclick="recordedit('#Code#')">
				</td>
				<TD class="labelit">#Code#</TD>			  
				<TD class="labelit">#ClauseName#</TD>
				<td class="labelit">#LanguageCode#</td>
				<td class="labelit"><cfif operational eq "1"><b>Yes</b></cfif></td>
				<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
				<TD class="labelit">#DateFormat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
		
			<cfif currentrow neq recordcount>
			    <tr><td colspan="7" class="linedotted"></td></tr>
			</cfif>		
			
		</cfoutput>
	
	</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>