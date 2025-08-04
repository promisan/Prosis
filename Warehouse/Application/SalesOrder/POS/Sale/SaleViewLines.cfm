<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	SELECT    SaleLinesOrder, Mission, SingleLine, SupplyWarehouse
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
				 M.ItemNoExternal,
				 <!--- this field needs some thoughts --->
				 (   SELECT TransactionUoM 
				     FROM   Materials.dbo.ItemUoMMission IUM
				     WHERE  IUM.ItemNo = T.ItemNo 
				     AND    IUM.UoM = I.UoM 
				     AND    IUM.Mission = W.Mission) as SalesUoM,
				  
		         I.UoMDescription, 
				 I.ItemBarCode,
				 C.CommissionMode,		
				 M.ItemPrecision,		 
				 ( 	SELECT    ISNULL(SUM(TransactionQuantity),0) as OnHand
    			 	FROM      Materials.dbo.ItemTransaction
			     	WHERE     Warehouse       = T.Warehouse
			     	AND       ItemNo          = I.ItemNo
			     	AND       TransactionUoM  = I.UoM
					<!--- added 12/4/2021 --->   	
					AND       WorkorderId is NULL						   		      
				 ) as OnHand,
				 ( 	SELECT    ISNULL(SUM(TransactionQuantity),0) as OnHand
    			 	FROM      Materials.dbo.ItemTransaction
			     	WHERE     Mission         = W.Mission
					AND       ItemNo          = I.ItemNo
			     	AND       TransactionUoM  = I.UoM   
					<!--- added 12/4/2021 --->   		
					AND       WorkorderId is NULL							   		      
				 ) as OnHandAll								 				
				 				 
		FROM     vwCustomerRequest T
				 INNER JOIN  Materials.dbo.ItemUoM I      ON  T.ItemNo     = I.ItemNo AND T.TransactionUoM  = I.UoM	
				 INNER JOIN  Materials.dbo.Item M  	      ON  T.ItemNo     = M.ItemNo		
				 INNER JOIN  Materials.dbo.Warehouse W    ON  W.Warehouse  = T.Warehouse
				 INNER JOIN  Materials.dbo.Ref_Category C ON  C.Category   = T.ItemCategory
				 					
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
			
			<tr style="border-bottom:1px solid silver;height:35px;font-size:12px" class="navigation_row fixlengthlist labelmedium" <cfif ItemClass neq 'Service' and TransactionQuantity gt 0 and TransactionQuantity gt OnHand>bgcolor="ffffaf"<cfelse><cfif getLines.currentrow MOD 2>bgcolor="fefefe"</cfif></cfif> id="line_#currentrow#">
			
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
				
				<td style="width:90%" class="fixlength">
				
					<div style="height:25px;">
						<cfif WParameter.SingleLine eq 1>
							(#ItemBarCode#) #ItemDescription# - #UoMDescription# 
						<cfelse>
							<p style="font-size:15px;text-transform:capitalize;padding-top:2px;">
							#ItemDescription# 
							<span style="display:none; font-size:12px!important;color:##808080;" class="clsDetailLineCell">
							[#ItemBarcode#]
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
						<cfif ItemNoExternal neq "">#ItemNoExternal#,<cfelse>#ItemBarCode#,</cfif>#UoMDescription#, 
						<span ed="onhandall_#currentrow#">
												
							<cfif ItemClass eq "Service">
							
							--
							
							<cfelse>
									
								<cfset vStockAll = OnHandAll>
								
								<cf_precision number="#ItemPrecision#">
						        
								<cfif TransactionQuantity gt vStockAll>
									<font color="FF0000">#numberformat(vStockAll,'#pformat#')#</font>
								<cfelse>
									#numberformat(vStockAll,'#pformat#')# 
								</cfif>		
																
								<!--- reorder quantity of the parent warehouse --->
																								
								<cfquery name="qReorder"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">	
									
									SELECT      MinReorderQuantity
									FROM        ItemWarehouse
									WHERE       ItemNo    = '#itemNo#' 
									AND         UoM       = '#TransactionUoM#'
									<cfif wparameter.supplywarehouse eq "">
									    AND         Warehouse = '#url.warehouse#'
									<cfelse>
									    AND         Warehouse = '#wparameter.supplywarehouse#'
									</cfif>
																		
								  </cfquery>	
																		
								  <cfif qReorder.recordcount neq 0>
										<font size="2" color="800040">min:&nbsp;#qReorder.MinReorderQuantity#</font>
								  </cfif>	
							
							</cfif>
						</span>
						</div>
				</td>	

				<td style="min-width:200px" valign="top">
				
				    <table>
					<tr><td valign="top" id="onhand_#currentrow#" style="padding-top:3px;min-width:100px;font-size:15px">
					
					<!---
					<span id="onhand_#currentrow#" style="min-width:100px;font-size:15px">
					--->
										
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
							
							<cfif TransactionQuantity gt vStock>
								
								<cfquery name="qExistingTransfer"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
										SELECT isNULL(SUM(TransactionQuantity),0) as TransactionTransfer,
										       isNULL(SUM(TransactionTransfer),0) as QuantityTransfer 
										FROM   CustomerRequestLineTransfer
										WHERE  TransactionId='#TransactionId#'
								</cfquery>	
								
								<span>		
												
								<button 
									style="width:90px;height:28px;font-size:13px!important;background:##f8f9fa;color:##033F5D;border:1px solid gray;" 
									type="button" 
									id='btransfer_#currentrow#' 
									name='btransfer_#currentrow#' 
									onclick="salesTransfer('#transactionid#','#warehouse#')" 
									class="clsDetailLineCell">
										<cf_tl id="Transfer"><i class="fas fa-share-square"></i>
								</button>
								</span>													
								
								<span class="clsNoPrint clsDetailLineCell" id="transfer_#transactionid#" style="padding-bottom:5px;min-width:100px">
									<cfif qExistingTransfer.TransactionTransfer neq 0>																
										| #qExistingTransfer.TransactionTransfer# [#qExistingTransfer.QuantityTransfer#]
									</cfif>	
								</span>									
																	
							</cfif>
							
							<cf_precision number="#ItemPrecision#">
					
							<cfif TransactionQuantity gt OnHand>
								<font color="FF0000">#numberformat(vStock,'#pformat#')#</font>
							<cfelse>							
								#numberformat(vStock,'#pformat#')# 
							</cfif>		

							
						</cfif>
						
					</td></tr></table> 				
					
				</td>
								
				<td align="right" style="min-width:50px;padding-top:2px;" valign="top">
				
				  <cf_precision number="#ItemPrecision#"> 
				
				   <cfif BatchNo eq "">
				   
				   <cfset sc = "ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=quantity&addressId=#url.AddressId#&value='+this.value,'processline')">
				
				    <input type="text" 
					 style = "background-color:fff;width:55px;text-align:center;border:1px solid gray;" 
					 id    = "TransactionQuantity_#currentrow#"
					 class = "regularxxl enterastab TransactionQuantity_#transactionid#"
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
					 onkeyup="#sc#" onblur="#sc#">
					 
				   <cfelse>
				   
				   #numberformat(TransactionQuantity,'#pformat#')#
				   
				   </cfif>	 

				</td>						
				
				<td align="right" style="min-width:100px;padding-top:1px;" valign="top">				
								
					<cfif SalesPrice eq "0">
						<cfset cl = "FF8080">
					<cfelse>
						<cfset cl = "ffffff">
					</cfif>
					
					<table width="100%"><tr><td align="right">
					
					<input type="text" 
					 style = "background-color:#cl#;width:75px;text-align:right;padding-right:2px;border:1px solid gray" 
					 id    = "SalesPrice_#currentrow#"
					 class = "regularxxl enterastab SalesPrice_#transactionid#"
					 <cfif vLast eq currentrow>
					 	tabindex = "#tcounter#"
					 	<cfset tcounter = tcounter + 1>
					 <cfelse>
					 	tabindex = "0"
					 </cfif>	
					 readonly				 
					 value = "#numberformat(SalesPrice,'.__')#" 
					 name  = "SalesPrice_#currentrow#"
					 onchange="$('##SalesPrice_#currentrow#').attr('value', this.value); ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setLine.cfm?warehouse=#url.warehouse#&line=#currentrow#&id=#transactionid#&action=price&value='+this.value,'processline')">
					 
					 </td>
					 
					 <td>
					 <cf_authorization mission="#getLines.Mission#" functionname="Point of Sale" object="SalesPrice_#currentrow#">
					 </td>
					 
					 </tr></table>

					<div class="clsNoPrint clsDetailLineCell">
						#numberformat(SchedulePrice,'.__')#
					</div>
				
				</td>	
					
				<td valign="top" align="right" style="min-width:100px;padding-top:9px 0;padding-right:4px; width:10%;">
				
					<cfif SalesPrice eq "0">
						<cfset cl = "FF8080">
					<cfelse>
						<cfset cl = "transparent">
					</cfif>
					 
					<div style="background-color:#cl#;padding-top:4px;height:26px;padding-right:2px" id="total_#currentrow#" class="labelmedium total_#transactionid#">					
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
					AND      T.RequestNo     != '#URL.Requestno#'
					AND      T.CustomerId    != '#URL.CustomerId#'
					AND      T.BatchId is NULL
					AND      T.ActionStatus  != '9'
					AND      T.BatchNo IS NULL <!--- not converted into a sale transaction --->
				    AND      T.ItemClass      = 'Supply'						
					GROUP BY T.CustomerId
					
			</cfquery>
			
			<cfif qOverlap.recordcount neq 0 and WParameter.SingleLine eq 0>
				<tr class="line labelit">
					<td colspan="2"></td>
					<td colspan="6">
					<div style="color:6688aa">
						#watched# <a href="##" onclick="salesOverlap('#TransactionId#','#URL.Warehouse#')"><font style="color:red" size="4">#qOverlap.recordcount#</font></a> <cfif qOverlap.recordcount eq 1>#lcase(person)#<cfelse>#lcase(people)#</cfif> 
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
									<td align="right" style="padding-right:5px;min-width:140px">
									
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

