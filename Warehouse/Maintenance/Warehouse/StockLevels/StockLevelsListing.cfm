<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	    SELECT DISTINCT
				W.Warehouse,
				C.Category,
				C.Description as CategoryDescription,
				I.ItemNo,
				I.ItemDescription,
				U.UoM,
				U.UoMDescription
		FROM	ItemWarehouse IW
				INNER JOIN Warehouse W
					ON IW.Warehouse = W.Warehouse
				INNER JOIN Item I
					ON IW.ItemNo = I.ItemNo
				INNER JOIN ItemUoM U
					ON IW.ItemNo = U.ItemNo
					AND IW.UoM = U.UoM
				INNER JOIN ItemUoMMission UM
					ON IW.ItemNo = UM.ItemNo
					AND IW.UoM = UM.UoM
					AND	W.Mission = UM.Mission
				INNER JOIN Ref_Category C
					ON I.Category = C.Category
				INNER JOIN WarehouseCategory WC
					ON WC.Warehouse = IW.Warehouse
					AND WC.Category = I.Category
		WHERE	UM.EnableStockClassification = 1
		AND     U.Operational = 1 
		AND		IW.Warehouse = '#url.warehouse#'
		ORDER BY C.Description, I.ItemDescription, U.UoMDescription
	    
</cfquery>


<cfquery name="getClasses" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	  *
		FROM 	  Ref_StockClass
		ORDER BY  ListingOrder
		
</cfquery>

<cfform 
	name="frmStockLevels" 
	id="frmStockLevels" 
	method="post" 
	action="StockLevels/StockLevelsSubmit.cfm?warehouse=#url.warehouse#">
	
	<table width="95%" align="center" cellpadding="0" cellspacing="0" class="navigation_table">
		<tr><td height="5"></td></tr>
		
		<tr class="line">
			<td class="labelit" width="6%"><cf_tl id="Category"></td>	
			<td class="labelit" width="15%"><cf_tl id="Item"></td>
			<td class="labelit" width="10%"><cf_tl id="UoM"></td>
			<cfoutput query="getClasses">
				<td class="labelit" align="right">#Description#</td>
			</cfoutput>
		</tr>
						
		<cfoutput query="get" group="Category">
			
			<tr>
				<td class="labelmedium" colspan="#getClasses.recordCount + 3#" style="font-weight:bold;">#CategoryDescription#</td>
			</tr>
			
			<cfoutput>
				<tr class="navigation_row">
					<td class="labelit"></td>
					<td class="labelit">#ItemDescription#</td>
					<td class="labelit">#UoMDescription#</td>
					<cfloop query="getClasses">
						<td class="labelit" align="right" style="padding:2px;">
							
							<cfquery name="getValue" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							
									SELECT 	TargetQuantity 
									FROM 	ItemWarehouseStockClass 
									WHERE 	Warehouse = '#get.Warehouse#' 
									AND 	ItemNo = '#get.ItemNo#' 
									AND 	UoM = '#get.UoM#' 
									AND 	StockClass = '#getClasses.Code#'
							
							</cfquery>
							
							<cfinput 
								name="class_#get.itemNo#_#get.uom#_#code#" 
								id="class_#get.itemNo#_#get.uom#_#code#" 
								validate="float" 
								message="Enter a valid float value for #get.ItemDescription# - #get.UoMDescription# - #Description#"
								value="#getValue.TargetQuantity#" 
								class="regularxl" 
								type="text" 
								style="width:70px; text-align:right; padding-right:2px;">
						</td>
					</cfloop>
				</tr>
				<tr><td colspan=""></td></tr>
			</cfoutput>
			
		</cfoutput>
		
		<cfoutput>
		<tr><td height="10"></td></tr>
		<tr><td colspan="#getClasses.recordCount + 3#" class="line"></td></tr>
		<tr><td height="10"></td></tr>
		<tr>
			<td colspan="#getClasses.recordCount + 3#" align="center">
				<cf_tl id="Save" var="1">
				<cf_button type="submit" name="btnSubmit" id="btnSubmit" value="  #lt_text#  ">
			</td>
		</tr>
		</cfoutput>
		
	</table>

</cfform>

<cfset AjaxOnLoad("doHighlight")>