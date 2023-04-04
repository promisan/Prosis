<!--- Create Criteria string for query from data entered thru search form --->


<cf_Recordinsert Code = "ENG" Description = "English"    Default = "1" Operational = "2">
<cf_Recordinsert Code = "NED" Description = "Nederlands" Default = "0">
<cf_Recordinsert Code = "FRA" Description = "Francais"   Default = "0">
<cf_RecordInsert Code = "GER" Description = "Deutch"     Default = "0">
<cf_RecordInsert Code = "POR" Description = "Portugais"  Default = "0">
<cf_RecordInsert Code = "ESP" Description = "Espanol"    Default = "0">

<cf_screentop html="No" jquery="Yes">
	
<cfsavecontent variable="option">
<button type="button" class="button10g" style="width:225px;height:27px" onClick="javascript:init()">Initialize</button>
</cfsavecontent>	
	
<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template="../Parameter/HeaderParameter.cfm">
	
<table width="97%" align="center">
 
<tr><td align="center" style="padding:3px"><cfdiv id="init"></td></tr> 

<cfquery name="SearchResult"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_SystemLanguage
</cfquery>

<cfoutput>

<script>

function recordedit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=570, height=350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function init() {
    _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy10.gif'/>";	
    ptoken.navigate('#SESSION.root#/system/language/View/Init.cfm','init')   
}

</script>	
</cfoutput>

<tr><td colspan="2" style="padding-top:5px">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium2 line">
    <TD></TD>
    <TD><cf_tl id="Code"></TD>
	<TD><cf_tl id="Description"></TD>
	<td><cf_tl id="Backoffice"></td>
	<TD><cf_tl id="Mode"></TD>
	<TD><cf_tl id="Default"></TD>
	<TD><cf_tl id="Entered"></TD>	
</TR>

<cfoutput query="SearchResult">
        
	<cfif SystemDefault eq "1">
	<TR style="height:25" bgcolor="ffffaf" class="labelmedium2 navigation_row line">
	<cfelse>
	<TR style="height:25" bgcolor="white" class="labelmedium2 navigation_row line">
	</cfif>
	<td align="center" width="5%" style="padding-top:1px">
		<cf_img icon="select" onclick="recordedit('#Code#')" navigation="Yes">
	</td>		
	<TD>#Code#</TD>	
	<TD>#LanguageName#</TD>
	<TD><cfif Interface eq "1">Yes</cfif></TD>
	<TD><cfif Operational eq "0">
	    <font color="FF8080">Disabled</font>
		<cfelseif Operational eq "1">Interface only
		<cfelse>Interface and Data</cfif></TD>
	<TD><cfif SystemDefault eq "1">Yes<cfelse></cfif></TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	</TR>
				
</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>
