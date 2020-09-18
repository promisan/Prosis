
<cfparam name="children" default="">
<cfparam name="whslevel" default="0">

<cfoutput>

	<TR class="labelmedium navigation_row clsWarehouseRow line" style="<cfif operational eq "0">color:f4f4f4</cfif>">
		<TD style="display:none;">#City#</td>
		<TD style="padding-left:10px"><cfif operational eq "0"><font color="808080"><i></cfif><cfloop index="itm" from="1" to="#whslevel#">*&nbsp;*&nbsp;&nbsp;</cfloop>#WarehouseName#</TD>	
		<TD class="navigation_action" onclick="edit('#warehouse#')" style="padding-left:10px;padding-right:6px">				    		
			<cf_img icon="edit">		   
		</TD>	
		<TD class="ccontent" height="18"><cfif operational eq "0"><font color="808080"><i></cfif>#Warehouse#</TD>	
		<TD class="ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#classDescription#</TD>
		<TD align="right" style="padding-right:30px"><cfif operational eq "0"><font color="808080"><i></cfif>#locations#</td>
		<TD align="center" style="padding-right:20px">#children#</TD>										
		<TD class="ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#OrgUnitName#</TD>
		<TD><cfif operational eq "0"><font color="808080"><i></cfif>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
	</tr>
	
	<cfset whs = warehouse>
				
	<cfif children gte "1">
		
		<cfset whslevel = whslevel + 1>	
	
		<cfquery name="ChildList#whslevel#" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *, 
			  (SELECT Description FROM Ref_WarehouseClass WHERE Code = W.WarehouseClass) as ClassDescription,
      		  (SELECT count(*) FROM WarehouseLocation WHERE Warehouse = W.Warehouse AND Operational = 1) as Locations,
			  (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND City = W.City) as Cities,
	          (SELECT   TOP 1 OrgUnitName
			   FROM     Organization.dbo.Organization
			   WHERE    MissionOrgUnitId = W.MissionOrgUnitId
			   ORDER BY OrgUnit DESC) as OrgUnitName,
		     (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND SupplyWarehouse = W.Warehouse) as Children
	 			
			FROM   Warehouse W
			WHERE  SupplyWarehouse = '#Whs#' 
			AND    City = '#City#'		 
		</cfquery>
	
		 <cfloop query="ChildList#whslevel#">		
		   							
		   <cfinclude template="RecordListingDetailContent.cfm">			   			
	  	
		</cfloop> 	
		
		<cfset whslevel = whslevel - 1>	
		
		
			
		
	</cfif>
		
</cfoutput>
