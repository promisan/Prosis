<!--- Create Criteria string for query from data entered thru search form --->

<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_AssetAction	
	ORDER BY Created DESC
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		

<table width="94%" align="center" border="0"  cellspacing="0" cellpadding="0">

<cfoutput>

<script>

function recordadd(id1) {
      window.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, "AddAssetAction", "left=80, top=80, width=800, height=400, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
      wEditAssetAction = window.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAssetAction", "left=80, top=80, width=900, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium">   
	<TD></TD>
    <TD class="labelit" width="100">Code</TD>
	<TD class="labelit">Description</TD>
	<td class="labelit" align="center">Tab Icon</td>
	<TD class="labelit" align="center">Workflow</TD>
	<td class="labelit" align="center">Ope.</td>	   
	<td class="labelit">Officer</td>	
	<TD class="labelit" align="right">Entered</TD>	
</TR>

<cfoutput query="SearchResult">
	    
    <TR bgcolor="FFFFFF" class="line labelmedium navigation_row"> 	
	<td class="labelit line" align="center" height="20" style="padding-top:1px;">				
	       <cf_img  icon="open" navigation="Yes" onclick="recordedit('#Code#');">
	</td>
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<td align="center"><cfif trim(tabIcon) neq ""><img src="#SESSION.root#/Images/#tabIcon#" width="20" height="20" title="#tabIcon#"></cfif></td>
	<TD align="center"><cfif enableWorkflow eq "1">Yes<cfelse><b>No</b></cfif></TD>
	<td align="center"><cfif operational eq "1">Yes<cfelse><b>No</b></cfif></td>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD align="right">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	
    </TR>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>