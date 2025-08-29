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
<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfquery name="SearchResult"
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Commodity
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="99%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

<script language="JavaScript">
	
	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=630, height=280, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=630, height=280, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>

</cfoutput> 
	
<!--- "width=550, height=500, scrollbars=yes, resizable=yes" --->

<tr><td colspan="2">
	
	<table align="center" width="97%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<tr>
	    <td align="left" class="labelit"></td>
	    <td align="left" class="labelit">Code</td>
		<td align="left" class="labelit">Description</td>
		<td align="left" class="labelit">Officer</td>
	    <td align="left" class="labelit">Entered</td>
	</tr>
	
	
	
	<cfoutput query="SearchResult">
	 		
	    <tr class="navigation_row"> 
			<td align="center" class="line" style="padding-top:1px;padding-right:4px">
			   <cf_img icon="open" navigation="yes" onclick="recordedit('#CommodityCode#');">
			</td>
			<td class="line labelit">#CommodityCode#</td>
			<td class="line labelit">#Description#</td>
			<td class="line labelit">#OfficerFirstName# #OfficerLastName#</td>
			<td class="line labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
			
	    </tr>
			
	</CFOUTPUT>
	
	<tr><td height="1" colspan="5" class="line"></td></tr>
	
	</table>
	
	</td>
</tr>

</table>

</cf_divscroll>