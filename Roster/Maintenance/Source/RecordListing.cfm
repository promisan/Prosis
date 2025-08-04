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
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Source
	ORDER  BY Created DESC
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table style="height:100%;width:98%">

<tr><td align="center" style="height:10">

<cfset Header       = "Submission Source">
<cfinclude template = "../HeaderRoster.cfm"> 

</td>
</tr>
 
<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
         ptoken.open("RecordEdit.cfm?ID1=" + id1 + "&idmenu=#url.idmenu#", "Edit", "left=80, top=80, width= 550, height=390, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>  

<tr><td style="height:100%">

	<cf_divscroll>
	
	<table width="95%" align="center" class="navigation_table">
	
		<tr class="labelmedium2 line navigation_row">
		    <td ></td>
		    <td>Source</td>
			<td>Description</td>
			<td>Edit PHP</td>
			<td>PHP Mode</td>
			<td>Assesment</td>
			<td>Enrollment flow</td>		
			<td>Op</td>
		    <td>Entered</td>
		</tr>
	
		<cfoutput query="SearchResult">
		
			<tr style="height:20px" class="labelmedium2 navigation_row line">
				<td width="10%" style="height:25px;padding-top:1px" align="center"> <cf_img icon="open" navigation="Yes" onclick="recordedit('#Source#')"> </td>		
				<td>#Source#</td>
				<td>#Description#</td>
				<td><cfif AllowEdit eq "1">Yes<cfelse>No</cfif></td>
				<td>#PHPMode#</td>
				<td><cfif AllowAssessment eq "1">Yes<cfelse>No</cfif></td>
				<td>#EntityClass#</td>			
				<td><cfif Operational eq "1">Yes<cfelse>No</cfif></td>
				<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		    </tr>
		
		</cfoutput>
	  
	</table>
	
	</cf_divscroll>

</td>
</tr>
</table>

