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
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_AddressBuilding
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
	
<table width="98%" align="center" height="100%">

   <tr><td style="height:10px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
		
	<cfoutput>
	
	<script LANGUAGE = "JavaScript">
	
	function recordadd(grp) {
	     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 295, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height=295, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>
		
	<tr><td colspan="2">
	
	<cf_divscroll>
	
		<table width="97%" align="center" class="navigation_table">
		
		<tr class="labelmedium2 line">
		    <td></td>
		    <td><cf_tl id="Code"></td>
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="Description"></td>
			<td align="center"><cf_tl id="Levels"></td>  
		</tr>
		
		<cfoutput query="SearchResult">
		 
		    <tr class="labelmedium2 navigation_row"> 
			<td height="20" width="5%" align="center">
			 <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
			</td>		
			<td>#Code#</td>
			<td>#Name#</td>
			<td>#Description#</td>
			<td align="center">#Levels#</td>
		    </tr>
			
			<tr><td height="1" colspan="8" class="linedotted"></td></tr>	
		
		</CFOUTPUT>
		
		</table>
	
	</cf_divscroll>
	
</td>

</tr>
		
</table>
	

