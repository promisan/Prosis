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
 
<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeParent P
	ORDER BY ViewOrder
</cfquery>


	
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
	
<cfoutput>

<script>

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 490, height=380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 490, height=380, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
		
	<table width="97%" align="center" class="navigation_table">
	
		<tr class="line labelmedium2">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Order</td>
			<td>Show</td>
			<td>Post type</td>
			<td>Category</td>
			<td>Officer</td>
		    <td>Entered</td>
		</tr>
		
		<cfoutput query="SearchResult">
		 
		    <tr class="navigation_row line labelmedium2">  
				<td width="5%" align="center" style="padding-top:1px">
					 <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
				</td>		
				<td>#Code#</td>
				<td>#Description#</td>
				<td>#ViewOrder#</td>
				<td>#ViewTotal#</td>
				<td>#Posttype#</td>
				<td>#Category#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>	
		
		</cfoutput>
	
	</table>
		
	</cf_divscroll>

</td>
</tr>

</table>
