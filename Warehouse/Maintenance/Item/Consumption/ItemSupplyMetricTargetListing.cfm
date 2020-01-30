<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
</cfif>


<table width="100%" align="center">
	
	<cfquery name="MetricTarget" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				<cfif url.type eq "Item">
				M.Mission,
				M.Location,
				ISNULL(L.LocationName,'[Loc. Not Defined]') as LocationName,
				</cfif>
				<cfif url.type eq "AssetItem">
				M.dateEffective,
				</cfif>
				M.#vField#,
				M.SupplyItemNo,
				M.SupplyItemUoM,
				M.Metric
		FROM	#vPrefix#ItemSupplyMetricTarget M
				<cfif url.type eq "Item">
				LEFT OUTER JOIN Location L
					ON M.Location = L.Location
				</cfif>
		WHERE	M.#vField# = '#url.id#'
		AND 	M.SupplyItemNo = '#url.SupplyItemNo#' 
		AND 	M.SupplyItemUoM = '#url.SupplyItemUoM#'
		AND		M.Metric = '#url.metric#'
		ORDER BY <cfif url.type eq "Item">M.Mission , M.Location</cfif><cfif url.type eq "AssetItem">DateEffective DESC</cfif>
	</cfquery>
	
	<tr>
		<td width="15%" class="labelit">
		<cfoutput>
		<a href="javascript: editMetricLocation('#url.id#','#url.supplyitemno#','#url.supplyitemuom#','#url.supplyitemuomdescription#','','','#url.metric#','','new','#url.type#');">
			<font color="0080FF">
				[<cf_tl id="Add">]
			</font>
		</a>
		</cfoutput>
		</td>
		<td class="labelit">
			<cfif url.type eq "Item">
				<cf_tl id="Mission">/<cf_tl id="Location">
			</cfif>
			<cfif url.type eq "AssetItem">
				<cf_tl id="Effective Date">
			</cfif>
		</td>
	</tr>
	<tr><td height="2"></td></tr>
	
	<tr><td class="line" colspan="4"></td></tr>
	
	<tr><td height="2"></td></tr>
	
	<cfoutput query="MetricTarget">
		<tr style="padding-top:3px">
			<cfset vMission = "">
			<cfset vLocation = "">
			<cfset vDateEffective = "">
			<cfif url.type eq "Item">
				<cfset vMission = MetricTarget.Mission>
				<cfset vLocation = MetricTarget.Location>
			</cfif>
			<cfif url.type eq "AssetItem">
				<cfset vDateEffective = "#dateFormat(MetricTarget.DateEffective,'yyyymmdd')#">
			</cfif>
			<td>
			  <table cellspacing="0" cellpadding="0" class="formpadding">
			    <tr>
				  <td>
				     <cf_img icon="edit" 
					       onclick="editMetricLocation('#url.id#','#url.supplyitemno#','#url.supplyitemuom#','#url.supplyitemuomdescription#','#vMission#','#vLocation#','#url.metric#','#vDateEffective#','edit','#url.type#');">
				  </td>
				  <td>
				     <cf_img icon="delete" 
					       onclick="if (confirm('Do you want to delete this target ?')) {ColdFusion.navigate('Consumption/ItemSupplyMetricTargetDelete.cfm?id=#url.id#&supplyitemno=#url.supplyitemno#&supplyitemuom=#url.supplyitemuom#&supplyitemuomdescription=#url.supplyitemuomdescription#&metric=#url.metric#&mission=#vMission#&location=#vLocation#&dateEffective=#vDateEffective#&type=#url.type#','divSupplyMetricTarget_#url.metric#');}">
			       </td>
			    </tr>
			  </table>
			</td>
			<td class="labelit">
				<cfif url.type eq "item">
					#MetricTarget.Mission# / #MetricTarget.LocationName#
				</cfif>
				<cfif url.type eq "assetItem">
					#dateFormat(dateEffective,'#CLIENT.DateFormatShow#')#
				</cfif>
			</td>
		</tr>
	</cfoutput>

</table>