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
								
		<tr class="labelmedium line">
			<td height="25" style="padding-left:3px">UoM:</td>
			<td>#UoMDescription# [#UoM#]</td>
			<td><cf_tl id="Effective"></td>
			<td><cf_tl id="Currency"></td>
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
							 WHERE  1=1
							 </cfif>
					         AND    Category   = '#Item.Category#'
							 AND    Operational = 1)			
		</cfquery>
		
		<cfloop query="Schedule">			
			
			<tr class="labelmedium line" onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''">
				
				<td></td>
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
								         WHERE  Warehouse  = '#Warehouse.Warehouse#'
								         AND    Category   = '#Item.Category#'
										 AND    PriceSchedule = '#code#'
										 AND    Operational = 1)
				</cfquery>
																													
				<cfloop query="Currency">				
						
										
					<cfquery name="line"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     TOP 1 *
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
						ORDER BY DateEffective DESC
					</cfquery>
					
					
					<td>
										
					<cf_space spaces="40">
					
					<cfif line.dateeffective eq "">
													
						<cf_intelliCalendarDate9
						    class="regularxl"
							FieldName="#w#_#measure#_#Schedule.code#_#currency#_DateEffective" 
							Default="#dateformat("01/01/2008",CLIENT.DateFormatShow)#"
							message="Enter a valid price"
							Tooltip="Effective Date"
							AllowBlank="False">	
						
					<cfelse>
					
						<cf_intelliCalendarDate9
							FieldName="#w#_#measure#_#Schedule.code#_#currency#_DateEffective" 
							Default="#dateformat(line.dateeffective,CLIENT.DateFormatShow)#"
							message="Enter a valid price"
							class="regularxl"
							Tooltip="Effective Date"
							AllowBlank="False">	
					
					</cfif>	
												
					</td>		
					
					<td style="padding-left:3px;padding-right:3px">#Currency#</td>
					
					<td style="padding-left:3px;padding-right:6px" align="right">
					
					<cfquery name="Purchase"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     TOP 1 *
						FROM       Purchase.dbo.PurchaseLineReceipt
						WHERE      WarehouseItemNo        = '#url.id#'
						AND        WarehouseUoM           = '#measure#'
						AND        ReceiptNo IN (SELECT ReceiptNo FROM Purchase.dbo.Receipt WHERE Mission = '#url.mission#')
						ORDER BY Created DESC
					</cfquery>	
															
					<cfif Purchase.WarehouseCurrency eq Currency or Purchase.WarehouseCurrency eq "">					
					
						#numberformat(Purchase.WarehousePrice,'.,__')#
						
					<cfelse>
					
						<cf_exchangeRate Currencyfrom="#Purchase.WarehouseCurrency#" CurrencyTo="#currency#">
						#numberformat(Purchase.WarehousePrice/exc,'.,__')#				
											
					</cfif>
					
					</td>
					
					<td style="padding-left:3px;padding-right:6px" align="right">
										
						<cfquery name="Transaction"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     TransactionCostPrice
							FROM       ItemTransaction
							WHERE      ItemNo             = '#url.id#'
							AND        TransactionUoM     = '#measure#'
							AND        Mission            = '#url.mission#'
							AND        TransactionType    = '1'
							ORDER BY Created DESC
						</cfquery>	
																
						<cfif application.BaseCurrency eq Currency>					
						
							#numberformat(Transaction.TransactionCostPrice,'.,__')#
							
						<cfelse>
						
							<cf_exchangeRate Currencyfrom="#application.BaseCurrency#" CurrencyTo="#currency#">
							#numberformat(Transaction.TransactionCostPrice/exc,'.,__')#				
												
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
						   style="text-align: right;">
						
						<cfelse>
					
						<cfinput type="Text" 
						   name="#w#_#measure#_#Schedule.code#_#currency#_SalesPrice" 
						   value="#numberFormat(Line.SalesPrice,".__")#" 
						   message="Enter a valid price" 
						   validate="float" 
						   class="regularxl"
						   required="Yes" 
						   size="10" 
						   maxlength="12" 
						   style="text-align: right;">				
						   
						 </cfif>  
						   
					</td>
											
					<td style="padding-left:3px;height:28">
					
						<select class="regularxl" name="#w#_#measure#_#Schedule.code#_#currency#_taxcode" id="#w#_#measure#_#Schedule.code#_#currency#_taxcode"
						   size="1">
						    <cfloop query="taxes">
								<option value="#TaxCode#" <cfif TaxCode eq Line.TaxCode>selected</cfif>>
						    		#Description#
								</option>
							</cfloop>
					    </select>							
					
					</td>
					
					<td align="right" style="width:80">
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
							
				</cfloop>				
			
									
		</cfloop>
		
		</cfif>
	
</cfoutput>