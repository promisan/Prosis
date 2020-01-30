<cfquery name="Losses" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT  	L.*,
		 			(SELECT description FROM Ref_LossClass WHERE Code = L.LossClass) as LossClassDescription,
		 			(SELECT description FROM Ref_TransactionClass WHERE Code = L.TransactionClass) as TransactionClassDescription,
					(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemNo#') as ItemDescription,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemNo#' AND UoM = '#url.UoM#') as UoMDescription,
					(SELECT WarehouseName FROM Warehouse WHERE Warehouse = '#url.warehouse#') as WarehouseName,
					(SELECT Description FROM WarehouseLocation WHERE Warehouse = '#url.warehouse#' AND Location = '#url.location#') as WarehouseLocationName
		 FROM      	ItemWarehouseLocationLoss L
		 WHERE		L.Warehouse = '#url.warehouse#'
		 AND       	L.Location = '#url.location#'		
		 AND		L.ItemNo = '#url.itemNo#'
		 AND		L.UoM = '#url.UoM#'
		 ORDER BY L.DateEffective DESC, L.LossClass
</cfquery>

<cfquery name="LocationClass" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	*
		FROM  	Ref_WarehouseLocationClass
		WHERE	Code = '#url.locationclass#'
</cfquery>

<cfquery name="item" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	U.*,
				I.ItemDescription
		FROM  	Item I
				INNER JOIN ItemUoM U
					ON I.ItemNo = U.ItemNo
		WHERE	I.ItemNo = '#url.itemNo#'
		AND		U.UoM = '#url.uom#'
</cfquery>

<cfquery name="wl" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT	WL.*,
				W.WarehouseName
		FROM  	Warehouse W
				INNER JOIN WarehouseLocation WL
					ON W.Warehouse = WL.Warehouse
		WHERE	W.Warehouse = '#url.warehouse#'
		AND		WL.Location = '#url.location#'
</cfquery>

<cf_screentop 
	height="100%" 
	scroll="Yes" 
	html="Yes" 
	label="Acceptable Variance Definition" 
	layout="webapp" 
	banner="yellow" 
	user="no">

<table width="95%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="6">
			<cfoutput>
			<table width="100%" align="center">
				<tr>
					<td height="18" width="15%">Warehouse:</td>
					<td>[#wl.warehouse#] #wl.WarehouseName#</td>
				</tr>
				<tr>
					<td height="18">Location:</td>
					<td>[#wl.location#] #wl.description# - #LocationClass.Description#</td>
				</tr>
				<tr>
					<td height="18">Item:</td>
					<td>#item.ItemDescription# - #item.UoMDescription#</td>
				</tr>
			</table>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td colspan="6" class="line"></td></tr>
	<tr>
		<td height="23" width="10%" align="center">
		</td>
		<td><cf_tl id="Class"></td>
		<td align="left"><cf_tl id="Calculation"></td>
		<td align="left"><cf_tl id="Transaction Class"></td>
		<td align="left"><cf_tl id="Pointer"></td>
		<td align="right"><cf_UIToolTip tooltip="Month losses = Quantity<br>Transaction losses = Percentage"><cf_tl id="Quantity">/<cf_tl id="Percent">.</cf_UIToolTip></td>
	</tr>
	<tr><td colspan="6" class="line"></td></tr>	
		
	<cfoutput query="Losses" group="DateEffective">
		<tr>
			<td colspan="6" height="25" valign="middle">
				<font size="2"><b>#lsDateFormat(DateEffective, CLIENT.DateFormatShow)#</b></font>
			</td>
		</tr>
		<cfoutput>
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF" id="lossRow#currentRow#">
			<td></td>		
			<td height="20">#LossClassDescription#</td>
			<td align="left">#LossCalculation#</td>
			<td align="left">#TransactionClassDescription#</td>
			<td align="left">#lsNumberFormat(AcceptedPointer,",")#</td>
			<td align="right">
			<cfif LossCalculation eq "month">
			#lsNumberFormat(LossQuantity,",._____")#
			<cfelse>
			#lsNumberFormat(LossQuantity*100,",.___")#%
			</cfif>
			</td>
		</tr>
		</cfoutput>
	</cfoutput>
</table>