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
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_WarehouseLocationClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0">
 
 <cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 475, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 475, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr>
    <TD align="left"></TD>
    <TD class="labelit" align="left">Code</TD>
	<TD class="labelit" align="left">Description</TD>
	<TD class="labelit" align="left">Officer</TD>
    <TD class="labelit" align="left">Entered</TD>
</TR>

<tr><td class="line" colspan="5"></td></tr>    

<cfoutput query="SearchResult">
	
    <TR class="navigation_row"> 
	<td align="center" style="padding-top:1px">
		  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
	</td>
	<TD class="labelit">#Code#</TD>
	<TD class="labelit">#Description#</TD>
	<TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
	<TD class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	<tr><td class="line" colspan="5"></td></tr>    

</CFOUTPUT>

</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>