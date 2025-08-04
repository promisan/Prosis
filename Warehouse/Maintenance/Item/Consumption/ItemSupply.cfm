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

<cfparam name="url.type" default="Item">

<cf_divscroll>

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<cfoutput>
	
	<cfif url.type eq "Item">

		<cfquery name="Item" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Item
			WHERE  ItemNo = '#URL.ID#'
		</cfquery>
	
		<tr><td height="7"></td></tr>
		
		<cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ItemClass
			WHERE   Code = '#Item.ItemClass#'
		</cfquery>
		
		<TR>
	    <td height="20" width="140" class="labelit">Class:</b></td>
	    <TD width="80%" class="labelit">#Cls.Description#
	    </td>
	    </tr>
		
	    <TR>
	    <TD height="20" class="labelit">Code:</TD>
	    <TD class="labelit">#item.Classification#</TD>
		</TR>
		
		<TR>
	    <TD height="20" class="labelit">Description:</TD>
	    <TD class="labelit">#item.ItemDescription#</TD>
		</TR>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>	
		
	</cfif>
	
	<cfif url.type eq "AssetItem">
	<tr>
		<td colspan="2">
		
			<cfquery name="getMasterSupply" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	S.*,
						I.ItemDescription,
						I2.ItemDescription as SupplyItemDescription,
						U.UoMDescription as SupplyUoMDescription
				FROM 	ItemSupply S
						INNER JOIN Item I	  ON S.ItemNo = I.ItemNo
						INNER JOIN Item I2	  ON S.SupplyItemNo = I2.ItemNo
						INNER JOIN ItemUoM U  ON S.SupplyItemNo = U.ItemNo
											AND	S.SupplyItemUoM = U.UoM
				WHERE   S.ItemNo = (SELECT ItemNo
				                    FROM   AssetItem 
									WHERE  AssetId = '#URL.id#')
			</cfquery>
			
			<table width="100%" align="center">
			    <cfif getMasterSupply.recordcount gte "1">
				<tr>
					<td width="10%" height="23" class="labelit"><cf_tl id="Item Master">:</td>
					<td class="labelit">#getMasterSupply.ItemDescription#</td>
				</tr> 
				</cfif>
				<tr>
					<td width="8%" height="23" class="labelit"><cf_tl id="Master Supplies">:</td>
					<td class="labelit">
						<cfset supList = "">
						
						<cfloop query="getMasterSupply">
							<cfset supList = supList & getMasterSupply.SupplyItemDescription & " - " & getMasterSupply.SupplyUoMDescription & ", ">
						</cfloop>
						
						<cfif trim(supList) eq "">
							<cfset supList = "[No supplies defined]">
						<cfelse>
							<cfset supList = mid(supList, 1, len(supList)-2)>
						</cfif>
						#supList#
						
						<cfif getMasterSupply.recordcount gt 0>
							&nbsp;
							<a title="Add supply definition from the item master." href="javascript:getsupplydefinition('#URL.ID#')"><font color="0080FF">[<cf_tl id="Add Master Supply Definition">]</font></a>
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	</cfif>
	
	<cf_tl id = "Identify the supply items that are consumed by this item master" var="vHelpText">
	
	<cfif url.type eq "AssetItem">
		<cf_tl id="Identify the supply items that are consumed by this asset" var="vHelpText">
	</cfif>
	
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" class="labelit"><font color="gray"><b>*&nbsp;#vHelpText#</b></font></td>
	</tr>
	<tr><td height="7"></td></tr>
	
	<tr><td colspan="2" align="center">
	
		<cfdiv bind="url:#SESSION.root#/Warehouse/Maintenance/Item/Consumption/ItemSupplyListing.cfm?id=#url.id#&type=#url.type#" id="supplylist"/>
				
	</td></tr>
	
	<tr><td colspan="2">
	<cfdiv id="supplyedit"/>
	</td></tr>
	
	</cfoutput>	

</TABLE>

</cf_divscroll>
