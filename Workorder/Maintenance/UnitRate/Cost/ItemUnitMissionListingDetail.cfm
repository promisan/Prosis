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

<cfquery name="qListing" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   S.*,
			 ISNULL((SELECT COUNT(*) FROM ServiceItemUnitMissionOrgUnit WHERE CostId = S.CostId),0) AS CountOwners
	FROM     ServiceItemUnitMission S
	WHERE    S.ServiceItem = '#URL.ID1#'
	AND      S.ServiceItemUnit = '#URL.ID2#'
	ORDER BY S.Mission, S.DateEffective 
</cfquery>

<cfif url.id2 neq "">
<table width="100%" align="center" class="navigation_table formpadding">
		
	<TR class="line">
		<TD valign="middle" style="height:40px;font-weight:bold" colspan="6" class="labellarge"><cf_tl id="Rate Card"></TD>	
	
		<td align="right" colspan="8">
			<cfoutput>
			<input class="button10g" style="font-size:11px;width:160px;height:25" type="Button" name="AddRecord" id="AddRecord" value="Add Rate Card"
			 onclick="showunitMission('', '#URL.ID1#', '#URL.ID2#')">	
			</cfoutput>
		</td>
	</tr>
						
    <TR valign="middle" class="fixlengthlist labelmedium2 line">	
	   <td></td>   
	   <td align="center"><cf_tl id="Effective"></td>
	   <td align="center"><cf_tl id="Expiration"></td>	  
	   <td align="center"><cf_tl id="Currency"></td>
	   <td align="right"><cf_tl id="Cost"></td>
	   <td align="right"><cf_tl id="Price"></td>	   
	   <td align="center"><cf_tl id="Manual"></td>
	   <td align="center"><cf_tl id="Edit Charged"></td>
	   <td align="center"><cf_tl id="Edit Qty"></td>
	   <td align="center"><cf_tl id="Edit Rate"></td>
	   <td align="center"><cf_tl id="Units"></td>
	   <td align="center" title="Operational"><cf_tl id="O"></td>	   
	   <td></td>
	   <td></td>
    </TR>	
	
	<cfoutput query="qListing" group="Mission">
	<!---
	<tr><td height="20" colspan="12" class="labelmedium" style="padding-left:7px"><b>#Mission#</td></tr>
	<tr><td colspan="12" style="padding-left:7px" class="line"></td></tr>
	--->
	<cfset row = 1>
	<cfoutput>		
			<TR class="labelmedium navigation_row line fixlengthlist">			
			    <td style="padding-left:4px"><cfif row eq "1">#Mission#</cfif></td>	  
				<td align="center">#Dateformat(dateEffective, "#CLIENT.DateFormatShow#")#</td>
				<td align="center">#Dateformat(dateExpiration, "#CLIENT.DateFormatShow#")#</td>				
				<td align="center">#Currency#</td>
				<td align="right">#LSNumberFormat(StandardCost, ",_.__")#</td>
				<td align="right">#LSNumberFormat(Price, ",_.__")#</td>
				<td align="center"><cfif enableUsageEntry eq 0>No<cfelse>Yes</cfif></td>
				<td align="center"><cfif enableEditCharged eq 0>No<cfelse>Yes</cfif></td>
				<td align="center"><cfif enableEditQuantity eq 0>No<cfelse>Yes</cfif></td>
				<td align="center"><cfif enableEditRate eq 0>No<cfelse>Yes</cfif></td>	
				<td align="center"><cfif countOwners eq "0">Any<cfelse>#CountOwners#</cfif></td>
				<td align="center"><cfif operational eq 0>No<cfelse>Yes</cfif></td>							   			   				 
				<td align="center">
					<cf_img icon="edit" navigation="Yes" onclick="showunitMission('#costId#', '#URL.ID1#', '#URL.ID2#')">
				</td>				
				<td align="center">
					<!--- onClick="window.open('itemUnitMissionEdit.cfm?ID1=#costId#&mode=Edit', 'EditItemUnitMission', 'left=80, top=80, width=1024, height=370, toolbar=no, status=yes, scrollbars=no, resizable=yes');"> --->
					<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) ptoken.navigate('#SESSION.root#/Workorder/Maintenance/UnitRate/Cost/ItemUnitMissionPurge.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#&URL.ID3=#costId#','ratelisting')">
				</td>		  					 							   		   
		   </tr>	
		   <cfset row = row+1>		  
		   	
	</cfoutput>
		   							
	</cfoutput>											
				
</table>	

<cfset ajaxonload("doHighlight")>

</cfif>	