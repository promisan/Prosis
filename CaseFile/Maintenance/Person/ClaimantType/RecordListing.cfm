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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<HTML></HEAD>

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ClaimantType
	ORDER  BY Code
</cfquery>

<body>

<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../../HeaderCaseFile.cfm"> 

<cfoutput>

<script LANGUAGE = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<cf_divscroll>

	<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">
	
		<thead>
		<tr>
		    <td align="left" width="5%"></td>
		    <td align="left"><cf_tl id="Code"></td>
			<td align="left"><cf_tl id="Description"></td>
			<td align="left"><cf_tl id="Officer"></td>
		    <td align="left"><cf_tl id="Entered"></td>  
		</tr>
		</thead>
		
		<tbody>
		<cfoutput query="SearchResult">
			<tr class="navigation_row">
				<td align="center">
					<cf_img icon="open" onclick="recordedit('#Code#')" navigation="yes">
				</td>	
				<td>#Code#</td>
				<td>#Description#</td>
				<td>#OfficerFirstName# #OfficerLastName#</td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>	 
		</cfoutput>
		</tbody>
	
	</table>

</cf_divscroll>
