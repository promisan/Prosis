
<table width="98%" align="center">

<tr class="labelmedium">
	<td colspan="2"><cf_tl id="Select units"></td>
</tr>

<cfquery name="Units" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT O.OrgUnit, O.OrgUnitName, O.HierarchyCode
		FROM            OrganizationAuthorization AS OA INNER JOIN
									Organization AS O ON OA.OrgUnit = O.OrgUnit
		WHERE   OA.Mission = '#url.mission#' 
		AND     OA.Role    = 'HRAssistant' 
		AND     OA.UserAccount = 'alallous' 
		AND     OA.AccessLevel IN ('1', '2')
		AND     O.DateEffective  < '#url.selection#' 
		AND     O.DateExpiration > '#url.selection#'
		ORDER BY O.HierarchyCode
</cfquery>

<cfoutput query="Units">
	
	<tr class="labelmedium line">
		<td>
			<input style="height:17px; width:17px; cursor:pointer;" type="checkbox" name="unit" id="unit_#orgunit#" class="clsFilterUnit" value="'#OrgUnit#'" <cfif currentrow eq 1>checked</cfif>>
		</td>
		<td style="padding-left:8px;padding-top:7px">
			<label for="unit_#orgunit#" style="font-size:14px; font-weight:normal; cursor:pointer;">#OrgUnitName#</label>
		</td>
	</tr>

</cfoutput>

<tr><td colspan="2" style="padding-top:4px" align="center">
	<button onclick="doFilter()" class="button10g"><cf_tl id="Show"></button>
</td></tr>

</table>
