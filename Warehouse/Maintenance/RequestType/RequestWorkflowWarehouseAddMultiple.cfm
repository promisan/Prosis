<cfquery name="WH" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	W.*,
			UPPER(Mission) AS uMission,
			(
				SELECT 	Warehouse
				FROM   	Ref_RequestWorkflowWarehouse
				WHERE  	RequestType = '#url.type#'
				AND		RequestAction = '#url.action#'
				AND		Warehouse = W.Warehouse
			) as Selected
	FROM   	Warehouse W
	WHERE  	W.Operational = 1
	AND		W.Distribution = 1
	ORDER BY uMission, WarehouseName
</cfquery>


<table width="100%" align="center" class="formpadding">
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<table width="98%" align="center" class="formpadding">
				<cfoutput query="WH" group="uMission">
					<tr><td class="labelmedium" colspan="2">#uMission#</td></tr>
					<tr>
						<td width="20"></td>
						<td>
							<table width="100%" align="center">
								<tr>
									<cfset cols = 3> 
									<cfset cnt = 0>
									<cfoutput>
										<cfset cnt = cnt + 1>
										<td style="width:#100/cols#%;">
										    <table><tr>
											<td>
											<input type="Checkbox" style="height:14px;width:14px" id="wh_#warehouse#" name="wh_#warehouse#" value="#warehouse#" <cfif selected eq warehouse>checked</cfif>>
											</td>
											<td style="padding-left:10px" class="labelmedium">#WarehouseName#</td>
											</tr></table>
											</td>
									
										<cfif cnt eq cols>
											<cfset cnt = 0>
											</tr>
											<tr>
										</cfif>
									</cfoutput>
								</tr>
							</table>
						</td>
					</tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>