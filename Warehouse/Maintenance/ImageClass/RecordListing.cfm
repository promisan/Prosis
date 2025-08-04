<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

<table width="97%" height="100%" align="center" cellspacing="0" cellpadding="0" class="table_navigation">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm">	</td></tr>

<cfoutput>

<script>

	function recordadd(grp) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#", "AddPriceSchedule", "left=80, top=80, width= 460, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

	function recordedit(code) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&code=" + code, "EditPriceSchedule", "left=80, top=80, width= 460, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput> 
	
<tr><td colspan="2">

<cf_divscroll>

	<table width="97%" align="center" class="navigation_table formpadding">
	
	<cfset col="7">
	
	<tr class="fixrow labelmedium2 line">
	    <TD></TD>
	    <TD><cf_tl id="Code"></TD>
		<TD><cf_tl id="Description"></TD>
		<TD><cf_tl id="Width"></TD>
		<TD><cf_tl id="Height"></TD>
		<TD><cf_tl id="Officer"></TD>
	    <TD><cf_tl id="Entered"></TD>
	</tr>
	
	<cfoutput query="SearchResult">
	    
	    <tr class="navigation_row labelmedium2 line"> 
			<td align="center" height="20" style="padding-top:1px">
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

