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
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 Ref_Metric
	ORDER BY Measurement
</cfquery>

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
 
<cfoutput>
	
	<script>
	
		function recordadd(grp) {
		      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
	
	</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
		<table id="myListing" width="95%" align="center" class="navigation_table formpadding">
		
		<tr class="labelmedium2 line">
		    <TD></TD>
		    <TD>Code</TD>
			<TD>Description</TD>
			<td>UoM</td>
			<TD align="center">Operational</TD>
			<TD>Officer</TD>
		    <TD>Entered</TD>
		</TR>
		
		<cfoutput query="SearchResult" group="Measurement">
		
			<tr class="line"><td colspan="7" class="labelmedium2" style="font-size:22px">#Measurement#</td></tr>
						
			<cfoutput>    	
				
		    <TR class="navigation_row labelmedium2 line"> 
				<td align="center">
					  <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
				</td>
				<TD>#Code#</TD>
				<TD>#Description#</TD>
				<td>#MeasurementUoM#</td>
				<TD align="center"><cfif operational eq 0><b>No</b><cfelse>Yes</cfif></TD>
				<TD>#OfficerFirstName# #OfficerLastName#</TD>
				<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
		    </TR>	
			
			</cfoutput>
		
		</CFOUTPUT>
		
		<tr><td height="20"></td></tr>
		
		</TABLE>
	
	</cf_divscroll>

</td>
</tr>

</table>