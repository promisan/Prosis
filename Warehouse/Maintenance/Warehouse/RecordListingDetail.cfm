
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
	AND    (SupplyWarehouse = '' OR SupplyWarehouse is NULL or SupplyWarehouse NOT IN (SELECT Warehouse FROM Warehouse WHERE Mission = W.Mission and City = W.City))
	ORDER BY W.Mission, C.ListingOrder, W.City, W.Operational DESC, W.WarehouseClass, W.WarehouseName
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
	
	<td colspan="2">
	
	<table class="navigation_table" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td class="line" colspan="9"></td></tr>
	
	<tr>
		<td style="display:none;"></td>        
	    <TD class="labelit"><cf_tl id="Description"></TD>	
		<TD height="20"></TD>
		<TD class="labelit"><cf_tl id="Code"></TD>
	    <TD class="labelit"><cf_tl id="Class"></TD>	
		<td class="labelit" align="right" style="padding-right:20px"><cf_tl id="Locs"></td>
		<td class="labelit" align="center" style="padding-right:20px">S</td>
		<!---
	    <TD class="label"><cf_tl id="Phone"></TD>	
		--->
	    <TD class="labelit"><cf_tl id="Unit"></TD>	
		<TD class="labelit"><cf_tl id="Entered"></font></TD>	
	</TR>
	
	<tr><td class="line" colspan="9"></td></tr>
	
	<cfif SearchResult.recordCount eq 0>
		<tr class="clsWarehouseRow"><td align="center" colspan="9" height="25" class="labelit" style="color:808080">No Facilities recorded<cfif url.fmission neq ""> for <cfoutput>#url.fmission#</cfoutput></cfif></i></td></tr>
		<tr class="clsWarehouseRow"><td height="1" colspan="9" align="right" bgcolor="silver" valign="middle"></td></tr>
	<cfelse>
		
		<CFOUTPUT query="SearchResult" group="Mission">
							
			<tr class="clsWarehouseRow"><td height="8"></td></tr>
			<tr class="clsWarehouseRow"><TD colspan="3" class="labellarge"><b>#Mission#</TD></tr>
			<tr class="clsWarehouseRow"><td height="2"></td></tr>
			<tr class="clsWarehouseRow"><td colspan="8" class="line"></td></tr>
			<tr class="clsWarehouseRow"><td height="3"></td></tr>
		
		<CFOUTPUT group="City">
		
			<tr class="clsWarehouseRow"><td height="5"></td></tr>
			<tr class="clsWarehouseRow"><TD colspan="3" style="padding-left:3px"><font face="Verdana" size="2">#City# (#cities#)</TD></tr>
			<tr class="clsWarehouseRow"><td height="4"></td></tr>
			<tr class="clsWarehouseRow"><td colspan="9" class="line"></td></tr>
			<tr class="clsWarehouseRow"><td height="4"></td></tr>
			
		<CFOUTPUT>
								
			<TR class="navigation_row clsWarehouseRow" <cfif operational eq "0">style="color:f4f4f4;"</cfif>>
			    <cfset level = 0>
				<cfinclude template="RecordListingDetailContent.cfm">
			</TR>		
			
			<cfif children gte "1">
			
			<cfquery name="ChildList" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *,
				  (SELECT Description FROM Ref_WarehouseClass WHERE Code = W.WarehouseClass) as ClassDescription,
	      		  (SELECT count(*) FROM WarehouseLocation WHERE Warehouse = W.Warehouse AND Operational = 1) as Locations,
				  (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND City = W.City) as Cities,
		          (SELECT TOP 1 OrgUnitName
							FROM   Organization.dbo.Organization
							WHERE  MissionOrgUnitId = W.MissionOrgUnitId
							ORDER BY OrgUnit DESC) as OrgUnitName,
			     (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND SupplyWarehouse = W.Warehouse) as Children
		 			
				FROM   Warehouse W
				WHERE  SupplyWarehouse = '#Warehouse#' and City = '#City#'		 
			</cfquery>
			
			<cfloop query="ChildList">
			<tr class="clsWarehouseRow navigation_row">
				<cfset level = "1">
				<cfinclude template="RecordListingDetailContent.cfm">			
		  	</tr>
			</cfloop> 
			
			</cfif>
			<tr class="clsWarehouseRow"><td bgcolor="f8f8f8" colspan="9"></td></tr>
			
		</CFOUTPUT>
		
		<tr class="clsWarehouseRow"><td class="line" colspan="9"></td></tr>
		
		</CFOUTPUT>
		
		</CFOUTPUT>
	
	</cfif>
	
	</TABLE>
	
	</td>
	
	</tr>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>