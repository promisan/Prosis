<cfoutput query="ItemUoM">
			
		<cfset rowcnt = rowcnt + 1>
		<cfset measure = uom>
				
		<cfquery name="whs"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   ItemWarehouse
			<cfif w neq "">
			WHERE  Warehouse = '#W#'			
			<cfelse>
			WHERE  1=1
			</cfif>
			AND    ItemNo    = '#URL.ID#'
			AND    UoM       = '#UoM#'
			AND    Operational = 1
		</cfquery>	
						
		<cfif whs.recordcount gte "1">
												
			<tr class="labelmedium2 line fixrow">
				<td height="25" style="padding-left:3px">UoM:</td>
				<td style="background-color:ffffaf">#UoMDescription# [#ItemBarCode#]</td>
				<td style="padding-left:4px"><cf_tl id="Effective"></td>
				<td></td>
				<td><cf_tl id="Promo"></td>
				<td><cf_tl id="Currency"></td>
				<td style="width:100px" align="right"><cf_tl id="Last Receipt"></td>
				<td style="width:100px" align="right"><cf_tl id="Last Order"></td>
				<td style="width:100px" align="right"><cf_tl id="Last Cost"></td>
				<td style="width:100px;padding-right:5px" align="right"><cf_tl id="Proposed"></td>
				<td style="width:100px;padding-right:5px" align="right"><cf_tl id="Price"></td>
				<td align="right"><cf_tl id="Tax"></td>
				<td></td>
			</tr>
				
			<cfquery name="Schedule"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT  *
				FROM    Ref_PriceSchedule
				WHERE   Code IN (SELECT PriceSchedule
				                 FROM   WarehouseCategoryPriceSchedule
								 <cfif w neq "">
						         WHERE  Warehouse  = '#Warehouse.Warehouse#'
								 <cfelse>
								 WHERE  Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#url.mission#')
								 </cfif>
						         AND    Category   = '#Item.Category#'
								 AND    Operational = 1)									 	
			</cfquery>
			
			<cfif Schedule.recordcount eq "0">
			
				<tr class="labelmedium2 line" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''">
				   <td colspan="11" align="center" style="height:40px;font-size:18px">This item category : #Item.Category# is not declared for any warehouse in #url.mission#</td>
				</tr>   
			
			</cfif>
					
			<cfloop query="Schedule">			
				
				<tr class="labelmedium line" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''">
					
					<td align="center">
						
						<cf_tl id="Show price history" var="1">
						
						<img src="#session.root#/images/history2.png" 
							 style="cursor:pointer; height:14px;" 
							 title="#lt_text#"
							 onclick="showPricingHistory('#url.id#', '#Measure#', '#Code#', '#w#', '#url.mission#');">
							 
					</td>
					
					<td valign="top" style="font-size:15px;padding-top:4px;">#Description#</td>
																										
					<cfquery name="Currency" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Accounting.dbo.Currency
						WHERE  EnableProcurement = 1
						AND	   Currency IN (SELECT Currency
							                 FROM   WarehouseCategoryPriceSchedule		
									         <cfif w neq "">
											 WHERE  Warehouse     = '#w#'
											 <cfelse>
											 WHERE  Warehouse IN (#quotedvalueList(whs.warehouse)#) 
											 </cfif>
									         AND    Category   = '#Item.Category#'
											 AND    PriceSchedule = '#code#'
											 AND    Operational = 1)
					</cfquery>
																														
					<cfloop query="Currency">						
																		
						<cfquery name="line"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     TOP 2 *
							FROM       ItemUoMPrice
							WHERE      ItemNo        = '#url.id#'
							AND        UoM           = '#measure#'
							AND        PriceSchedule = '#Schedule.Code#' 
							AND        Mission       = '#URL.Mission#' 
							<cfif w neq "">
							AND        Warehouse     = '#w#'
							<cfelse>
							AND        Warehouse is NULL 
							</cfif>
							AND        Currency      = '#currency#'			
							ORDER BY   DateEffective DESC
						</cfquery>
													
						<td style="min-width:100px">
													
						<cfif line.dateeffective eq "">
																				
							<cf_intelliCalendarDate9
							    class="regularxl"
								FieldName="#w#_#measure#_#Schedule.code#_#currency#_DateEffective" 
								Default="#dateformat(now(),CLIENT.DateFormatShow)#"
								message="Enter a valid price"								
								Tooltip="Effective Date"
								Style="border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:center"
								AllowBlank="False">	
							
						<cfelse>
						
							<cfif line.dateEffective lt now()>
							
								<cf_intelliCalendarDate9
									FieldName="#w#_#measure#_#Schedule.code#_#currency#_DateEffective" 
									Default="#dateformat(now(),CLIENT.DateFormatShow)#"
									message="Enter a valid price"
									class="regularxl"
									DateValidStart="#Dateformat(line.dateeffective, 'YYYYMMDD')#"
									Tooltip="Effective Date"
									Style="border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:center"
									AllowBlank="False">	
									
							<cfelse>
							
								<cf_intelliCalendarDate9
									FieldName="#w#_#measure#_#Schedule.code#_#currency#_DateEffective" 
									Default="#dateformat(line.dateEffective,CLIENT.DateFormatShow)#"
									message="Enter a valid price"
									class="regularxl"
									DateValidStart="#Dateformat(line.dateeffective, 'YYYYMMDD')#"
									Tooltip="Effective Date"
									Style="border:0px;border-left:1px solid silver;border-right:1px solid silver;text-align:center"
									AllowBlank="False">	
									
							</cfif>
						
						</cfif>	
													
						</td>	
						
						<td><cfif line.recordcount gt "1">H</cfif></td>	
						
						<td>
						
						<input type="checkbox" name="#w#_#measure#_#Schedule.code#_#currency#_Promotion" class="Radiol" <cfif line.promotion eq "1">checked</cfif> value="1">
						
						</td>	
						
						<td style="padding-left:3px;padding-right:3px">#Currency#</td>
						
						<cfquery name="Transaction"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT     *
								FROM       ItemTransaction
								WHERE      ItemNo             = '#url.id#'
								AND        TransactionUoM     = '#measure#'
								AND        Mission            = '#url.mission#'
								AND        TransactionType    = '1'
								ORDER BY   Created DESC
							</cfquery>	
							
							<cfif Transaction.recordcount eq "0">
							
								<cfquery name="Transaction"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT     *
									FROM       ItemTransaction
									WHERE      ItemNo             = '#url.id#'
									AND        TransactionUoM     = '#measure#'								
									AND        TransactionType    = '1'
									ORDER BY   Created DESC
								</cfquery>	
														
							</cfif>
						
						<td style="padding-left:3px;padding-right:6px" align="right">						
							#dateformat(Transaction.TransactionDate,client.dateformatshow)#						
						</td>
						
						<td style="padding-left:3px;padding-right:6px" align="right">
						
							<cfquery name="Purchase"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT     TOP 1 *
								FROM       Purchase.dbo.PurchaseLineReceipt
								WHERE      WarehouseItemNo        = '#url.id#'
								AND        WarehouseUoM           = '#measure#'				
								AND        ActionStatus != '9'									       
								AND        ReceiptNo IN (SELECT ReceiptNo 
								                         FROM   Purchase.dbo.Receipt 
														 WHERE  Mission = '#url.mission#')														 
								ORDER BY Created DESC
							</cfquery>	
							
							<cfif Purchase.recordcount eq "0">
							
								<cfquery name="Purchase"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT     TOP 1 *
									FROM       Purchase.dbo.PurchaseLineReceipt
									WHERE      WarehouseItemNo        = '#url.id#'
									AND        WarehouseUoM           = '#measure#'				
									AND        ActionStatus != '9'									       																		 
									ORDER BY Created DESC
								</cfquery>	
														
							</cfif>
							
							<cfif Purchase.recordCount gt 0>
								<cfif Purchase.WarehousePrice eq "">
									<cfif currency neq purchase.currency>#purchase.Currency#</cfif> #numberformat(Purchase.ReceiptPrice/Purchase.ReceiptMultiplier,'.,__')#																
								<cfelseif Purchase.WarehouseCurrency eq Currency or Purchase.WarehouseCurrency eq "">											
									#numberformat(Purchase.WarehousePrice,'.,___')#							
								<cfelse>						
									<cf_exchangeRate Currencyfrom="#Purchase.WarehouseCurrency#" CurrencyTo="#currency#">
									#numberformat(Purchase.WarehousePrice/exc,'.,___')#																
								</cfif>
							<cfelse>
								----
							</cfif>
						
						</td>
						
						<td style="padding-left:3px;padding-right:6px" align="right">
																							
							<cfif application.BaseCurrency eq Currency>												
								#numberformat(Transaction.TransactionCostPrice,'.,___')#								
							<cfelse>							
								<cf_exchangeRate Currencyfrom="#application.BaseCurrency#" CurrencyTo="#currency#">
								#numberformat(Transaction.TransactionCostPrice/exc,'.,___')#																	
							</cfif>				
						
						</td>
						
						<td style="padding-left:3px;padding-right:6px" align="right">
						----
						</td>
								
												
						<td align="right" style="padding-right:5px">
						
							<cfif Line.salesPrice eq "">
							
								<cfinput type="Text" 
							   name="#w#_#measure#_#Schedule.code#_#currency#_SalesPrice" 
							   value="" 
							   message="Enter a valid price" 
							   validate="float" 
							   class="regularxl"
							   required="No" 
							   size="10" 
							   maxlength="12" 
							   style="background-color:f1f1f1;text-align: right;border:0px;border-left:1px solid silver;border-right:1px solid silver">
							
							<cfelse>
						
							<cfinput type="Text" 
							   name="#w#_#measure#_#Schedule.code#_#currency#_SalesPrice" 
							   value="#numberFormat(Line.SalesPrice,".__")#" 
							   message="Enter a valid price" 
							   validate="float" 
							   class="regularxl"
							   required="No" 
							   size="10" 
							   maxlength="12" 
							   style="text-align: right;border:0px;border-left:1px solid silver;border-right:1px solid silver">				
							   
							 </cfif>  
							   
						</td>
												
						<td style="padding-left:3px;height:28px;" align="right">
						
						    <cfif w eq "">
						
							<cfquery name="Tax"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT     *
								FROM       WarehouseCategory
								WHERE      Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#url.mission#')								
							</cfquery>	
							
							<cfelse>
							
							<cfquery name="Tax"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT     *
								FROM       WarehouseCategory
								WHERE      Warehouse = '#w#'								
							</cfquery>	
							
							</cfif>
							
							<cfif Line.TaxCode eq "">
								<cfset defaulttax = Tax.TaxCode>
							<cfelse>	
							    <cfset defaulttax = Line.TaxCode>
							</cfif>
												
							<select class="regularxl" name="#w#_#measure#_#Schedule.code#_#currency#_taxcode" id="#w#_#measure#_#Schedule.code#_#currency#_taxcode"
							   size="1" style="text-align: right;border:0px;border-left:1px solid silver;border-right:1px solid silver">
							    <cfloop query="taxes">
									<option value="#TaxCode#" <cfif TaxCode eq defaulttax>selected</cfif>>#Description#</option>
								</cfloop>
						    </select>							
						
						</td>
						
						<td align="right" style="width:80px;">
							<cfif rowcnt eq 1>
							<table>
								<tr>
									<td>
										<img id="#w#_#measure#_#Schedule.code#_#currency#_copyScheduleCurrency" 
											title="Copy to all lines with the same price schedule and currency" 
											height="20" 
											src="#SESSION.root#/images/copyprice.png" 
											onclick="copyValues('#w#','#measure#','#Schedule.code#','#currency#',1);" 
											style="cursor:pointer;">
									</td>
									<td width="10"></td>
									<td>
										<img id="#w#_#measure#_#Schedule.code#_#currency#_copyUoMScheduleCurrency" 
											title="Copy to all lines with the same UoM, price schedule and currency" 
											height="20" 
											src="#SESSION.root#/images/copyuomprice.png" 
											onclick="copyValues('#w#','#measure#','#Schedule.code#','#currency#',2);" 
											style="cursor:pointer;">
									</td>
								</tr>
							</table>
							</cfif>
						</td>
						
						</tr>

						<tr>
							<td colspan="13" id="detail_#url.id#_#measure#_#Schedule.code#_#w#_#url.mission#"></td>
						</tr>
								
					</cfloop>				
				
										
			</cfloop>
		
		</cfif>
	
</cfoutput>