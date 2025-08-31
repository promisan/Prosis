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
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Contact 
	ORDER BY ListingOrder
</cfquery>

<cf_screentop html="No" jquery="Yes">

<table width="95%" align="center" height="100%">

    <tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
	
	<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=590, height= 400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=590, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	</script>	
	
	</cfoutput>
	
	<tr><td colspan="2">
	
		<cf_divscroll>
		
			<table width="95%" align="center" class="navigation_table">
			
				<tr style="height:20px;" class="line labelmedium2 fixrow fixlengthlist">
				    <td></td>
					<td width="5%">&nbsp;</td>
				    <td><cf_tl id="Code"></td>
					<td><cf_tl id="Description"></td>	
					<td><cf_tl id="Mask"></td>	
					<td><cf_tl id="Self-Service"></td>		
					<td><cf_tl id="Order"></td>			
					<td><cf_tl id="Officer"></td>
				    <td><cf_tl id="Entered"></td>
				</tr>
				
				<cfoutput query="SearchResult">
					<cfset row = currentrow>		
				    <tr class="line navigation_row labelmedium2 fixlengthlist"> 
						<td></td>
						<td style="padding-top:1px">
							<cf_img icon="edit" navigation="Yes" onclick="recordedit('#Code#')">
						</td>		
						<td>#Code#</td>
						<td>#Description#</td>		
						<td>#CallSignMask#</td>
						<td><cfif SelfService eq "1">True<cfelse>False</cfif></td>
						<td>#ListingOrder#</td>		
						<td>#officerFirstName# #officerLastName#</td>		
						<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
				    </tr>
				</cfoutput>
			
			</table>
			
		</cf_divscroll>	
	
	</td>
	</tr>

</table>
