<cf_screentop html="no" jquery="yes">

<cfquery name="getMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	*
		FROM 	Warehouse
		WHERE	Warehouse = '#url.warehouse#'
			
</cfquery>

<cfquery name="listing" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT 	W.*,
				L.LocationCode,
				L.LocationName,
				L.Country as LocCountry,
				N.Name as CountryName,
				(
					SELECT	AssociationWarehouse
					FROM	WarehouseAssociation
					WHERE	Warehouse = '#url.warehouse#'
					AND		AssociationType = '#url.type#'
					AND		AssociationWarehouse = W.Warehouse
				) AS Selected
    	FROM 	Warehouse W
				LEFT OUTER JOIN Location L
					ON W.LocationId = L.Location	
				LEFT OUTER JOIN System.dbo.Ref_Nation N
					ON L.Country = N.Code
		WHERE	W.Operational = 1
		AND		W.Warehouse != '#url.warehouse#'
		-- AND		W.Mission = '#getMission.mission#'
		ORDER BY W.Mission, L.Country ASC, L.LocationName ASC
</cfquery>

<cfset vColumns = 3>
<cfset cnt = 0>

<table width="98%" align="center">
	<tr>
		<td>
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font-size:15px; width:250px; padding:5px;"
			   rowclass         = "clsWHRows"
			   rowfields        = "clsWHContent">
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td>
		
			<cfform name="frmAssociation" action="Association/AssociationSubmit.cfm?warehouse=#url.warehouse#&type=#url.type#">
				<table width="100%" class="formspacing">
				
					<cfoutput query="listing" group="Mission">
					
					<tr><td class="labellarge" style="font-size:20px" colspan="#vColumns#">#Mission#</td></tr>
					
					<cfoutput group="LocCountry">

						<tr><td class="labellarge" style="font-size:18px" colspan="#vColumns#">#CountryName#</td></tr>

						<cfoutput group="LocationId">
							
							<cfif LocationName neq "Default">
							<tr><td class="labelmedium" colspan="#vColumns#" style="padding-left:10px;">#LocationName#</td></tr>							
							</cfif>
							<tr>
							
								<cfoutput>
								
									<cfset vSelected = "">
									<cfif warehouse eq selected>
										<cfset vSelected = "background-color:##7EDDF1">
									</cfif>
									<td style="padding-left:5px; width:33%">
										<table width="100%">
											<tr class="clsWHRows">
												<td style="display:none;" class="clsWHContent">#CountryName# #LocationName# #WarehouseName#</td>
												<td id="td_#warehouse#" class="labelit" style="padding:3px; border:1px solid silver; cursor:pointer; #vSelected#">
												   <table cellspacing="0" cellpadding="0">
												    <tr><td>
													<input type="Checkbox" name="cb_#warehouse#" class="radiol" id="cb_#warehouse#" onclick="selectWHA('#warehouse#','##7EDDF1');" <cfif warehouse eq selected>checked</cfif>> 
													</td>
													<td style="padding-left:7px;font-size:17px" class="labelmedium">												
													<label for="cb_#warehouse#">#WarehouseName#</label>
													</td>
													</tr>
													</table>
												</td>
											</tr>
										</table>
									</td>
									<cfset cnt = cnt + 1>
									<cfif cnt gte vColumns>
										</tr>									
										<tr>
										<cfset cnt = 0>
									</cfif>	
																
								</cfoutput>
								
							</tr>							
						</cfoutput>
						
					</cfoutput>
					
					</cfoutput>
					
					<cfoutput>
					<tr><td height="5"></td></tr>
					<tr><td colspan="#vColumns#" class="line"></td></tr>
					<tr><td height="10"></td></tr>
					<tr>
						<td colspan="#vColumns#" align="center">
							<cf_tl id="Save" var="1">
							<input type="Submit" name="btnSubmit" id="btnSubmit" style="width:130" class="button10g" value="#lt_text#">
						</td>
					</tr>
					</cfoutput>
				</table>
			</cfform>
			
		</td>
	</tr>
</table>


