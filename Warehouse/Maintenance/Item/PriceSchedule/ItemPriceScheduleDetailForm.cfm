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
<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_PriceSchedule
</cfquery>

<cfquery name="Currency" 
	datasource="appsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Currency
		WHERE	EnableProcurement = 1
		AND		Operational = 1 
</cfquery>

<cfquery name="qItemPriceSchedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemPriceSchedule 
		WHERE 	ItemNo = '#url.itemno#'
		AND		Mission = '#url.mission#'
</cfquery>

<cfquery name="thisItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	I.*,
				(SELECT Description FROM Ref_Category WHERE Category = I.Category) as CategoryDescription,
				(SELECT ('[' + Code + '] ' + Description) FROM Ref_ItemClass WHERE Code = I.ItemClass) as ClassDescription
		FROM 	Item I
		WHERE 	I.ItemNo = '#url.itemno#'
</cfquery>

<cfquery name="Items" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE 	Operational = 1
		AND		ItemNo IN (SELECT DISTINCT ItemNo FROM ItemUoMMission WHERE Mission = '#url.mission#' AND Operational = 1)
		AND		Category = '#thisItem.Category#'
		AND		ItemClass = '#thisItem.ItemClass#'
		AND		ItemNo != '#thisItem.ItemNo#'
</cfquery>

<cfset ItemsList = "">
<cfset ItemCount = 0>
<cfset DisplayItems = 20>

<cfloop query="Items">
	<cfset ItemCount = ItemCount + 1>
	<cfif ItemCount lte DisplayItems>
		<cfset ItemsList = ItemsList & Items.ItemNo & " - " & Items.ItemDescription & "\n">
	</cfif>
</cfloop>

<cfform name="frmItemPriceSchedule" method="POST" action="PriceSchedule/ItemPriceScheduleSubmit.cfm?itemno=#url.itemno#&mission=#url.mission#">

	<table width="98%" align="center" cellpadding="0" class="formpadding">
		
		<tr>
			<td width="20%"></td>
			<cfoutput query="Currency">
				<td align="center" 
					title="#Description#" 
					id="td_#currency#" 
					bgcolor="D9FFDC" 
					style="border:1px solid C0C0C0;">#Currency# 
				</td>
			</cfoutput>
			<cfset totalCols = Currency.recordCount + 1>
		</tr>
		
		<cfloop query="Schedule">
			<tr>
				<cfoutput>
				<td bgcolor="D9FFDC" style="border:1px solid C0C0C0;">
					#Description# 
				</td>
				</cfoutput>
				<cfloop query="Currency">
					
					<cfquery name="lqItemPriceSchedule" 
						dbtype="query">
						SELECT 	*
						FROM 	qItemPriceSchedule
						WHERE	PriceSchedule = '#Schedule.code#'
						AND		Currency = '#Currency.Currency#'
					</cfquery>
					
					<cfset vSelected = 0>
					<cfif lqItemPriceSchedule.recordCount eq 1>
						<cfset vSelected = 1>
					</cfif>
					
					<cfoutput>
					<td align="center" 
						id="td_#Schedule.code#_#Currency.Currency#" 
						style="border:1px solid C0C0C0; <cfif vSelected eq 1>background-color:'FFFFCF'; </cfif>" 
						onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" 
						bgcolor="">
						
						<input 	type="Checkbox" 
								name="cb_#Schedule.code#_#Currency.Currency#" 
								id="cb_#Schedule.code#_#Currency.Currency#" 
								onclick="javascript: hlChecked('#Schedule.code#','#Currency.Currency#');"
								<cfif vSelected eq 1>checked</cfif>>
								
					</td>
					</cfoutput>
				</cfloop>
			</tr>
		</cfloop>
		
		<tr><td height="10"></td></tr>
		<tr><td class="line" colspan="<cfoutput>#totalCols#</cfoutput>"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="<cfoutput>#totalCols#</cfoutput>">
				<table>
					<tr>
						<td width="1%"><img align="absmiddle" src="<cfoutput>#SESSION.root#</cfoutput>/images/arrow5.png"></td>
						<td style="padding-left:5px;">Copy these price settings to all items used by this entity, that are defined as <cfoutput><b>#thisItem.ClassDescription#</b></cfoutput> within the category <cfoutput><b>#thisItem.CategoryDescription#</b></cfoutput>:</td>
					</tr>
					<tr>
						<td></td>
						<td style="padding-left:5px;">
							<label title="Add these checked boxes to other items">
								<input type="Checkbox" name="inherit" id="inherit" onclick="toggleCopyPriceSchedule('sync');"> Inherit (Add these settings)
							</label>
						</td>
					</tr>
					<tr>
						<td></td>
						<td style="padding-left:5px;">
							<label title="Replace the whole price settings to other items">
								<input type="Checkbox" name="sync" id="sync" onclick="toggleCopyPriceSchedule('inherit');"> Synchronize (Replace whole settings)
							</label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr><td height="5"></td></tr>	
		<tr>
			<td colspan="<cfoutput>#totalCols#</cfoutput>" align="center">
				<cfoutput>
					<input type="Submit" style="width:110" name="save" id="save" value="Save" class="button10g" onclick="return validatePriceSchedule('#url.mission#', '#ItemsList#', #Items.recordCount#, #DisplayItems#, '#thisItem.CategoryDescription#', '#thisItem.ClassDescription#');">
				</cfoutput>
			</td>
		</tr>
		
	</table>

</cfform>