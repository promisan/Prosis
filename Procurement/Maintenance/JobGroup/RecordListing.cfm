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

<cf_screentop layout="webapp" 			  
			  html="No"			 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<table width="100%" height="100%">

<cfset add          = "1">
<cfset Header       = "Job category">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {     
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 500, height= 250, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_JobCategory
	ORDER BY code
</cfquery>

<tr><td>

<cf_divscroll>

	<table width="95%" align="center" class="formpadding navigation_table">
	
	<tr class="line labelmedium2">   
	    <TD width="5%"></TD>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Officer</TD>
		<TD>Entered</TD>  
	</TR>
	
	<cfoutput query="SearchResult">
	   
	    <TR class="labelmedium2 linedotted navigation_row">
		<TD align="center" style="padding-top:1px;">
				<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
		</TD>		
		<TD>#Code#</TD>
		<TD>#Description#</TD>
		<TD>#OfficerFirstName# #OfficerLastName#</TD>
		<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
	    </TR>
			
	</cfoutput>
	
	</table>

</cf_divscroll>

</td></tr>

</table>
