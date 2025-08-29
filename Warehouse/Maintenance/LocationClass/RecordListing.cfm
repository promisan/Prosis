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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_LocationClass
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="94%" align="center" cellspacing="0" cellpadding="0" >
 
 <cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<table width="100%" align="center" class="navigation_table">

<tr class="labelit navigation_row line">
    <TD align="left"></TD>
    <TD align="left"><cf_tl id="Code"></TD>
	<TD align="left"><cf_tl id="Description"></TD>
	<TD align="left"><cf_tl id="Icon"></TD>
	<TD align="left"><cf_tl id="Officer"></TD>
    <TD align="left"><cf_tl id="Entered"></TD>
</TR>
<cfoutput query="SearchResult">
    
    <TR class="navigation_row cellcontent line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#"> 
	<td align="center">
		  <cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#');">
	</td>
	<TD>#Code#</TD>
	<TD>#Description#</TD>
	<td>#ListingIcon#</td>
	<TD>#OfficerFirstName# #OfficerLastName#</TD>
	<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
</CFOUTPUT>

</TABLE>

</td>

</tr>

</TABLE>

</cf_divscroll>