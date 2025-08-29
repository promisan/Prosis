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
<cfquery name="getConfig" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	skMissionItemPrice 
		WHERE  	ItemNo = '#url.id#'
		AND    	UoM    = '#url.uom#'
		ORDER BY ListingOrder ASC
</cfquery>

<table width="30%" align="center" style="margin-top:30px;" class="formpadding">

	<tr>
		<td width="25%" class="labelmedium"><cf_tl id="Entity">:</td>
		<td>
			<cfquery name="getMissions" dbtype="query">
					SELECT DISTINCT Mission
					FROM   	getConfig 
					ORDER BY Mission ASC
			</cfquery>

			<select name="fmission" id="fmission" class="regularxl clsPrintLabelParameterSelect">
				<cfoutput query="getMissions">
					<option value="#Mission#"> #Mission#
				</cfoutput>
			</select>
		</td>
	</tr>

	<tr>
		<td width="25%" class="labelmedium" valign="top" style="padding-top:3px;"><cf_tl id="Print">:</td>
		<td>
			<table width="100%" class="formpadding">
				<tr>
					<td width="5%">
						<cfoutput>
							<input type="checkbox" class="clsPrintLabelParameterCheck" name="fdescription" id="fdescription" style="height:15px; width:15px;" onclick="refreshLabelEPLButton('#url.id#', '#url.uom#')" checked>
						</cfoutput>
					</td>
					<td class="labelmedium" style="padding-left:5px;"><label for="fdescription"><cf_tl id="Description"></label></td>
				</tr>
				<tr>
					<td width="5%">
						<cfoutput>
							<input type="checkbox" class="clsPrintLabelParameterCheck" name="fbarcode" id="fbarcode" style="height:15px; width:15px;" onclick="refreshLabelEPLButton('#url.id#', '#url.uom#')" checked>
						</cfoutput>
					</td>
					<td class="labelmedium" style="padding-left:5px;"><label for="fbarcode"><cf_tl id="Barcode"></label></td>
				</tr>
				<tr>
					<td colspan="2">
						<cf_securediv id="divLabelPS" bind="url:#session.root#/warehouse/maintenance/item/uom/uomlabel/itemUoMLabelPriceSchedule.cfm?item=#url.id#&uom=#url.uom#&mission={fmission}">
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td width="25%" class="labelmedium"><cf_tl id="Quantity">:</td>
		<td>
			<cfoutput>
				<select name="fqty" id="fqty" class="regularxl clsPrintLabelParameterSelect" onchange="refreshLabelEPLButton('#url.id#', '#url.uom#')">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,25,50" item="item">
						<option value="#item#"> #item#
					</cfloop>
				</select>
			</cfoutput>
		</td>
	</tr>

	<!--- Create parameters --->
	<cfset vParameters = "&fdescription=true&fmission=#getMissions.mission#&fqty=1&fbarcode=true">
	<cfoutput query="getConfig">
		<cfset vDefault = "false">
		<cfif fieldDefault eq 1>
			<cfset vDefault = "true">
		</cfif>
		<cfset vParameters = "#vParameters#&fprice#priceschedule#=#vDefault#">
	</cfoutput>

	<tr>
		<td colspan="2" align="center" style="padding-top:20px">
			<cf_secureDiv id="divLabelButton" bind="url:#session.root#/warehouse/maintenance/item/uom/uomlabel/itemUoMLabelButtonEPL.cfm?item=#url.id#&uom=#url.uom##vParameters#">
		</td>
	</tr>

</table>