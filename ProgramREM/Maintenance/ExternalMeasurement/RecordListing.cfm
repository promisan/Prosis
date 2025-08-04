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

<HTML><HEAD><TITLE>Indicator upload</TITLE></HEAD>

<body>

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM stProgramMeasure
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=400, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=400, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>


<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
		<td></td>
		<td>Table</td>
		<td>tree</td>
		<td>Period</td>
		<td>Source</td>
		<td>Overwrite</td>
		<td>Location</td>
		<td>Operational</td>
		<td>Entered</td>
		<td></td>
	</tr>
</thead>


<cfif searchresult.recordcount eq "0">

<tr><td colspan="10" height="20" align="center">No files have been recorded</td></tr>

</cfif>

<cfset Ord = 0>

<tbody>
<cfoutput query="SearchResult">
    <tr class="navigation_row">
		<td width="30" align="center">
		  <cf_img icon="open" onclick="recordedit('#fileName#');" navigation="yes">
		</td>
		<td><a href="javascript:recordedit('#fileName#')">#FileName#</a></td>
		<td>#Mission#</td>
		<td>#Period#</td>
		<td>#Source#</td>
		<td><cfif #Overwrite# eq "1">Yes</cfif></td>
		<td><cfif #LocationEnabled# eq "1">Yes</cfif></td>
		<td><cfif #Operational# eq "1">Yes</cfif></td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
		<td>
		
		<cftry>
			<cfquery name="SearchResult"
			datasource="#Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT top 1 *
			FROM #FileName#
			</cfquery>
			
			<cfif operational eq "1"><input type="checkbox" name="selected" value="'#fileNo#'">
			
			</cfif>
		
		<cfcatch><font color="FF0000">N/A</cfcatch>	
		
		</cftry>
		
		</td>
    </tr>

</cfoutput>

</tbody>

<cfif searchresult.recordcount neq "0">
	<tr><td colspan="10" align="right" style="padding-top:3px;">
	<input type="button" class="button10g" name="Upload" onClick="upload()" value="Import">
	</td></tr>
	
</cfif>	
	
		
</table>


</cf_divscroll>

<cfwindow name="process" Title="Import" height="400" width="600"  initshow="False" closable="Yes" modal="Yes" center="Yes"/>
	
<cfoutput>
	<script language="JavaScript">
	
	function upload() {
	    se = document.getElementsByName("selected")
		cnt = 0;
		sel = ""
		while (se[cnt]) {
			if (se[cnt].checked == true) {
			  if (sel == "") {
			  sel = se[cnt].value;
			  } else {
			  sel = sel+","+se[cnt].value;
			  }
			}  
			cnt++
		}
		
		if (sel == "") {
			alert("No files were selected.")
		} else {
		ColdFusion.Window.show('process')
		ColdFusion.navigate('Upload.cfm?fileno='+sel,'process')
		}
		
		
	}
	
	</script>
</cfoutput>

</BODY></HTML>