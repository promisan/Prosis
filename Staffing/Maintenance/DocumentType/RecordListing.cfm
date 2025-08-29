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

<cf_divscroll height="100%">

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *  
	FROM Ref_DocumentType
</cfquery>
 
<cfoutput>
 
<script language = "JavaScript">

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 480, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 480, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="94%" align="center" class="navigation_table">

	<tr class="labelmedium line fixlengthlist">
	    <td></td>
	    <td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Removal"></td>
		<td><cf_tl id="Edit"></td>
		<td><cf_tl id="Validation"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>
	

	<cfoutput query="SearchResult">
	    <tr class="navigation_row line labelmedium fixlengthlist"> 
			<td width="5%" align="center" style="padding-top:2px">
			   <cf_img icon="open" navigation="Yes" onclick="recordedit('#DocumentType#');">
			</td>			
			<td>#DocumentType#</td>
			<td>#Description#</td>
			<td><cfif EnableRemove eq "1">Yes</cfif></td>
			<td><cfif EnableEdit eq "1">Yes</cfif></td>
			<td><cfif VerifyDocumentNo eq "0">Optional<cfelseif VerifyDocumentNo eq "1">Obligatory<cfelse>Validate</cfif></td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
	</cfoutput>

</table>

</cf_divscroll>