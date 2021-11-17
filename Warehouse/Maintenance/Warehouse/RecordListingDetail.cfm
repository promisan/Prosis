
<cfset client.fmission = url.fmission>

<cfquery name="SearchResult" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT W.*,	  
	
		   (SELECT Description FROM Ref_WarehouseClass WHERE Code = W.WarehouseClass) as ClassDescription,
	       (SELECT count(*) FROM WarehouseLocation WHERE Warehouse = W.Warehouse AND Operational = 1) as Locations,
		   (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND City = W.City) as Cities,
		   
		   (SELECT TOP 1 OrgUnitName
					FROM   Organization.dbo.Organization
					WHERE  MissionOrgUnitId = W.MissionOrgUnitId
					ORDER BY OrgUnit DESC) as OrgUnitName,
		   
		   (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND SupplyWarehouse = W.Warehouse) as Children
		   
	FROM   Warehouse W, Ref_WarehouseCity C
	
	WHERE  W.Mission = C.Mission
	AND    C.City = W.City
	<cfif url.fmission neq "">
	AND		W.Mission = '#url.fmission#'
	</cfif>
	AND    (SupplyWarehouse = '' OR SupplyWarehouse is NULL OR SupplyWarehouse NOT IN (SELECT Warehouse 
	                                                                                   FROM   Warehouse 
																					   WHERE  Mission = W.Mission 
																					   AND    City = W.City))
	ORDER BY W.Mission, C.ListingOrder, W.City, W.Operational DESC, W.WarehouseClass, W.WarehouseName
</cfquery>

<table width="100%" align="center">
	
	<tr>
	
	<td colspan="2">
	
	<table class="navigation_table" width="100%" align="center">
			
		<tr class="fixrow labelmedium2 line fixlengthlist">
			<td style="display:none;"></td>        
		    <TD><cf_tl id="Description"></TD>	
			<TD height="20"></TD>
			<TD><cf_tl id="Code"></TD>
		    <TD><cf_tl id="Class"></TD>	
			<td align="center"><cf_tl id="Locs"></td>
			<td align="center">S</td>			
		    <TD><cf_tl id="Unit"></TD>	
			<TD><cf_tl id="Entered"></font></TD>	
		</TR>
		
		<cfif SearchResult.recordCount eq 0>
			<tr class="clsWarehouseRow"><td align="center" colspan="9" height="25" class="labelit" style="color:808080">No Facilities recorded<cfif url.fmission neq ""> for <cfoutput>#url.fmission#</cfoutput></cfif></i></td></tr>
			<tr class="clsWarehouseRow"><td height="1" colspan="9" align="right" bgcolor="silver" valign="middle"></td></tr>
		<cfelse>
		
			<CFOUTPUT query="SearchResult" group="Mission">
								
				<tr class="clsWarehouseRow"><td height="8"></td></tr>
				<tr class="clsWarehouseRow line"><TD colspan="8" style="font-size:25px;height:35px;padding-left:0px" class="labelmedium"><b>#Mission#</TD></tr>
				
				<CFOUTPUT group="City">
								
					<tr class="clsWarehouseRow line"><TD colspan="8" style="font-size:22px;height:35px;padding-left:3px">#City# (#cities#)</TD></tr>
													
					<CFOUTPUT>
											
						<cfset level = 0>					
						<cfinclude template="RecordListingDetailContent.cfm">
																								
					</CFOUTPUT>			
						
				</CFOUTPUT>
			
			</CFOUTPUT>
		
		</cfif>
		
		</table>
	
	</td>
	
	</tr>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>