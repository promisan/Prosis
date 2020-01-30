
<cfparam name="url.strapmeasurement" default="-1">
<cfparam name="url.showtooltip"      default="1">
<cfparam name="url.showUllage"       default="1">
<cfparam name="url.isstrappingtable" default="1">
<cfparam name="url.viewPort" 	 	 default="100">
<cfparam name="url.fontSize"         default="10">

<cfset vSize = round(url.gSize * url.gScale * 100) / 100>					
<cfset vSizeHorizontal = round(url.gSizeHorizontal * url.gScale * 100) / 100>	

<cfset capacity = url.gCapacity>
<cfif capacity eq 0>
	<cfset capacity = 1>
</cfif>

<cfif url.strapmeasurement neq -1>
	
	<cf_getStrappingValue id = "#url.itemlocationid#"
						lookupValue = "#url.strapmeasurement#"
						getType = "quantity">
			
	<cfif resultStrappingValue neq -1>
		<cfset url.strapbalance = resultStrappingValue>
		<cfset url.straplabel = url.strapmeasurement>
	<cfelse>
		<cfset url.strapbalance = 0>		
		<cfset url.straplabel = -1>
	</cfif>
	<cfset url.strapfill = url.strapbalance / capacity>
	
</cfif>

<cfoutput>

<cfset vFillText1 = "On Hand: #lsnumberFormat(url.balance,'#url.itemPrecision#')# #url.UoMDescription#">
<cfif url.filllabel eq -1>
	<cfset vFillText2 = "No strapping reference">
<cfelse>
	<cfset vFillText2 = "#lsnumberFormat(url.filllabel,',._')# units aprox.">
</cfif>
<cfset vStrapText1 = "#lsnumberFormat(strapbalance,'#url.itemPrecision#')# #url.UoMDescription#">
<cfif url.straplabel eq -1>
	<cfset vStrapText2 = "No strapping reference">
<cfelse>
	<cfset vStrapText2 = "#lsnumberFormat(url.straplabel,',._')# units">
</cfif>

<cfset vShowUlage = url.showUllage>
<cfset vUlageText2 = "#lsnumberFormat(url.gCapActual - url.balance,'#url.itemPrecision#')# #url.UoMDescription#">
<cfif (url.gCapActual - url.balance) lte 0>
	<cfset vShowUlage = 0>
</cfif>

<cfset vToolTipFillText = "Stock On Hand">
<cfset vToolTipStrapText = "Strap">

<cfif url.gGraphType eq "loss">
	<cfset vFillText1        = "#url.transactionType# Loss:">
	<cfset vFillText2        = "#lsnumberFormat(fill,',._')#% per #url.strapbalance# transactions">
	<cfset vStrapText1       = "#url.transactionType# Pointer:">
	<cfset vStrapText2       = "#lsnumberFormat(strapbalance,'#url.itemPrecision#')# #url.UoMDescription# (#lsnumberFormat((strapfill),',._')#%)">
	<cfset vToolTipFillText  = "Loss">
	<cfset vToolTipStrapText = "Pointer">
</cfif>

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     I.*
	 FROM       Item I INNER JOIN ItemWarehouseLocation WL ON I.ItemNo = WL.ItemNo AND WL.ItemLocationId = '#url.itemlocationid#'
</cfquery>

<cfset vColor1 = "F99633">
<cfset vColor2 = "FBECBD">
<cfif getItem.ItemColor neq "">
	<cfset vColor1 = "#getItem.ItemColor#">
</cfif>

<cfset vTextSize = url.fontSize>

<cfif url.showTank eq 1>
	#url.gCapacityType# Capacity: #lsnumberFormat(capacity,'#url.itemPrecision#')# #url.UoMDescription#
	<br>
	(Width: #lsNumberFormat(url.tWidth,",._")# cms., Height: #lsNumberFormat(url.tHeight,",._")# cms., Depth: #lsNumberFormat(url.tDepth,",._")# cms.)
	<br>
<cfelseif url.showTank eq 0>
	<br>
	<b>#url.gCapacityType# Capacity</b>
	<br>
	#lsnumberFormat(capacity,'#url.itemPrecision#')# #url.UoMDescription#
	<br>
	(Width: #lsNumberFormat(url.tWidth,",._")# cms., Height: #lsNumberFormat(url.tHeight,",._")# cms., Depth: #lsNumberFormat(url.tDepth,",._")# cms.)
</cfif>

<cfif url.isstrappingtable eq 1>
	
	<table align="center" height="100%" width="100%">

		<tr>
			<td align="center" valign="top">
						
			<cf_GraphTank
				type="#url.gTankType#"
				backgroundcolor="transparent"
				radius="#vSize#"
				radiusHorizontal="#vSizeHorizontal#"
				width="#vSizeHorizontal#"
				height="#vSize#"
				fillPercentage="#fill#"
				color1="#vColor1#"
				color2="#vColor2#"
				textSize="#vTextSize#"	
				textColor="000"	
				iconSize="20"
				opacity="0.5" 			
				borderwidth="5" 
				bordercolor="000"		
				showstrap="#url.showstrap#"
				strapcolor="000"
				strapwidth="3"
				strapfillPercentage="#url.strapfill#"
				strapIcon="left.png"	
				strapText1="#vStrapText1#"
				strapText2="#vStrapText2#"
				showfillmark="1"
				fillIcon="right.png"
				fillText1="#vFillText1#"
				fillText2="#vFillText2#"
				showsublevel="1"
				sublevelPercentage="#url.gActual#"
				sublevelText1="Actual Capacity (#lsnumberFormat(url.gActualLabel,',._')# units aprox.)"
				sublevelText2="#lsnumberFormat(url.gCapActual,'#url.itemPrecision#')# #url.UoMDescription#"
				showminimumlevel="1"
				minimumlevelPercentage="#url.gMinimum#"
				minimumlevelText1="Minimum Stock (#lsnumberFormat(url.gMinimumLabel,',._')# units aprox.)"
				minimumlevelText2="#lsnumberFormat(url.gCapMinimum,'#url.itemPrecision#')# #url.UoMDescription#"
				showUllage = "#vShowUlage#"
				ullageText2="#vUlageText2#"
				pipeimage="pipe-out.png"
				pipesize="60"
				showtooltip="#url.showtooltip#"
				tooltip="#SESSION.root#/tools/StockTank/StockTooltip.cfm?tableSize=#url.viewPort*0.9#&tooltipFontSize=#url.tooltipfontsize#&warehouseName=#url.WarehouseName#&locationName=#url.locationName#&capacity=#capacity#&actualCapacity=#url.gCapActual#&actualLabel=#url.gActualLabel#&minimumCapacity=#url.gCapMinimum#&minimumLabel=#url.gMinimumLabel#&level=#url.filllabel#&balance=#url.balance#&straplevel=#straplabel#&uom=#url.UoMDescription#&strapbalance=#url.strapbalance#&gGraphType=#url.gGraphType#&levelText=#vToolTipFillText#&strapText=#vToolTipStrapText#&itemlocationid=#url.itemlocationid#&showTank=#url.showTank#&ullageText=#vUlageText2#&itemPrecision=#url.itemPrecision#">
				
			</td>
		</tr>
		
	</table>
	
<cfelse>
	<table align="center" height="100%" width="100%">
		<tr><td height="25"></td></tr>
		<tr>
			<td align="center" valign="top">
				<font color="808080"><b>[<cf_tl id="No strapping table defined">]</b></font>
			</td>
		</tr>
		<tr><td height="25"></td></tr>
	</table>
</cfif>
	
</cfoutput>