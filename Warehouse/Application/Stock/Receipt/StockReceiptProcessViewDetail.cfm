<cfquery name="getSelected"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  R.*,
				(
					SELECT 	Category 
					FROM 	Materials.dbo.WarehouseCategory 
					WHERE 	Warehouse = '#url.fwarehouse#' 
					AND 	Category = R.Category 
					AND 	Operational = 1
				) as ValidCategory,
				(
					SELECT 	ItemNo 
					FROM 	Materials.dbo.ItemWarehouseLocation 
					WHERE 	Warehouse = '#url.fwarehouse#' 
					AND 	Location = '#url.flocation#' 
					AND 	ItemNo = R.TransferItemNo 
					AND 	UoM = R.TransferUoM 
					AND 	Operational = 1
				) as ValidItem,
				(
					SELECT 	ModeSetItem 
					FROM 	Materials.dbo.Warehouse 
					WHERE 	Warehouse = '#url.fwarehouse#'
				) as ModeSetItem
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc# R
		WHERE	R.Selected = '1'
		ORDER BY R.Category, R.ItemDescription
		
</cfquery>

<!-- <cfform name="frmProcessReceipt" id="frmProcessReceipt" onsubmit="return false;"> -->

<table width="100%"align="center" class="formpadding">

	<tr class="line fixrow labelmedium">
		<td width="3%"></td>
		<td align="center" width="4%" height="20"><cf_tl id="No."></td>
		<td width="8%"><cf_tl id="Item"></td>
		<td width="10%"><cf_tl id="Barcode"></td>
		<td><cf_tl id="Description"></td>
		<td width="10%" align="center"><cf_tl id="Unit"></td>
		<td width="10%" align="right" style="padding-right:10px;"><cf_tl id="Qty"></td>
	</tr>
		
	<cfset dirtyCount = 0>
	<cfoutput query="getSelected" group="category">
	
		<tr>
			<td height="30" colspan="7" class="labellarge">#categoryDescription#</td>
		</tr>
		
		<cfoutput>
		
			<cfset vItemColor = "">
			<cfset vItemMessage = "">
			<cfset vShowQuantity = 1>
			
			<cfif lcase(ModeSetItem) eq "category">
				
				<cfif Category neq ValidCategory>
					<cfset vItemColor = "background-color:FED6DE;">
					<cfset vItemMessage = "title='The item category is not supported by the destination warehouse'">
					<cfset vShowQuantity = 0>
				</cfif>
			
			<cfelseif lcase(ModeSetItem) eq "location">
			
				<cfif TransferItemNo neq ValidItem>
					<cfset vItemColor = "background-color:FED6DE;">
					<cfset vItemMessage = "title='This item is not supported by the destination warehouse and location'">
					<cfset vShowQuantity = 0>
				</cfif>
			
			</cfif>
			
			<cfif url.fwarehouse eq "" or url.flocation eq "">
				<cfset vItemColor = "">
				<cfset vItemMessage = "">
				<cfset vShowQuantity = 1>
			</cfif>			
			
			<tr class="line labelmedium" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="" style="#vItemColor#" #vItemMessage#>
			
				<td align="center" style="padding-top:1px; padding-left:5px;">
					<cf_img icon="delete" onclick="removeReceiptTemp('#url.mission#','#url.warehouse#',#transactionId#)">
				</td>
				
				<td align="center" class="labelit">#currentrow#</td>
				<td>
					<table cellspacing="0" cellpadding="0">
						<tr class="labelmedium">
							<td>
								<cf_tl id="view item detail" var="1">
								<a href="javascript: itemopen('#ItemNo#','');" style="cursor:pointer; color:1E70D2;" title="#lt_text#" tabindex="9999">#ItemNo#</a>
							</td>
							<td valign="middle" style="padding-left:8px;">
								<cfset vDisplayTwistie = "display:none;">
								<cfif TransferWarehouse neq "" and TransferLocation neq "">
									<cfset vDisplayTwistie = "">
								</cfif>
								<cf_tl id="click to show price definition" var="1">
								<img src="#SESSION.root#/images/expand.png" 
									 class="clsTwistiePrices" 
									 id="twistiePrice_#transactionId#" 
									 height="11" 
									 align="absmiddle" 
									 title="#lt_text#"
									 style="cursor:pointer; #vDisplayTwistie#" 
									 onclick="toggleReceiptPriceDetail('#url.mission#','#url.warehouse#','#transferWarehouse#','#transactionId#','#currentrow#','targetPriceDetail_#transactionId#', 'Process');">
							</td>
						</tr>
					</table>
				</td>
				<td>#ItemBarcode#</td>
				<td>#ItemDescription#</td>
				<td align="center">#UoMDescription#</td>
				<td align="right" style="padding-right:10px;">
				
					<cfif vShowQuantity eq 1>
						<cf_tl id="Enter a valid integer quantity between 1 and" var="1">
						<cfset vMesInit = "#lt_text#">
						<cf_tl id="for barcode" var="1">
						<cfset vMesEnd = "#lt_text#">

						<cfinput type="Text" 
							name="quantity_#TransactionId#" 
							id="quantity_#TransactionId#" 
							value="#TransferQuantity#" 
							required="Yes" 
							validate="integer" 
							message="#vMesInit# #Quantity# #vMesEnd# #ItemBarcode#" 
							range="1,#Quantity#"							
							size="6" 
							maxlength="8" 
							class="regularxl enterastab" 
							style="text-align:right; padding-right:2px;border:0px;background-color:f1f1f1"
							onchange="saveChangeTmpReceipt('#url.mission#','#url.warehouse#','TransferQuantity',this.value, '#transactionId#', '#quantity#');">
							
					<cfelse>
					
						N/A
						<input type="Hidden" name="quantity_#TransactionId#" id="quantity_#transactionid#" value="0">
						<cfset dirtyCount = dirtyCount + 1>
						
					</cfif>
				</td>
			</tr>
			
			<tr>
				<td colspan="7" id="priceDetail_#transactionId#" style="display:none; width:100%; overflow:auto;">
					
					<table width="100%" height="100%">
						<tr>
							<td valign="top" align="right" width="10%">
								<img src="#SESSION.root#/images/join.gif">
							</td>
							<td style="padding-left:3px;" width="90%" height="100%" id="targetPriceDetail_#transactionId#"></td>
						</tr>
						<tr><td height="10"></td></tr>
					</table>
					
				</td>
			</tr>
			
		</cfoutput>
		
	</cfoutput>
</table>
<cf_tl id="Transfer has been submitted" var="1">
<cf_tl id="Stock on hand balances have been adjusted" var="1">
<!-- </cfform> -->

<cfif dirtyCount eq getSelected.recordCount>
	<script>
		document.getElementById('btnSubmitTransferItems').style.display = 'none';
	</script>
</cfif>