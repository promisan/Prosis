<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ImageClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="table_navigation">

<tr><td><cfinclude template = "../HeaderMaintain.cfm"> 	</td></tr>

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
	
<tr><td colspan="2">

<cf_divscroll>

	<table width="97%" align="center" class="navigation_table formpadding">
	
	<cfset col="7">
	
	<tr class="fixrow labelmedium line">
	    <TD></TD>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>
		<TD><cf_tl id="Width"></TD>
		<TD><cf_tl id="Height"></TD>
		<TD><cf_tl id="Officer"></TD>
	    <TD><cf_tl id="Entered"></TD>
	</tr>
	
	<cfoutput query="SearchResult">
	    
	    <tr class="navigation_row labelmedium line"> 
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

</cf_divscroll>

</td>
</tr>

</TABLE>

