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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostClass
	Order by ListingOrder
</cfquery>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>


<cfoutput>

<script>

function recordadd(grp) {
   ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=550, height=450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
   ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=550, height=450, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>	


<tr><td>

	<cf_divscroll>
	
	<table width="94%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line fixrow">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td>Grouping</td>
			<td>Color</td>
			<td>Order</td>
		</tr>
		
		<cfoutput query="SearchResult">
		   
		    <tr height="20" class="labelmedium2 line navigation_row">
				<td width="5%" align="center" style="padding-top:1px"> <cf_img navigation="Yes" icon="open" onclick="recordedit('#PostClass#')"> </td>		
				<td>#PostClass#</td>
				<td>#Description#</td>
				<td>#PostClassGroup#</td>
				<td>
					<table height="16" border="0" style="border:1px solid silver" width="14">
						<tr><td bgcolor="#PresentationColor#"></td></tr>
					</table>
				</td>
				<td>#ListingOrder#</td>
		    </tr>
			
		</cfoutput>
		
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>