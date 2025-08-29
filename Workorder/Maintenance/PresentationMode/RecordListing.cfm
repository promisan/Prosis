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
    SELECT 	*
	FROM 	Ref_PresentationMode
	ORDER BY ListingOrder
</cfquery>

<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Billing mode">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "EditPresentationMode", "left=80, top=80, width= 500, height= 275, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td colspan="2">

	<cf_divscroll>

	<table width="97%" class="formpadding" align="center">
	
		<tr class="labelmedium2 line">
		    <td></td> 
		    <td>Code</td>
			<td>Description</td>
			<td align="center">Listing Order</td>
			<td>Officer</td>
		    <td>Entered</td>
		  
		</tr>
				
		<cfoutput query="SearchResult">
		
		    <tr class="labelmedium2 line navigation_row"> 
			<td width="5%" align="center" style="padding-top:1px;">
			   <cf_img icon="open" onclick="recordedit('#Code#')">
			</td>		
			<td>#Code#</td>
			<td>#Description#</td>
			<td align="center">#listingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		    			
		</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>

</tr>

</table>
