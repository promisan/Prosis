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

<cfparam name="URL.lang" default="0">

<cfquery name="SearchResult"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT    M.*, R.Description AS ModuleDescription, R.MenuOrder AS MenuOrder
  FROM      Ref_ReportMenuClass M INNER JOIN
            Ref_SystemModule R ON M.SystemModule = R.SystemModule
  ORDER BY  R.MenuOrder, R.Description, M.ListingOrder
</cfquery>


<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<tr style="height:10px"><td><cfinclude template="../../Parameter/HeaderParameter.cfm"> 	</td></tr>

<cfoutput>

<script>

function recordadd() {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id,id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&Id="+id+"&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	
	
</cfoutput>
	
<tr><td colspan="2">

<cf_divscroll>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2 line fixrow">
    <td>Module</td>
    <TD></TD>
    <TD>Class</TD>
	<TD>Label in Menu</TD>
	<TD>Order</TD>
	<TD>Officer</TD>
    <TD>Entered</TD>  
</TR>

<cfset prior = "">
  
<cfoutput query="SearchResult">

	<cfif prior neq moduleDescription>
    <tr><td height="1" colspan="7" class="line"></td></tr>
	</cfif>
	
	<TR class="labelmedium2 line navigation_row">
		<td style="height:15px;padding-left:3px"><cfif prior neq moduleDescription>#ModuleDescription#</cfif></td>
		<td align="center" style="padding-right:4px">
		     <cf_img icon="open" navigation="Yes" onclick="recordedit('#SystemModule#','#MenuClass#')">	 
		</td>
		<TD>#MenuClass#</TD>
		<TD>#Description#</TD>
		<TD>#ListingOrder#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
    </TR>
	
	<cfset prior = ModuleDescription>
	
</cfoutput>	

</TABLE>

</cf_divscroll>

</td>

</tr>

</TABLE>
