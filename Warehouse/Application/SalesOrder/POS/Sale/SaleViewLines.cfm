<cfif trim(url.customerId) eq "">
	<cfset url.customerId = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfparam name="url.AddressId"  default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.mode"       default="embed">
<cfparam name="url.requestno"  default="">

<!--- apply the promotions --->

<cfquery name="getline"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 			 				 
		FROM     CustomerRequestLine									
		WHERE    RequestNo = '#url.requestNo#' 				
</cfquery>

<cfif getline.BatchId eq "">
				
	<cfinvoke component = "Service.Process.Materials.POS"  
	   method           = "applyPromotion" 
	   warehouse        = "#url.warehouse#" 
	   requestNo        = "#url.requestNo#"
	   customerid       = "#url.customerid#">
   
</cfif>   
		

<cfquery name="WParameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    SaleLinesOrder, Mission, SingleLine
	FROM      Warehouse  
	WHERE     Warehouse = '#url.Warehouse#' 
</cfquery>	

<cfquery name="MParameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#WParameter.Mission#'	
</cfquery>
  
<cf_tl id="also considered by" var="watched">
<cf_tl id="people" var="people">	
<cf_tl id="person" var="person">
<cf_tl id="transfer from" var="transferFrom">
      
<cfquery name="getLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   W.WarehouseName,
				 W.MissionOrgUnitId,
				 W.Beneficiary,
				 T.*, 
				 UoMMission.TransactionUoM AS SalesUoM,
		         I.UoMDescription, 
				 I.ItemBarCode,
				 C.CommissionMode,				 
				 (
				 	SELECT    ISNULL(SUM(TransactionQuantity),0) as OnHand
    			 	FROM      Materials.dbo.ItemTransaction
			     	WHERE     Warehouse       = T.Warehouse
			     	AND       ItemNo          = I.ItemNo
			     	AND       TransactionUoM  = I.UoM   							   		      
				 ) as OnHand,
				 (
				 	SELECT    ISNULL(SUM(TransactionQuantity),0) as OnHand
    			 	FROM      Materials.dbo.ItemTransaction
			     	WHERE     ItemNo          = I.ItemNo
			     	AND       TransactionUoM  = I.UoM   							   		      
				 ) as OnHandAll								 				
				 				 
		FROM     vwCustomerRequest T
				 INNER JOIN  Materials.dbo.ItemUoM I
					ON  T.ItemNo = I.ItemNo	AND T.TransactionUoM  = I.UoM	
				 INNER JOIN Materials.dbo.Warehouse W
				 	ON  W.Warehouse       = T.Warehouse
				 INNER JOIN Materials.dbo.Ref_Category C
				 	ON  C.Category = T.ItemCategory
				 LEFT JOIN Materials.dbo.ItemUoMMission UoMMission
					ON UoMMission.ItemNo = T.ItemNo AND UoMMission.UoM = I.UoM AND UoMMission.Mission = W.Mission
					
		WHERE    T.RequestNo = '#url.requestNo#' 			
			
		ORDER BY T.Created #WParameter.SaleLinesOrder#
				
</cfquery>

	<cfif WParameter.SaleLinesOrder eq "DESC">
		<cfset vLast = 1>
	<cfelse>
		<cfset vLast = getLines.recordCount>
	</cfif>	

	<table width="98%" class="navigation_table clsPOSDetailLines" border="0">		
										
		<!--- ajax box for processing --->
		
		<tr class="hide"><td colspan="7" id="processline"></td></tr>
				
		<cfset tcounter = 1>
			
		<cfoutput query="getLines">					
			
			<tr style="border-bottom:1px solid silver;height:25px;font-size:12px" class="navigation_row labelmedium" <cfif ItemClass neq 'Service' and TransactionQuantity gt 0 and TransactionQuantity gt OnHand>bgcolor="FFC1C1"<cfelse><cfif getLines.currentrow MOD 2>bgcolor="fefefe"</cfif></cfif> id="line_#currentrow#">
			
			    <td style="padding-left:14px;padding-top:0px;padding-right:3px; min-width:25px" valign="top"><p style="font-size:15px;padding-top:3.5px;">#currentrow#.</p></td>
			    
				<td style="padding-left:4px;padding-top:0px;padding-right:4px; width:3%;" align="center" valign="top">
				
				<cfif BatchNo eq "">
				
					<i class="fas fa-minus-circle" style="cursor:pointer;color:##033F5D;font-size:18px;padding-top:5px;;min-width:25px" class="clsNoPrint" 
					     onclick="_cf_loadingtexthtml='';ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=delete','salelines')"></i>
					
				</cfif>	 
				
				</td>
				<style>
				.clsDetailLineCell {height: 25px; <cfif WParameter.SingleLine eq 1>display:none</cfif>}
				</style>
				
				<td style="width:90%">
				
					<div style="height:25px;">
						<cfif WParameter.SingleLine eq 1>
							(#ItemBarCode#) #ItemDescription# - #UoMDescription# 
						<cfelse>
							<p style="font-size:15px;text-transform:capitalize;padding-top:2px;">
							#ItemDescription# 
							<span style="display:none; font-size:12px!important;color:##808080;" class="clsDetailLineCell">
								(#ItemBarcode#)
							</span>
						</cfif>	
						</p>
					</div>
					
					<div class="clsDetailLineCell">
											
						<input type="text" 
							style 	   = "background-color:ffffaf;width:160;"
							maxlength  = "50" 
							id    	   = "TransactionReference_#currentrow#"
							class 	   = "regularh enterastab"
							<cfif vLast eq currentrow>
							tabindex   = "#tcounter#"
								<cfset tcounter = tcounter + 1>
							<cfelse>
							tabindex   = "0"
							</cfif>	 							
							value      = "#TransactionReference#" 
							name       = "TransactionReference_#currentrow#"
							onchange   = "ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=reference&addressId=#url.AddressId#&value='+this.value,'processline')">

							
						<cfif Warehouse neq URL.Warehouse>
							#transferFrom# <span style="font-weight:bold">#WarehouseName#</div>
						</cfif>	
						#ItemBarCode#, 
						#UoMDescription#, 
						<span ed="onhandall_#currentrow#">
												
							<cfif ItemClass eq "Service">
							
							--
							
							<cfelse>
									
								<cfset vStockAll = OnHandAll>
						
								<cfif TransactionQuantity gt vStockAll>
									<font color="FF0000">#numberformat(vStockAll,'_')#</font>
								<cfelse>
									#numberformat(vStockAll,'_')# 
								</cfif>		
								
								<cfquery name="qOffer"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">						
										SELECT IVO.OfferMinimumQuantity 
										FROM ItemVendor IV INNER JOIN 
											ItemVendorOffer IVO ON IV.ItemNo = IVO.ItemNo
										WHERE IV.ItemNo  = '#ItemNo#'
										AND IV.Preferred = '1'
										ORDER BY DateEffective DESC
									</cfquery>
									
									<cfif qOffer.recordcount neq 0>
										<font size="2" color="800040">min:&nbsp;#qOffer.OfferMinimumQuantity#</font>
									</cfif>	
							
							</cfif>
						</span>
											</div>
				</td>	

				<td style="min-width:200px;padding-top:4px" valign="top">
					
					<span id="onhand_#currentrow#" style="min-width:100px;font-size:15px">
										
						<cfif ItemClass eq "Service">
						
						--
						
						<cfelse>
								
							<cfset vStock = OnHand>
								
							<cfif SalesUoM neq "" and TransactionUoM neq SalesUoM>		
								
								<cfinvoke component         = "Service.Process.Materials.Stock"  
											method          = "getStock" 
											Mission			= "#Mission#"
											warehouse       = "#Warehouse#" 							  
											ItemNo          = "#ItemNo#"
											UoM             = "#TransactionUoM#"		
											TransactionLot  = "#TransactionLot#"					  
											returnvariable  = "stockTransactionUoM">	
								
								<cfset vStock = stockTransactionUoM.onhand>
									
							</cfif>
					
							<cfif TransactionQuantity gt OnHand>
								<font color="FF0000">#numberformat(vStock,'_')#</font>
							<cfelse>							
								#numberformat(vStock,'_')# 
							</cfif>		

							<cfif (TransactionQuantity gt vStock)>
								
								<cfquery name="qExistingTransfer"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
										SELECT SUM(TransactionQuantity) as TransactionTransfer,
										       SUM(TransactionTransfer) as QuantityTransfer 
										FROM   CustomerRequestLineTransfer
										WHERE  TransactionId='#TransactionId#'
								</cfquery>														
								
								<span class="clsNoPrint clsDetailLineCell" id="transfer_#transactionid#" style="padding-bottom:2px;min-width:100px">
									<cfif qExistingTransfer.recordcount neq 0>																
										| #qExistingTransfer.TransactionTransfer# [#qExistingTransfer.QuantityTransfer#]
									</cfif>	
								</span>									
																
								<br>
								<button 
									style="width:90px;padding:4px 2px 6px;font-size:13px!important;background:##f8f9fa;color:##033F5D;border-radius:4px;border:1px solid ##CCCCCC;" 
									type="button" 
									id='btransfer_#currentrow#' 
									name='btransfer_#currentrow#' 
									onclick="salesTransfer('#transactionid#','#warehouse#')" 
									class="clsDetailLineCell">
										<cf_tl id="Transfer"><i class="fas fa-share-square"></i>
								</button>
									
							</cfif>

						</cfif>
						
					</span>					
					
				</td>
								
				<td align="right" style="min-width:50px;padding-top:0px;" valign="top">
				
				   <cfif BatchNo eq "">
				
				    <input type="text" 
					 style = "background-color:fff;width:45px;text-align:center;border:1px solid silver;border-top:0px;border-radius:0px;" 
					 id    = "TransactionQuantity_#currentrow#"
					 <cfif vLast eq currentrow>
					 	tabindex = "#tcounter#"
					 	<cfset tcounter = tcounter + 1>
					 <cfelse>
					 	tabindex = "0"
					 </cfif>	 
					 class = "regularxxl enterastab"
					 value = "#TransactionQuantity#"
					 name  = "TransactionQuantity_#currentrow#"
					 <cfif currentrow eq 1>autofocus</cfif>
					 onkeyup="ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=quantity&addressId=#url.AddressId#&value='+this.value,'processline')">
					 
				   <cfelse>
				   
				   #numberformat(TransactionQuantity,'_')#
				   
				   </cfif>	 

				</td>						
				
				<td align="right" style="min-width:100px;padding-top:0px;" valign="top">
					
					<input type="text" 
					 style = "background-color:fff;width:85px;text-align:right;border:1px solid silver;border-top:0px;" 
					 id    = "SalesPrice_#currentrow#"
					 class = "regularxxl enterastab SalesPrice_#transactionid#"
					 <cfif vLast eq currentrow>
					 	tabindex = "#tcounter#"
					 	<cfset tcounter = tcounter + 1>
					 <cfelse>
					 	tabindex = "0"
					 </cfif>					 
					 value = "#numberformat(SalesPrice,'.__')#" 
					 name  = "SalesPrice_#currentrow#"
					 onchange="$('##SalesPrice_#currentrow#').attr('value', this.value); ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=price&value='+this.value,'processline')">

					<div class="clsNoPrint clsDetailLineCell">
						#numberformat(SchedulePrice,'.__')#
					</div>

				</td>				
	
				<td valign="top" align="right" style="min-width:100px;padding-top:7px 0;padding-right:4px; width:10%;">
					 
					<div style="padding-top:2px;height:27px;" id="total_#currentrow#" class="labelmedium total_#transactionid#">					
						#numberformat(SalesTotal,',.__')#
					</div>
					<div class="clsNoPrint clsDetailLineCell">

						<!---						
						<cfif MParameter.EarmarkManagement eq "0">	
						--->
					
							<cfif TaxExemption eq "0">
								#numberformat(TaxPercentage*100,'._')#%
							<cfelse>
								<font color="b0b0b0">(#numberformat(TaxPercentage*100,'._')#%)</font>
							</cfif>
						
						<!---				
						</cfif>
						--->

					</div>
				</td>
				
			</tr>
			
			<cfquery name="qOverlap" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   T.CustomerId,COUNT(1)
						FROM     vwCustomerRequest T
						WHERE    T.Warehouse      = '#url.warehouse#'
						AND      T.ItemNo         = '#ItemNo#'
						AND      T.TransactionUoM = '#TransactionUoM#'
						AND      T.CustomerId != '#URL.CustomerId#'
						AND      T.ActionStatus  != '9'
						AND      T.BatchNo IS NULL <!--- not converted into a sale transaction --->
					    AND      T.ItemClass      = 'Supply'						
						GROUP BY T.CustomerId
			</cfquery>
			
			<cfif qOverlap.recordcount neq 0 and WParameter.SingleLine eq 0>
				<tr class="line labelit">
					<td colspan="2"></td>
					<td colspan="6">
					<div style="color:red">
						#watched# <a href="##" onclick="salesOverlap('#TransactionId#','#URL.Warehouse#')">#qOverlap.recordcount#</a> <cfif qOverlap.recordcount eq 1>#lcase(person)#<cfelse>#lcase(people)#</cfif> 
					</div>
					</td>
				</tr>		 
			</cfif>	
		
			<cfif MParameter.EarmarkManagement eq "0" OR CommissionMode eq "1">
				<tr class="line" style="height:20px;<cfif WParameter.SingleLine eq 1>display:none</cfif>">
					<td colspan="2"></td>
					<cfif CommissionMode eq "1">
						<cfset vTheseCols = 5>
						<cfif MParameter.EarmarkManagement eq "0">
							<cfset vTheseCols = 3>
						</cfif>
						<td colspan="#vTheseCols#">
							<table>
								<tr>
									<td>
										<cfset URL.mission  		= mission>
										<cfset URL.MissionOrgUnitId = MissionOrgUnitId>
										<cfset URL.SaleId 			= "salespersonno_#currentrow#">
										<cfset URL.field            = "salepersonline">
										<cfset URL.TransactionId	= transactionid>
										<cfset URL.SalesPersonNo	= SalesPersonNo>
																		
										<cfif MParameter.EarmarkManagement eq "0">
											<cfinclude template="getSalesPerson.cfm">
										</cfif>		
											
									</td>
									<td align="right" style="padding-right:5px;">
										<cfif MParameter.EarmarkManagement eq "0">
											<cf_setCalendarDate
											name         = "TransactionTime_#currentrow#" 
											id           = "TransactionTime_#currentrow#"       					      
											font         = "14"		
											key1         = "#transactionId#"
											key2         = "#url.warehouse#"
											pfunction    = "setsaletime"	  
											valuecontent = "datetime"
											value        = "#TransactionDate#"						 		
											mode         = "time"> 
										</cfif>	
									</td>
								</tr>
							</table>
						</td>	
					</cfif>		

					<cfif MParameter.EarmarkManagement eq "0">
					
						<td colspan="2">
							<cfif ItemClass eq "Service">						
								
								<cfif getLines.Beneficiary eq 1>
									<img src="#SESSION.root#/images/add.png" 
											alt="Add new beneficiary" border="0" width="18" height="16" style="cursor:pointer" class="clsNoPrint" 
										onclick="_cf_loadingtexthtml='';ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setBeneficiary.cfm?warehouse=#url.warehouse#&id=#transactionid#&CustomerId=#URL.CustomerId#&crow=#currentrow#&action=add','Beneficiary_#currentrow#')">
									
								</cfif>
								
							</cfif>	  	
						</td>	
					
					</cfif>								
					
				</tr>
			</cfif>							

			<cfif ItemClass eq "Service">
			
				<cfif getLines.Beneficiary eq 1>
					<tr>
						<td colspan="2"></td>
						<td colspan="5" id="Beneficiary_#currentrow#" name="Beneficiary_#currentrow#">
							<cfset url.crow   = currentrow>
							<cfset url.clines = TransactionQuantity>
							<cfset url.Id     = TransactionId>
							<cfinclude template="getBeneficiary.cfm">	
						</td>
					</tr>
				</cfif>

			</cfif>						
									
		</cfoutput>	
		
		<cfset lines = "4">
		
		<cfif getLines.recordcount lte "4">
			<cfset cnt = lines - getLines.recordcount>				
			<cfloop index="line" from="1" to="#cnt#">				
			<tr style="border-bottom:1px solid dfdfdf" class="clsNoPrint"><td colspan="7" style="height:30px"></td></tr>				
			</cfloop>	
		</cfif>		
		
		<tr style="height:0px" class="clsNoPrint">
		    <td colspan="7"></td>
		</tr>		
					
	</table>		

<cfset ajaxonload("doHighlight")>
<cfif url.mode eq "embed">
	<cfset ajaxonload("setCursor")>
</cfif>	

