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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_StatusReason
	Order by ListingOrder
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Requisition decision reasons">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>
  
<script>

function recordadd(grp) {
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=500, top=300, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr><td height="1" colspan="10" class="labelmedium2 linedotted">Various reasons to deny a requisition request</td></tr>

<tr class="labelmedium line">
    <TD height="20" width="6%"></TD>
    <TD width="5%">Code</TD>
	<TD width="25%">Description</TD>
	<TD width="10%">Entity</TD>
	<td width="10%" align="Center">Trigger</td>
	<TD width="10%" align="Center">Text</TD>
	<TD width="5%"  align="Center">Sort</TD>
	<TD width="5%"  align="Center">Oper.</TD>
	<TD width="20%">Officer</TD>
    <TD width="10%">Entered</TD>  
</TR>

<cfoutput query="SearchResult">
    
	<tr class="navigation_row line labelmedium2">
		<td align="center"><cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')"></td>			
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<td>#Mission#</td>
		<TD align="Center"><cfif Status eq "2i">Accept<cfelse>Deny</cfif></TD>
		<TD align="Center"><cfif IncludeSpecification>Yes<cfelse>No</cfif></TD>
		<TD align="Center">#ListingOrder#</TD>
		<TD align="Center"><cfif Operational>Yes<cfelse>No</cfif></TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </TR>
		
</CFOUTPUT>
  
</TABLE>

</cf_divscroll>

</td>
</tr>

</TABLE>
