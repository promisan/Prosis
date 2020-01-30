
<!--- eMail of sales --->

<cfparam name="attributes.BatchId" default="BBA46599-AAB2-6219-3BE7-BE282B60E820">

<cfset batchid = attributes.batchid>

<cfquery name="Header" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   WB.Mission, 
		         W.Warehouse, W.WarehouseName, W.City, W.Address, W.Telephone, M.MissionName, WB.BatchNo, W.eMailAddress, 
				 C.CustomerName, 
				 CustomerIdInvoice,
				 WB.TransactionDate, 
                 C.Reference
	    FROM     WarehouseBatch WB INNER JOIN
                 Warehouse W ON WB.BatchWarehouse = W.Warehouse INNER JOIN
                 Organization.dbo.Ref_Mission M ON WB.Mission = M.Mission INNER JOIN
                 Customer C ON WB.CustomerIdInvoice = C.CustomerId
		WHERE    WB.BatchId = '#batchId#'       
</cfquery>

<cfquery name="Customer" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
	    FROM     Customer
		WHERE    CustomerId = '#Header.customeridinvoice#'       
</cfquery>

<cfif isValid("email","#Customer.eMailAddress#")>

	<cfquery name="Lines" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   
		   SELECT     WB.Mission, 
		              WB.BatchNo, 
					  WB.TransactionDate, 
					  T.ItemNo, 
					  T.ItemDescription, 
					  T.TransactionUoM, 
					  B.ItemBarCode, 
					  T.TransactionQuantity, 
					  TS.SalesCurrency, 
	                  TS.SalesPrice, 
					  TS.SalesAmount, 
					  TS.SalesTax, 
					  TS.SalesTotal
		   FROM       WarehouseBatch WB INNER JOIN
	                  ItemTransaction T ON WB.BatchNo = T.TransactionBatchNo INNER JOIN
	                  ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId LEFT OUTER JOIN
	                  ItemUoMMissionLot B ON T.ItemNo = B.ItemNo AND T.Mission = B.Mission AND T.TransactionUoM = B.UoM AND T.TransactionLot = B.TransactionLot
		   WHERE      WB.BatchId = '#batchId#'
				
	</cfquery>
	
	<cfquery name="Settle" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT     *
		   FROM       WarehouseBatchSettlement
		   WHERE      BatchNo = '#Header.BatchNo#'
	</cfquery>	   
	
	<cfquery name="Footer" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT * FROM WarehouseJournal
		   WHERE  Warehouse = '#Header.Warehouse#'
		   AND    Area      = 'SETTLE'
		   AND    Currency  = '#Lines.SalesCurrency#'
	</cfquery>	   
	
	<cfoutput>
	
	<cfif Header.eMailAddress eq "">
		<cfset frommail = "noreply@promisan.com">
	<cfelse>
	    <cfset frommail = "#Header.eMailAddress#">
	</cfif>
	
	<cfmail to="#Customer.eMailAddress#" from="#frommail#" subject="Receipt #Header.MissionName#" type="HTML" spoolEnable="Yes">
	
		<cfloop query="Header">
		
		<table width="600">
		<tr><td colspan="2" style="padding-left:10px;font-size:36px;font-family: Calibri;">#MissionName# #WarehouseName#</td></tr>
		<tr><td colspan="2" style="padding-left:10px;font-size:28px;font-family: Calibri;">#City# #Address#</td></tr>
		<tr><td colspan="2" style="padding-left:10px;font-size:20px;font-family: Calibri;">#Telephone#</td></tr>
		<tr><td colspan="2" style="height:20"></td></tr>
		<tr>
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;">#CustomerName# #Reference#</td>
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;" align="right">#DateFormat(TransactionDate,client.dateformatshow)# #TimeFormat(TransactionDate,"HH:MM")#</td>
		</tr>
		<tr>
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;"><b><cf_tl id="TransactionNo"></b></td>	
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;" align="right"><b>#BatchNo#</td>	
		</tr>
		<tr>
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;"><b><cf_tl id="Tax reference"></b></td>	
			<td style="padding-left:10px;font-size:20px;font-family: Calibri; font-size: medium;" align="right">------</td>	
		</tr>
		<tr><td style="padding-top:10px;padding-left:10px" colspan="2">
			
			<table width="100%" cellspacing="0" cellpadding="0">
			
				 <tr>
				    <td style="width:300px;border-bottom:1px solid silver;font-family: Calibri; font-size: medium;"><cf_tl id="Item"></td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;"><cf_tl id="SKU"></td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;"><cf_tl id="Qty"></td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;" align="right"><cf_tl id="Amount"> #Lines.SalesCurrency#</td>
				</tr>
				
				<cfset am = 0>
				<cfset tx = 0>
				
				<cfloop query="Lines">
				
				<cfset tx = tx+SalesTax>
				<cfset am = am+SalesAmount>
				
			    <tr>
				    <td style="width:300px;border-bottom:1px solid silver;font-family: Calibri; font-size: medium;">#ItemDescription#</td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;"><cfif ItemBarCode neq "">#ItemBarCode#<cfelse>#ItemNo#</cfif></td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;">#TransactionQuantity*-1#</td>
					<td style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;" align="right">#numberformat(SalesAmount,".__")#</td>
				</tr>	
						
				</cfloop>
				
				<tr><td style="height:4px"></td></tr>
								
				<tr><td colspan="3" align="right" style="height:30px;font-family: Calibri; font-size: medium;"><cf_tl id="Subtotal"></td>
				    <td align="right" style="font-family: Calibri; font-size: medium;">#numberformat(am,".__")#</td>
				</tr>
				<tr><td colspan="3" align="right" style="height:30px;font-family: Calibri; font-size: medium;"><cf_tl id="Taxes"></td>
				    <td align="right" style="font-family: Calibri; font-size: medium;">#numberformat(tx,".__")#</td>
				</tr>
				<tr><td colspan="3" align="right" style="border-bottom:1px solid silver;height:30px;font-family: Calibri; font-size: medium;"><b><cf_tl id="Total"></td>
				    <td align="right" style="border-bottom:1px solid silver;font-family: Calibri; font-size: medium;">#numberformat(am+tx,".__")#</td>
				</tr>
								
				<cfset se = 0>
				
				<cfloop query="settle">
				<cfset se = se+SettleAmount>
				<tr><td colspan="3" align="right" style="height:30px;font-family: Calibri; font-size: medium;">#SettleCode# #BankName#</td>
				    <td align="right" style="font-family: Calibri; font-size: medium;">#numberformat(SettleAmount,".__")#</td>
				</tr>
				</cfloop>
				
				<tr><td colspan="3" align="right" style="height:30px;font-family: Calibri; font-size: medium;"><b><cf_tl id="Total Paid"></td>
				    <td align="right" style="font-family: Calibri; font-size: medium;">#numberformat(se,".__")#</td>
				</tr>
				<tr><td colspan="4" style="border-bottom:1px solid silver;"></td></tr>
				
			</table>
		
		</td></tr>
		
		<tr><td colspan="2" style="padding-top:20px;padding-left:10px;font-size:20px;font-family: Calibri; font-size: x-small;" align="center">#Footer.TransactionMemo#</td></tr>		
		<tr><td colspan="2" align="right" style="padding-top:20px;padding-left:10px;font-size:20px;font-family: Calibri; font-size: small;">Powered by Prosis TM</td></tr>
			
		</table>
		
		</cfloop>
	
	</cfmail>
	
	</cfoutput>
	
</cfif>	