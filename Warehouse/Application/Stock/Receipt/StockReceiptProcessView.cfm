
<cfquery name="getSelectedWarehouse"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  TransferWarehouse
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	Selected = '1'
		AND		TransferWarehouse IS NOT NULL
		
</cfquery>

<cfquery name="getSelectedLocation"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  TransferLocation
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	Selected = '1'
		AND		TransferLocation IS NOT NULL
		
</cfquery>

<cfquery name="getSelectedMemo"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  TransferMemo
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	Selected = '1'
		AND		TransferMemo IS NOT NULL
		
</cfquery>

<cfquery name="getWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  *
		FROM 	Warehouse
		WHERE	1=1 <!--- Warehouse != '#URL.Warehouse#' --->
		AND		Mission = '#url.mission#'
		AND		Operational = 1 
		
</cfquery>

<cfquery name="updateNewSelected"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE 	Receipt#URL.Warehouse#_#SESSION.acc#
		SET		TransferWarehouse = <cfif getSelectedWarehouse.TransferWarehouse eq "">NULL<cfelse>'#getSelectedWarehouse.TransferWarehouse#'</cfif>,
				TransferLocation = <cfif getSelectedLocation.TransferLocation eq "">NULL<cfelse>'#getSelectedLocation.TransferLocation#'</cfif>,
				TransferItemNo = ItemNo,
				TransferUoM = UoM,
				TransferMemo = <cfif getSelectedMemo.TransferMemo eq "">NULL<cfelse>'#getSelectedMemo.TransferMemo#'</cfif>
		WHERE	Selected = '1'
		AND		TransferItemNo IS NULL
		
</cfquery>

<cfquery name="updateNewNotSelected"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE 	Receipt#URL.Warehouse#_#SESSION.acc#
		SET		TransferWarehouse = NULL,
				TransferLocation  = NULL,
				TransferItemNo    = NULL,
				TransferUoM       = NULL,
				TransferQuantity  = Quantity,
				TransferMemo      = NULL
		WHERE	Selected          = '0'
		AND		TransferItemNo IS NOT NULL
		
</cfquery>

<cfquery name="getSelected"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT   *
		FROM 	 Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	 Selected = '1'
		ORDER BY Category, ItemDescription		
</cfquery>

<cfform name="frmProcessReceipt" id="frmProcessReceipt" style="height:100%" onsubmit="return false;">

	<table width="97%" align="center" style="height:100%">
			
			<tr><td height="10"></td></tr>
			<cfif getSelected.recordCount eq 0>
			    <tr><td height="30"></td></tr>
				<tr><td colspan="6" class="linedotted"></td></tr>
				<tr>
					<td height="30" colspan="6" align="center" style="color:808080; font-size:14px;">
					<font face="Calibri" size="3" color="808080"><i><cf_tl id="No pending items to process"></font></td>
				</tr>
				<tr><td height="5"></td></tr>
				<tr><td colspan="6" class="linedotted"></td></tr>
				<tr><td height="5"></td></tr>
				<cfabort>
			</cfif>
			
			<tr>
				<td colspan="6">
					<table width="100%" cellspacing="0" class="formpadding">
						<tr>
							<td class="labelmedium"><cf_tl id="Destination Warehouse"></td>
							<td style="padding-left:10px;">
								<cfoutput>
								<cf_tl id="Select a destination warehouse" var="1">
								<select name="fwarehouse" 
									id="fwarehouse" class="clsWarehouse regularxl" 	style="height:35px;font-size:19px;border:0px;background-color:f1f1f1;width:300" 
									onchange="saveChangeTmpReceipt('#url.mission#','#url.warehouse#','TransferWarehouse',this.value, '', ''); refreshReceiptDetail('#url.mission#','#url.warehouse#');">
									<option value=""> -- #lt_text# --
									<cfloop query="getWarehouse">
										<option value="#warehouse#" <cfif getSelectedWarehouse.TransferWarehouse eq warehouse>selected</cfif>>[#Warehouse#] #WarehouseName#
									</cfloop>
								</select>
								</cfoutput>
							</td>						
							<td style="padding-left:20px;" class="labelmedium"><cf_tl id="Location"></td>
							<td style="padding-left:10px;">
							
								<cf_securediv id="divLocation"
								    bind="url:#SESSION.root#/warehouse/application/stock/receipt/getLocation.cfm?mission=#url.mission#&warehouse=#url.warehouse#&fwarehouse={fwarehouse}&flocation=#getSelectedLocation.TransferLocation#">
									
							</td>
						</tr>					
						<tr>
							<td width="200" class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Memo">:</td>
							<td width="80%" style="padding-left:10px;" colspan="4">
							
							    <cfoutput>
							    <textarea name="Memo" 
								          style="width:100%;height:40;font-size:14px;padding:4px;border:0px;background-color:f4f4f4" 
										  class="regular" 
										  totlength="200"  
										  onkeyup="return ismaxlength(this)"	
								          onchange="saveChangeTmpReceipt('#url.mission#','#url.warehouse#','TransferMemo',this.value, '', '');"><cfoutput>#getSelected.TransferMemo#</cfoutput></textarea>
								</cfoutput>   
								
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<tr>
				<td colspan="6">
					<cf_securediv id="divReceiptProcessDetail"
					  bind="url:#SESSION.root#/warehouse/application/stock/receipt/StockReceiptProcessViewDetail.cfm?mission=#url.mission#&warehouse=#url.warehouse#&fwarehouse=#getSelected.TransferWarehouse#&flocation=#getSelected.TransferLocation#">
				</td>
			</tr>
			
			<tr><td height="5"></td></tr>
			<tr>
				<td colspan="6" align="center">
					<cfset vDisplayTransferBtn = "display:none;">
					<cfif getSelected.TransferWarehouse neq "" and getSelected.TransferLocation neq "">
						<cfset vDisplayTransferBtn = "">
					</cfif>
					<cfoutput>
					<cf_tl id="Transfer Items" var="1">
					<input 
						type="Button" 
						id="btnSubmitTransferItems" 
						name="btnSubmitTransferItems" 
						value="#lt_text#" 
						class="button10g" 
						onclick="submitTransfer('#url.mission#','#url.warehouse#');" 
						style="width:180px;height:30;#vDisplayTransferBtn#">
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td style="height:100%" colspan="6" id="processTempReceipt"></td>
			</tr>
	
	</table>

</cfform>