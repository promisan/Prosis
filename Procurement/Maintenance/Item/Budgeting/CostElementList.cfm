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
<cfquery name="qfItemStandard" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT 
			L.LocationCode, 
			L.LocationCountry, 
			N.Name as CountryName,
			L.Description
	FROM    ItemMasterStandardCost I
			LEFT OUTER JOIN Payroll.dbo.Ref_PayrollLocation L
				ON I.Location = L.LocationCode
			LEFT OUTER JOIN System.dbo.Ref_Nation N
				ON L.LocationCountry = N.Code
	WHERE	I.ItemMaster = '#URL.id1#'
	ORDER BY 
			L.LocationCountry,
			L.LocationCode
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

		<tr height="30px">
			<td colspan="2" class="labelmediumcl" style="padding-left:8px"><cf_tl id="Recorded Standard cost list associations"></b></td>
		</tr>
		<tr><td colspan="2" class="line"></td></tr>
		
		<cfif qfItemStandard.recordcount gt 0>
		<tr>
			<td class="labelmedium" style="padding-left:8px" width="10%"><cf_tl id="Location">:</td>
			<td class="labelmedium" style="padding-left:3px">
				<cfform name="filterform">
					<cfselect 
						name="fLocation" 
						id="fLocation" 
						query="qfItemStandard" 
						display="Description" 
						value="LocationCode" 
						group="CountryName" 
						class="regularxl" 
						queryposition="below">
							<option value=""> -- <cf_tl id="All"> --
					</cfselect>
				</cfform>
			</td>
		</tr>
		<tr><td colspan="2" class="line"></td></tr>
		<cfelse>
			<input type="Hidden" name="fLocation" id="fLocation" value="">
		</cfif>
		
		<tr>
			<td colspan="2">
				<cfdiv id="divCostElementDetail" bind="url:Budgeting/CostElementListDetail.cfm?id1=#url.id1#&location={fLocation}">
			</td>
		</tr>		

</table>