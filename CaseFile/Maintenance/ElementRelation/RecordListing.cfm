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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<HTML><HEAD><TITLE>Award</TITLE></HEAD>

<cfquery name="SearchResult" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ER.*, EC1.Description as ElementFromDescription, EC2.Description as ElementToDescription
	FROM   Ref_ElementRelation ER
	INNER  JOIN Ref_ElementClass EC1
		   	ON ER.ElementClassFrom = EC1.Code
	INNER  JOIN Ref_ElementClass EC2
		   	ON ER.ElementClassTo = EC2.Code
	ORDER  BY ER.ElementClassFrom, ER.ListingOrder
</cfquery>

<body>

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../HeaderCaseFile.cfm"> 
 
<cfoutput>
 
<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function statusedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 350, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr class="labelheader line">
	    <td  width="5%"></td>
	    <td><cf_tl id="Code"></td>	
		<td><cf_tl id="Related To"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Listing Order"></td>
		<td><cf_tl id="Officer"></td>
	    <td><cf_tl id="Entered"></td>
	</tr>

<cfoutput query="SearchResult" group="ElementClassFrom">

	<tr class="linedotted">
		  <td colspan="6" class="labellarge">#ElementFromDescription#</td>
	</tr>
	<cfoutput>
		<tr class="cellcontent linedotted navigation_row">
			<td align="center" style="padding-top:3px;">
				  <cf_img icon="open" onclick="statusedit('#Code#')" navigation="yes">
			</td>	
			<td>#Code#</td>	
			<td>#ElementToDescription#</td>	
			<td>#Description#</td>
			<td>#ListingOrder#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	
	</cfoutput>

</cfoutput>

</table>

</cf_divscroll>


