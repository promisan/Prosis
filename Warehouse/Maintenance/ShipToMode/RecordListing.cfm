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

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cf_divscroll>


<cfquery name="SearchResult"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_ShipToMode
	ORDER BY ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%" border="0" align="center">  

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddShipToMode", "left=80, top=80, width= 650, height=350, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditShipToMode", "left=80, top=80, width=950, height=500, toolbar=no, status=no, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td colspan="6" height="30" class="labelit" style="color:gray;">
	The modes under which requested items may be tasked. The mode also defines the print of the tasked requests on a per entity basis.
</td></tr>

<tr>
    <TD></TD> 
    <TD class="labelmedium">Code</TD>
	<td class="labelmedium">Description</td>
	<td class="labelmedium" align="center">Order</td>
	<TD class="labelmedium">Officer</TD>
    <TD class="labelmedium">Entered</TD>
  
</TR>

<cfoutput query="SearchResult">

    <tr><td class="line" colspan="6"></td></tr>	

    <TR class="navigation_row"> 
	<td width="5%" align="center" style="padding-top:1px">
	 <cf_img icon="open"  navigation="Yes" onclick="recordedit('#Code#');">
	</td>		
	<TD class="labelmedium">#Code#</TD>
	<TD class="labelmedium">#Description#</TD>
	<TD align="center" class="labelmedium">#listingOrder#</TD>
	<TD class="labelmedium">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelmedium">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>    	

</CFOUTPUT>

<tr><td class="line" colspan="6"></td></tr>

</TABLE>

</td>

</tr>

</TABLE>

</cf_divscroll>