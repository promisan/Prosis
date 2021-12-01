<cfquery name="getClientTree" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Ref_ParameterMission
		WHERE	Mission = '#url.mission#'
</cfquery>

<cfquery name="getPayers" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Organization
		WHERE	Mission = '#getClientTree.TreeCustomerPayer#'
		ORDER BY HierarchyCode ASC
</cfquery>

<cfquery name="getPayerLines" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	C.*,
				O.OrgunitName,
				CASE
					WHEN C.Destination = 'Patient' THEN 'Patient'
					WHEN C.Destination = 'Insurance' THEN 'Insurer'
				END AS DestinationDescription
		FROM	ServiceItemUnitMissionCharge C 
				INNER JOIN Organization.dbo.Organization O 
					ON C.PayerOrgUnit = O.OrgUnit
		WHERE	C.CostId = '#url.costid#'
		ORDER BY O.HierarchyCode ASC
</cfquery>

<cf_tl id="Remove this charge?" var="lblConfirmChargeRemove">
		
<cfoutput>
	<table width="100%" class="formpadding navigation_table">
		<tr class="line labelmedium">
			<td><cf_tl id="Payer"></td>
			<td><cf_tl id="Destination"></td>
			<td align="right"><cf_tl id="Amount"></td>
			<td width="40px"></td>
		</tr>
		<tr style="background-color:##FFFED9;">
			<td>
				<select name="chargePayerOrgUnit" id="chargePayerOrgUnit" class="regularxl">
					<option value=""> - <cf_tl id="Select a payer"> -
					<cfloop query="getPayers">
						<option value="#orgunit#"> #OrgunitName#
					</cfloop>
				</select>
			</td>
			<td style="padding-left:5px;">
				<select name="chargeDestination" id="chargeDestination" class="regularxl">
					<option value="Patient"> Patient
					<option value="Insurance"> Insurer
				</select>
			</td>
			<td style="padding-left:5px;" align="right">
				<input type="text" class="regularxl" name="chargeAmount" id="chargeAmount" style="text-align:right; width:75px; padding-right:3px;">
			</td>
			<td align="center">
				<cf_img icon="add" onclick="addCharge('#url.mission#', '#url.costid#',$('##chargePayerOrgUnit').val(),$('##chargeDestination').val(), $('##chargeAmount').val());">
			</td>
		</tr>
		<tr class="line"><td colspan="4"></td></tr>
		<cfloop query="getPayerLines">
			<tr class="navigation_row">
				<td class="labelit">#OrgunitName#</td>
				<td class="labelit">#DestinationDescription#</td>
				<td class="labelit" align="right">#numberformat(Amount, ',.__')#</td>
				<td class="labelit" align="center">
					<cf_img icon="delete" onclick="if (confirm('#lblConfirmChargeRemove#')) { purgeCharge('#url.mission#', '#CostId#','#PayerOrgUnit#','#Destination#'); }">
				</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>

<cfset ajaxOnLoad("doHighlight")>