
<script>
	lastStrapRow = null;
</script>

<cfquery name="WarehouseLocation" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	L.*, W.warehouseName		 
		 FROM      	WarehouseLocation L,
		 			Warehouse W
		 WHERE     	W.warehouse = L.warehouse
		 AND		W.Warehouse = '#url.warehouse#'
		 AND       	L.Location  = '#url.location#'		
</cfquery>

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *,
			    (SELECT ISNULL(COUNT(*),0) FROM ItemWarehouseLocationStrapping WHERE Warehouse = '#url.warehouse#' AND Location = '#url.location#' AND ItemNo = '#url.itemNo#' AND UoM = '#url.UoM#') AS Strapping,				
	 			(SELECT ItemDescription FROM Item   WHERE ItemNo = '#url.itemNo#') as ItemDescription,
				(SELECT ItemPrecision FROM Item     WHERE ItemNo = '#url.itemNo#') as ItemPrecision,
				(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemNo#' AND UoM = '#url.uom#') as UoMDescription
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location  = '#url.location#'		
	 AND		ItemNo    = '#url.itemNo#'
	 AND		UoM       = '#url.UoM#'
</cfquery>

<cfquery name="getUoM" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       ItemUoM
	 WHERE		ItemNo = '#url.itemNo#'
	 AND		UoM    = '#url.UoM#'
</cfquery>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT 	*
		 FROM      	ItemWarehouseLocationStrapping
		 WHERE		Warehouse = '#url.warehouse#'
		 AND       	Location  = '#url.location#'		
		 AND		ItemNo    = '#url.itemNo#'
		 AND		UoM       = '#url.UoM#'
		 ORDER BY Measurement ASC
</cfquery>

<cfset vLink = "#SESSION.root#/warehouse/maintenance/WarehouseLocation/LocationItemStrapping/StrappingGraph.cfm">				
<cfset vParameters = "warehouse=#url.warehouse#&location=#url.location#&itemno=#url.itemno#&uom=#url.uom#">


<cfoutput>
<table width="98%" align="center">
	
	<!--- quick check of strapping --->
		
	<tr>
	
		<td class="labelit"><cf_tl id="Inquiry">:</td>
		<td width="120" class="labelit">
			<input type="Text" 
			   name="txtMeasurementGM" 
			   id="txtMeasurementGM" 
			   class="regularxl"
			   maxlength="10"
			   size="3"
			   value="0" 
			   style="text-align:center;">
			&nbsp;units&nbsp;
		 	<input type="Button" 
			   name="btnMeasurementGM" 
			   id="btnMeasurementGM"
			   class="button10g"
			   value="are" 
			   style="text-align:center; height:18px; width:30px;" 
			   onclick="ColdFusion.navigate('../LocationItemStrapping/StrappingListGetMeasurement.cfm?id=#getItem.ItemLocationId#&uomDescription=#getUoM.UoMDescription#&measurement=' + document.getElementById('txtMeasurementGM').value+'&strappingRelation=#WarehouseLocation.StorageHeight / getItem.strappingScale#&strappingIncrement=#getItem.strappingIncrement#&strappingScale=#getItem.strappingScale#', 'divGetMeasurement');ColdFusion.navigate('#vLink#?#vParameters#&strappingLevel='+document.getElementById('txtMeasurementGM').value,'divGraphTank');">
		</td>
		<td>
			<cfdiv id="divGetMeasurement" 
			 bind="url:../LocationItemStrapping/StrappingListGetMeasurement.cfm?id=#getItem.ItemLocationId#&uomDescription=#getUoM.UoMDescription#&measurement=0&strappingRelation=#WarehouseLocation.StorageHeight / getItem.strappingScale#&strappingIncrement=#getItem.strappingIncrement#&strappingScale=#getItem.strappingScale#">
		</td>
	</tr>
				
	<tr>
	    <td class="labelit">Strapping List</td>
		<td colspan="2" align="right" style="padding-right:10px">
			<img src="#SESSION.root#/Images/copy.png" title="Copy Strapping Table" style="cursor: pointer;" height="15" border="0" align="middle" 
				onClick="javascript: ColdFusion.Window.show('StrappingCopy');">
			&nbsp;
			<img src="#SESSION.root#/Images/edit.gif" title="Edit Strapping Table" style="cursor: pointer;" height="15" border="0" align="middle" 
				onClick="javascript: ColdFusion.Window.show('StrappingEdit');">
			&nbsp;
			<img src="#SESSION.root#/Images/delete5.gif" title="Remove Strapping Table" style="cursor: pointer;" height="15" border="0" align="middle" 
				onClick="javascript: if (confirm('Do you want to remove this complete strapping table ?')) { ColdFusion.navigate('../LocationItemStrapping/StrappingListDelete.cfm?id=#getItem.ItemLocationId#', 'contentbox2'); }">
		</td>	
	</tr>
		
</table>

<table width="100%" align="center">
	<tr>
		<td valign="top">
		
		<div class="relative">
		
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
		
			<tr>
			
				<cfset straprows = 76>				
				<cfset rowCount  = 1>
				
				<cfloop query="Strapping">
				
					<cfset vStrapQuantity = Quantity>
					<cfset vStrapLabel = Measurement>
					<cfset vStrapFill  = (Measurement * WarehouseLocation.storageHeight / getItem.strappingScale) / WarehouseLocation.StorageHeight>
					
					<cfif currentrow eq 1>
					<td valign="top">
					
					<table width="100%" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td valign="top">
					</cfif>	
										
					<table width="90%" cellspacing="0" cellpadding="0" align="center">
					
						<tr	id="strapRow#currentRow#" 
							style="cursor:pointer; <cfif currentrow eq 1>background-color:E1EDFF;</cfif>"
							onclick="_cf_loadingtexthtml='';selectStrap(this); ColdFusion.navigate('#vLink#?#vParameters#&strappingLevel=#measurement#','divGraphTank');">
							
							<td height="15"  							    
								width="50" 
								style="padding-left:3px" class="labelit">
								<font face="Arial" size="1" color="gray">
								#lsNumberFormat(Measurement,",._")#
								</font>
							</td>
							
							<td align="center" class="labelit">=&nbsp;
							</td>
							
							<td align="center" 
							    width="50%" 
								style="padding:2px;" class="labelit">
								<cfif quantity eq 0 and measurement neq 0>--<cfelse>#lsNumberFormat(Quantity,",._")#</cfif>
							</td>	
																
						</tr>		
														
					</table>								
					
					<cfif currentrow eq strapping.recordCount or rowCount eq straprows>
						</td>			
						<td width="2"></td>			
						<td valign="top">
						<cfset rowCount = 0>
					</cfif>
					
					<cfif currentrow eq strapping.recordCount>						
					</tr>											
					</table>
					</td>
										
					</cfif>																
					<cfset rowCount = rowCount + 1>					
				</cfloop>
			</tr>
		</table>
		</div>
		</td>
	</tr>	
</table>
</cfoutput>

