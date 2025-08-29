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
<cfdiv id="workOrderServiceListing">

<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 WorkOrderService
	WHERE	 ServiceDomain = '#URL.ID1#'
	ORDER BY ListingOrder
</cfquery>

<cfoutput>

<table width="99%" align="center">  

<tr><td colspan="2">

<table width="100%" align="center" class="navigation_table">

<tr class="labelmedium2 line">
    <TD style="width:40px"><a href="javascript:showWorkorderService('#URL.ID1#', '')">[<cf_tl id="Add">]</a></TD> 
	<td align="center"><cf_tl id="Sort"></td>
    <TD><cf_tl id="Reference"></TD>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Entities"></td>
	<td align="center"><cf_tl id="Items"></td>
</TR>

</cfoutput>

<cfoutput query="SearchResult">   

	<cfquery name="count"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	 (
					 	SELECT 	COUNT(*)
						FROM	WorkOrderServiceMission
						WHERE	ServiceDomain = WOS.ServiceDomain
						AND		Reference = WOS.Reference
					 ) as Missions,
					 (
					 	SELECT 	COUNT(*)
						FROM	WorkOrderServiceItem
						WHERE	ServiceDomain = WOS.ServiceDomain
						AND		Reference = WOS.Reference
					 ) as Items
			FROM 	 WorkOrderService WOS
			WHERE	 WOS.ServiceDomain = '#URL.ID1#'
			AND		 WOS.Reference = '#Reference#'
	</cfquery>
	
    <TR class="labelmedium2 line navigation_row"> 
	<td width="5%">
		<table>
			<tr>
				<td style="width:2px"></td>
				<td>
					<cfquery name="CountRec" 
					      datasource="AppsWorkOrder" 
					      username="#SESSION.login#" 
					      password="#SESSION.dbpw#">
					      	SELECT	WorkorderId as id
							FROM	Workorderline
							WHERE	ServiceDomain = '#url.id1#'
							AND 	Reference = '#reference#'
					</cfquery>
					<cfif countRec.recordcount eq 0>
						<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) { ptoken.navigate('WorkOrderService/WorkOrderServicePurge.cfm?id1=#url.id1#&id2=#reference#','processWOS'); }">
					</cfif>
				</td>
				<td style="padding-left:3px;padding-top:3px">
					<cf_img icon="open" navigation="Yes" onclick="showWorkorderService('#URL.ID1#', '#Reference#')">
				</td>
			</tr>
		</table>
		  
	</td>		
	<TD align="center">#listingOrder#</TD>
	<TD>#Reference#</TD>
	<TD>#Description#</TD>	
	<td align="center">#Count.Missions#</td>
	<td align="center">#Count.Items#</td>
    </TR>
    	

</CFOUTPUT>

<tr><td class="line" colspan="8" id="processWOS"></td></tr>

</TABLE>

</td>

</TABLE>

</cfdiv>
