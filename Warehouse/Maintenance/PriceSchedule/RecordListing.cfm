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

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PriceSchedule
	ORDER BY ListingOrder ASC
</cfquery>


<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table height="100%" width="98%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddPriceSchedule", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditPriceSchedule", "left=80, top=80, width= 550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">

<cf_divscroll>

	<table width="95%" align="center" class="formpadding navigation_table">
	
	<tr class="labelmedium2 line">
	    <TD></TD>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Acronym</TD>
		<TD align="center">Order</TD>
		<td align="center">Default</td>
		<TD>Officer</TD>
	    <TD>Entered</TD>
	</TR>
	
	<cfoutput query="SearchResult">
	    
	    <TR class="navigation_row labelmedium2 line" bgcolor=""> 
		<td align="center" height="20">
		   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
		</td>
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<TD>#Acronym#</TD>
		<TD align="center">#ListingOrder#</TD>
		<td align="center"><cfif fieldDefault eq 0>No<cfelse><b>Yes</b></cfif></td>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
		
	</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

