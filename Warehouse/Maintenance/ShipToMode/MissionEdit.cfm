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
<cfif url.id2 eq "">
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Entity" option="Add Entity" user="no">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Entity" banner="yellow" option="Maintain Entity" user="no">
</cfif>

<cfquery name="InsertNotExistingCategories" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		INSERT INTO Ref_ShipToModeMission
			(
				Code,
				Mission,
				Category,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)
		SELECT DISTINCT    	
				'#url.id1#',
				'#url.id2#',
				R.Category,
				'#session.acc#',
				'#session.last#',
				'#session.first#'
		FROM	WarehouseCategory WC 
				INNER JOIN Warehouse W 
					ON WC.Warehouse = W.Warehouse 
				INNER JOIN Ref_Category R 
					ON WC.Category = R.Category
		WHERE	W.Mission = '#URL.ID2#'
		AND		R.Operational = 1
		AND			NOT EXISTS
					(
						SELECT 	'X'
						FROM	Ref_ShipToModeMission
						WHERE	Code = '#url.id1#'
						AND		Mission = '#url.id2#'
						AND		Category = R.Category
					)
</cfquery>

<cfquery name="GetData" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	Ref_ShipToModeMission
		WHERE 	Code     = '#URL.ID1#'
		AND		Mission  = '#URL.ID2#'
</cfquery>

<cfquery name="GetCategories" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				WC.Category,
				R.Description, 
				R.TabOrder
		FROM	WarehouseCategory WC 
				INNER JOIN Warehouse W 
					ON WC.Warehouse = W.Warehouse 
				INNER JOIN Ref_Category R 
					ON WC.Category = R.Category
		WHERE	W.Mission = '#URL.ID2#'
		AND		R.Operational = 1
		ORDER BY R.TabOrder
</cfquery>

<cfquery name="getClass" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_EntityClass
		WHERE   EntityCode = 'WhsTaskOrder'
		AND     EntityClass IN (SELECT EntityClass
		                        FROM   Ref_EntityClassPublish
								WHERE  EntityCode = 'WhsTaskOrder'
								)		
		AND  	Operational = 1								
</cfquery>

<table class="hide">
	<tr><td><iframe name="processShipToModeMission" id="processShipToModeMission" frameborder="0"></iframe></td></tr>
</table>

<cfform action="MissionSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="ShipToModeMission" target="processShipToModeMission">

<table width="100%" cellspacing="0" class="formpadding">

<tr><td valign="top">

<!--- Entry form --->

<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	<cfoutput>
   <!--- Field: Id --->
    <TR>
    <td width="80" class="labellarge">Entity:</td>
    <TD class="labellarge">
	
		<b>#url.id2#</b>
		<input type="hidden" name="Mission" id="Mission" value="<cfoutput>#url.id2#</cfoutput>">
		<input type="hidden" name="MissionOld" id="MissionOld" value="<cfoutput>#url.id2#</cfoutput>">
		<input type="hidden" name="Code" id="Code" value="<cfoutput>#url.id1#</cfoutput>">
	</TD>
	</TR>
	
	<tr><td height="5"></td></tr>
	
	<tr>
		<td colspan="2">
			<table id="myListing" width="100%" align="center" cellspacing="0" class="formpadding">
				<tr>
					<td class="labelmedium">Category</td>
					<td class="labelmedium">Workflow</td>
					<td class="labelmedium">
						<cfset vPath = "#SESSION.root#">
						Print Template [#vPath#]
					</td>
					<td class="labelmedium" align="center">Entry Mode</td>
				</tr>
				
				<tr><td colspan="4" class="line"></td></tr>
				
				<cfset cntRow = 0>
				
				<cfloop query="GetCategories">
					
					<cfset cntRow = cntRow + 1>
					
					<cfinvoke 
						component		= "Service.Presentation.Presentation"
				       	method			= "highlight2"
						tableListingId 	= "myListing"
						multiselect		= "no"
						rowCounter		= "#cntRow#"
				    	returnvariable	= "highlightStyle">
					
					<cfquery name="qGet" dbtype="query">
						SELECT 	* 
						FROM 	GetData
						WHERE 	Category = '#GetCategories.category#'
					</cfquery>
					
					<tr #highlightStyle#>
						<td class="labelmedium">#GetCategories.Description#</td>
						<td>
							<select name="EntityClass_#GetCategories.category#" id="EntityClass_#GetCategories.category#" class="regularxl">
								<cfloop query="getClass">
									<option value="#EntityClass#" <cfif EntityClass eq qGet.EntityClass>selected</cfif>>#EntityClassName#</option>
								</cfloop>
							</select>
						</td>
						<td>
							<table>
								<tr>
									<td>
										<cfinput type="Text" 
											name="ShipmentTemplate_#GetCategories.category#"
											id="ShipmentTemplate_#GetCategories.category#" 
											value="#qGet.ShipmentTemplate#" 
											message="Please enter a description" 
											required="No" 
											size="60" 
											maxlength="80"
											onblur= "ColdFusion.navigate('FileValidation.cfm?template='+this.value+'&container=pathValidationDiv_#GetCategories.category#&resultField=validatePath_#GetCategories.category#','pathValidationDiv_#GetCategories.category#')" 
											class="regularxl">	
									</td>
									<td valign="middle" align="left">
									 	<cfdiv id="pathValidationDiv_#GetCategories.category#" bind="url:FileValidation.cfm?template=#qGet.ShipmentTemplate#&container=pathValidationDiv_#GetCategories.category#&resultField=validatePath_#GetCategories.category#">				
									</td>
								</tr>
							</table>
						</td>
						<td align="center">
							<input type="checkbox" name="ModeShipmentEntry_#GetCategories.category#" id="ModeShipmentEntry_#GetCategories.category#" <cfif qGet.ModeShipmentEntry eq 1>checked="checked"</cfif>>
						</td>
					</tr>
					
				</cfloop>
			</table>
		</td>
	</tr>
		
	</cfoutput>
</table>	

</td>

</tr>
	
<tr><td colspan="2" align="center" height="2">
<tr><td colspan="2" class="line"></td></tr>
<tr><td colspan="2" align="center" height="2">
	
<tr><td colspan="2" height="25" align="center">
	<cfif url.id2 eq "">
		<cf_button type="submit" class="button10g" style="width:100" name="Save" id="Save" value=" Save " onclick="return validateFields();">
	<cfelse>
		<cf_button type="submit" class="button10g" style="width:100" name="Update" id="Update" value=" Update " onclick="return validateFields();">
	</cfif>
	
</td></tr>
	
</TABLE>
	
</CFFORM>

