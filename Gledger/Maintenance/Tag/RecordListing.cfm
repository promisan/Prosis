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
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select * 
	FROM Ref_Category T INNER JOIN Ref_Entity E
			ON T.EntityCode = E.EntityCode
	Order by T.CategoryClass, ListingOrder, T.EntityCode, T.Description
</cfquery>

<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Financial Tag">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfoutput>

<script language="JavaScript1.2">

function recordadd(grp) {
    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=440, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2 line">   
    <td width="5%"></td>
	<td>Mission</td>
	<td>Entity</td>
    <td>Code</td>
	<td>Description</td>
	<td>Officer</td>
	<td>Entered</td>  
</tr>

<cfoutput query="SearchResult" group="CategoryClass">

	<cfquery name="MyClass" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_CategoryClass
		WHERE  Code = '#CategoryClass#'	
	</cfquery>
	
	<tr><td colspan="7" style="height:30;font:18px" class="line labellarge"><b>#CategoryClass# #MyClass.Description#</b></td></tr>	
	
	<cfoutput>    
    <tr class="labelmedium2 navigation_row line">
		<td align="center"> 
			<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
		</td>
		<td><a href="javascript:recordedit('#Code#')"><cfif Mission eq "">All<cfelse>#mission#</cfif></a></td>	
		<td>#EntityDescription#</td>		
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>	
	</cfoutput>

</cfoutput>

</TABLE>

</cf_divscroll>

