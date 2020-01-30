<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ImageClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="table_navigation">

<cfoutput>

<script>

	function recordadd(grp) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#", "AddPriceSchedule", "left=80, top=80, width= 460, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

	function recordedit(code) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&code=" + code, "EditPriceSchedule", "left=80, top=80, width= 460, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding">

<cfset col="7">

<tr class="labelit line">
    <TD align="left"></TD>
    <TD align="left">Code</TD>
	<TD align="left">Description</TD>
	<TD align="left">Width</TD>
	<TD align="left">Height</TD>
	<TD align="left">Officer</TD>
    <TD align="left">Entered</TD>
</tr>

<cfoutput query="SearchResult">
    
    <tr class="navigation_row labelit line"> 
		<td align="center" height="20" style="padding-top:3px">
		   <cf_img icon="open" onclick="recordedit('#Code#');" navigation="Yes" >
		</td> 
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<TD>#ResolutionWidth#</TD>
		<TD>#ResolutionHeight#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>