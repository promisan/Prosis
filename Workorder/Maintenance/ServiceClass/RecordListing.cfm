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
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ServiceItemClass
	ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Service class">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 580, height= 320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=580, height=320, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" style="padding-top:10px">

<cf_divscroll>

	<table width="100%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	   
		<td width="5%">&nbsp;</td>
	    <td>Code</td>
		<td>Description</td>	
		<td align="center">Sort</td>	
		<td align="center">Oper.</td>
		<td>Officer</td>
	    <td>Entered</td>
	  
	</tr>
	
	<cfoutput query="SearchResult">
	
		<cfset row = currentrow>
			
	    <tr class="labelmedium2 navigation_row line"> 
			<td align="center" style="padding-top:2px;">
					<cf_img icon="select" navigation="Yes" onclick="recordedit('#Code#')">
			</td>		
			<td>#Code#</td>
			<td>#Description#</td>		
			<td align="center">#ListingOrder#</td>
			<td align="center"><cfif operational eq "No"><b>No</b><cfelse>Yes</cfif></td>
			<td>#officerFirstName# #officerLastName#</td>		
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
		
	</cfoutput>
	
	</table>
	
</cf_divscroll>	

</td>
</tr>

</table>

<cfset AjaxOnLoad("doHighlight")>

