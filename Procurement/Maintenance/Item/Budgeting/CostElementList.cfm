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