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
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Clause
</cfquery>

<table width="100%" height="100%">

<cfset add          = "1">
<cfset Header       = "Procurement Clause">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function reloadForm(page) {
     window.location="RecordListing.cfm?Page=" + page; 
}
  
function recordadd(grp)
{
	w = #CLIENT.width# - 60;
	h = #CLIENT.height# - 120;
    ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id)
{
	w = #CLIENT.width# - 60;
	h = #CLIENT.height# - 120;
    ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1="+id, "Edit", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput> 

<tr><td>

<cf_divscroll>

	<table width="96%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line">
	   
	    <td width="5%"></td>
	    <TD>Code</TD>
		<TD>Name</TD>
		<td>Language</td>
		<td>Operational</td>
		<TD>Officer</TD>
	    <TD>Entered</TD>
	  
	</TR>
	
			<cfoutput query="SearchResult">
		    
		    <TR class="navigation_row line labelmedium2">
				<td align="center" style="padding-top:1px;">
					<cf_img icon="open" navigation="yes" onclick="recordedit('#Code#')">
				</td>
				<TD>#Code#</TD>			  
				<TD>#ClauseName#</TD>
				<td>#LanguageCode#</td>
				<td><cfif operational eq "1"><b>Yes</b></cfif></td>
				<TD>#OfficerFirstName# #OfficerLastName#</TD>
				<TD>#DateFormat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>
								
		</cfoutput>
	
	</TABLE>
		
</cf_divscroll>

</td>
</tr>

</TABLE>

