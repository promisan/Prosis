<!--
    Copyright © 2025 Promisan B.V.

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
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_AreaGLedger
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "0">

<table height="100%" width="99%" align="center">

<tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddAreaGLedger", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditAreaGLedger", "left=80, top=80, width= 450, height= 250, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="100%" align="center" class="formpadding navigation_table">

<tr class="labelmedium2 line">
    <TD></TD> 
    <TD><cf_tl id="Code"></TD>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Listing Order"></td>
    <TD><cf_tl id="Entered"></TD>
  
</TR>

<cfoutput query="SearchResult">
    
    <TR class="labelmedium2 line navigation_row"> 
	<td height="20" width="5%" align="center" style="padding-top:1px;">
		<cf_img icon="open" onclick="recordedit('#Area#');" navigation="Yes">
	</td>		
	<TD>#Area#</TD>
	<TD>#Description#</TD>
	<TD align="center">#listingOrder#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>    

</CFOUTPUT>

</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>

