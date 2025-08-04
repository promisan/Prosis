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

<cf_verifyOperational module="Warehouse" Warning="No">
		
<cfparam name="URL.header"    		   default="1">			
<cfparam name="URL.mode"    		   default="default">	
<cfparam name="URL.actionStatus" 	   default="1">	 
<cfparam name="Form.ReceiptDate"       default="#dateformat(now(),CLIENT.DateFormatShow)#">		 
<cfparam name="Form.ReceiptRemarks"    default="">	 
<cfparam name="Form.Remarks"           default="#Form.ReceiptRemarks#">	
<cfparam name="Form.PackingSlipNo"     default="">	
<cfparam name="Form.ReceiptReference1" default="">	 
<cfparam name="Form.ReceiptReference2" default="">	 
<cfparam name="Form.ReceiptReference3" default="">	 
<cfparam name="Form.ReceiptReference4" default="">	 
<cfparam name="Form.EntityClass"       default="">	

<!--- hide the submit button --->
	 
<cf_workflowenabled 
	datasource="AppsPurchase"
	mission="#form.mission#" 
	entitycode="ProcReceipt">	 

<cfif Len(Form.ReceiptRemarks) gt 200>
	 <cf_tl id="You may not enter remarks that exceed 200 characters." var="1">
   	 <cf_alert message = "#lt_text#" return = "back">
	 <script>Prosis.busy('no')</script>
   	 <cfabort>
</cfif>		

<script>
	document.getElementById("submit").className = "hide"
</script> 

<cf_tl id="You entered a receipt in a value that would exceeded the Purchase Order amount in " class="message" var="vMessage1">

		<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Form.Mission#' 
		</cfquery>
		
		<cfif url.receiptNo eq "">
 
			<!--- create entry in receipt --->
	
			<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
						
					<cfset ser = Parameter.ReceiptSerialNo+1>
					<cfif ser lt 1000>
					     <cfset ser = 1000+ser>
					</cfif>
						
					<cfquery name="Update" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE Ref_ParameterMission
						SET    ReceiptSerialNo = '#ser#'				
						WHERE  Mission = '#Form.Mission#'
					</cfquery>
													
			</cflock>
				
		    <cfset dateValue = "">
			<CF_DateConvert Value="#Form.ReceiptDate#">
			<cfset dte = dateValue>	
		
			<!--- checking --->
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Receipt					
				WHERE  ReceiptNo = '#Parameter.ReceiptPrefix#-#ser#'
			</cfquery>
		
			<cfif Check.recordcount eq "1">		
			
				<cfquery name="Update" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE Ref_ParameterMission
						SET    ReceiptSerialNo = '#ser#'				
						WHERE  Mission = '#Form.Mission#'
				</cfquery>
			
			    <cfoutput>
				<script language="JavaScript">
					alert("Please contact your administrator to set the receipt numbering as [#Parameter.ReceiptPrefix#-#ser#] exists.");
					document.getElementById("submit").className = "regular"
					Prosis.busy('no')
				</script>
				</cfoutput>
	   		 	<cfabort>
			
			</cfif>	
			
		 </cfif>	
			
		 <cftransaction>
		
		 <cfif url.receiptNo eq "">
											
		    <!--- 3. create receipt header  --->	
		
			<cfset ReceiptNo = "#Parameter.ReceiptPrefix#-#ser#">
		
			<cfquery name="Header" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Receipt
					   (ReceiptNo, 
					    Mission,
						Period,
						PackingSlipNo,
						<cfif workflowenabled eq "1">
						  EntityClass,
						</cfif>
						<cfif form.reqNo neq "">
						RequisitionNo,
						</cfif>
						<cfif form.taskid neq "">
						WarehouseTaskId,
						</cfif>
						AttachmentId,
					    ReceiptReference1, 
						ReceiptReference2, 
						ReceiptReference3, 
						ReceiptReference4, 
						ActionStatus,
						ReceiptDate,
						ReceiptRemarks,
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName) 
			     VALUES ('#Parameter.ReceiptPrefix#-#ser#', 
						 '#Form.Mission#',
				         '#Form.Period#',
						 '#Form.PackingSlipNo#',
						 <cfif workflowenabled eq "1">
						 '#Form.EntityClass#',
						 </cfif>
						 <cfif form.reqNo neq "">
						 '#Form.ReqNo#',
						 </cfif>
						 <cfif form.taskid neq "">
						 '#Form.TaskId#',
						 </cfif>
						 '#Form.AttachmentId#',
				         '#Form.ReceiptReference1#', 
						 '#Form.ReceiptReference2#',
						 '#Form.ReceiptReference3#',
						 '#Form.ReceiptReference4#',
						 '#url.actionstatus#',
						 #dte#,
						 '#Form.ReceiptRemarks#',
						 '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#')
			</cfquery>
			
		<cfelse>
		
			<cfquery name="get" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   Receipt					
				WHERE  ReceiptNo = '#url.receiptNo#'
			</cfquery>
			
			<cfset ReceiptNo = "#url.receiptNo#">
			<CF_DateConvert Value="#dateformat(get.ReceiptDate,client.dateformatshow)#">
			<cfset dte = dateValue>	
		
		
		</cfif>	
			
	<!--- create entries in purchase line receipt ---->
	
	<cfif url.actionstatus neq "9">
	
	<cfset commit = "0">
	
		<cfloop index="rec" from="1" to="#form.Row#">			
			
			<cfparam name="FORM.ReceiptQuantity_#Rec#"          default="0">	
			<cfparam name="FORM.ReceiptOrderMultiplier_#Rec#"   default="1">	
			
			<cfparam name="FORM.ReceiptMultiplier_#Rec#"        default="1">		
			<cfparam name="FORM.ReceiptVolume_#Rec#"            default="0">		
			
			<cfparam name="FORM.Warehouse_#Rec#"                default="">		
			<cfparam name="FORM.WarehousePrice_#Rec#"           default="0">
			<cfparam name="FORM.TransactionLot_#Rec#"           default="0">
			
			<cfparam name="FORM.WarehouseItemNo_#Rec#"          default="">
			<cfparam name="FORM.WarehouseItemUoM_#Rec#"         default="">
			<cfparam name="FORM.WarehouseCurrency_#Rec#"        default="">
			
			<cfparam name="FORM.OrderQuantity_#Rec#"            default="0">  
			<cfparam name="FORM.Outstanding_#Rec#"              default="0">  
			
			<cfparam name="FORM.ReceiptQuantityUoM_#Rec#"       default="">  
												
		    <cfif URL.EntryMode eq "0">		
					
				<cfset reqno     = Evaluate("FORM.RequisitionNo_#rec#")>			
				<cfset ord       = Evaluate("FORM.OrderQuantity_#rec#")>
			    <cfset qty       = Evaluate("FORM.ReceiptQuantity_#rec#")>
				<cfset uom       = Evaluate("FORM.ReceiptQuantityUoM_#rec#")>
				
				<cfset omu       = Evaluate("FORM.ReceiptOrderMultiplier_#rec#")>
				<cfset wmu       = Evaluate("FORM.ReceiptMultiplier_#rec#")>
					
				<cfset vol       = Evaluate("FORM.ReceiptVolume_#rec#")>								
				<cfset out       = Evaluate("FORM.Outstanding_#rec#")>
				
				<cfset itm       = Evaluate("FORM.WarehouseItemNo_#rec#")>
				<cfset whs       = Evaluate("FORM.Warehouse_#rec#")>
				<cfset wuo       = Evaluate("FORM.WarehouseItemUoM_#rec#")>
				
				<cfset lot       = Evaluate("FORM.TransactionLot_#rec#")>
				<cfset whsprc    = Evaluate("FORM.WarehousePrice_#rec#")>
				<cfset whscur    = Evaluate("FORM.WarehouseCurrency_#rec#")>
				
				<cfif lot eq "">
					 <cfset lot = "0">
				</cfif>
				
				<cfset whsprc = replace(whsprc,",","","")> 
				
				<cfif not LSIsNumeric(whsprc)>
					
					<script>
					    alert('Incorrect price (<cfoutput>#rec#:#whsprc#</cfoutput>)')
						Prosis.busy('no')
					</script>	 		
					<cfabort>
				
				</cfif>
				
				<cfif wuo eq "as is">
				
					<cfquery name="getLine" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   PurchaseLine	PL INNER JOIN RequisitionLine R ON PL.RequisitionNo = R.RequisitionNo				
						WHERE  PL.RequisitionNo = '#reqno#'
					</cfquery>
					
					<cfquery name="getUoM" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Materials.dbo.ItemUoM
						WHERE  ItemNo = '#getLine.WarehouseItemNo#'		
						AND    UoM    = '#getLine.WarehouseUoM#' 											
					</cfquery>	
					
					<cfset basemultiplier = getLine.OrderMultiplier * getUoM.UoMMultiplier>
									
				    <cf_AssignUoM itemNo = "#itm#" UoMDescription = "#getLine.OrderUoM#" datasource="appsPurchase">
						
					<cfquery name="Insert" 
					datasource="appsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Materials.dbo.ItemUoM
					         (ItemNo,
							  UoM,				 
							  UoMCode,
							  UoMMultiplier,
							  UoMDescription,	
							  ItemBarCode,						 
							  StandardCost,							  
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					  VALUES ('#itm#',
					          '#UoM#',							 
							  NULL,
							  '#basemultiplier#',
					          '#getLine.OrderUoM#',		
							  '#getLine.OrderItemNo#',					  
					          '#whsprc#', 							  
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
					  </cfquery>
					  
					  <cfquery name="InsertMission" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO Materials.dbo.ItemUoMMission
							       (ItemNo,
							        UoM,
							        Mission,
									StandardCost,
							        OfficerUserId,
							        OfficerLastName,
							        OfficerFirstName)
							VALUES ('#itm#',
							        '#UoM#',
									'#FORM.Mission#',
									'#whsprc#', 		
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#')
							
						</cfquery>
				
					  <!--- create UoM --->
				
					  <cfset wuo = "#UOM#">
				
				</cfif>
				
				<!--- validate Transaction lot 

					<cfquery name="CheckLot" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
						FROM   Materials.dbo.ProductionLot					
						WHERE  Mission = '#Form.Mission#'
						AND    TransactionLot = '#lot#'			
					</cfquery>
					
					<cfif CheckLot.recordcount eq "0">
									
					    <cf_alert message = "You entered an invalid Production Lot. Operation aborted." return = "back">						
						<script>
							document.getElementById("submit").className = "regular"
						</script>	 
				   	    <cfabort>
					
					</cfif>	
				
				--->
				
				<cfset ordqty = qty / omu >
												
				<cfquery name="Line" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT H.OrderType, 
					        T.ReceiptValueValidate,
							T.ReceiptValueThreshold,
					        P.*, 
							R.Warehouse, 
							R.WarehouseItemNo,
							R.WarehouseUoM,
							R.Mission
					 FROM   Purchase H,
					        PurchaseLine P, 
					        RequisitionLine R,
							Ref_OrderType T
					 WHERE  H.PurchaseNo    = P.PurchaseNo		
					 AND    T.Code          = H.orderType
					 AND    P.RequisitionNo = R.Requisitionno
					 AND    P.RequisitionNo = '#reqNo#'
				</cfquery>	
				
				<!--- not longer needed disabled 16/11/2016 		
				
				<cfif uom eq "asis">
				
					<cfset uom = line.WarehouseUoM>
					
				</cfif>				
				
				--->				
				
				<cfif Line.ReceiptValueThreshold eq "">
					<cfset threshold = 0>
				<cfelse>
				    <cfset threshold = (Line.ReceiptValueThreshold/100)*Line.OrderQuantity>
				</cfif>
								
				<cfset out = out+threshold>				
																
				<cfif ordqty gt out AND Line.ReceiptValueValidate eq "1">
				
					<!--- incorrect comparison--->	       				   
					
				    <cf_alert message = "You entered a quantity (#ordqty#) for item #itm# which exceeds the order quantity (#ordqty#). \n\nThis Operation not supported for this order type." return = "back">						
					<script language="JavaScript">
						document.getElementById("submit").className = "regular"
						document.getElementById("ReceiptQuantity_<cfoutput>#rec#</cfoutput>").style.background = "red"
						Prosis.busy('no')
					</script>	 
			   	    <cfabort>
					 
				</cfif>	 
					
					<cfif qty gt "0">
					
					        <cfset commit = "1">						
																								 
							 <cfif operational eq "1">
							
								<cfif Line.warehouse eq "">
			
									<cfquery name="WarehouseUpdates" 
									 datasource="AppsPurchase" 
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
									    UPDATE RequisitionLine
										SET    Warehouse     = '#whs#'
										WHERE  RequisitionNo = '#reqNo#'				
									</cfquery>
									
								</cfif>
							
							</cfif>
										
							<cfset prc  = Line.OrderPrice/omu>							
							<cfset dis  = Line.OrderDiscount*100> 
							<cfset amt  = Line.OrderPrice*ordqty>
							<cfset damt = Line.OrderPrice*ordqty*((100-dis)/100)>
							
							<cfif Line.TaxIncluded eq "1">
							
							 	<cfset cost = damt*(1/(1+Line.OrderTax))>
								<cfset tax  = damt*(Line.OrderTax/(1+Line.OrderTax))>
								<cfset cost = round(cost*1000)/1000>				  
								<cfset tax  = round(tax*1000)/1000>
							  					
							<cfelse>
							
							  	<cfset cost = round(damt*1000)/1000>
								<cfset tax  = damt*Line.OrderTax>
								
							</cfif>
							
							<!--- 31/12/2011 
							added provision to not take tax if the purchase line does not have tax either --->
							
							<cfif Line.OrderAmountTax eq "0">				
								<cfset tax = 0>				
							</cfif>
							
							<!--- determine the exchange based on the delivery date --->
							
							<cfset tradte = dateFormat(dte, CLIENT.DateFormatShow)>
							
							<cf_exchangeRate datasource = "appsPurchase"
								EffectiveDate       = "#tradte#"
						        CurrencyFrom        = "#Line.Currency#"
								CurrencyTo          = "#application.BaseCurrency#"> 							
							
							<cfset costB = round((cost/exc)*1000)>
							<cfset costB = costB/1000>
							<cfset taxb  = round((tax/exc)*1000)>
							<cfset taxB  = taxB/1000>
																				
							<cfquery name="Add" 
							 datasource="AppsPurchase" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">							 
														 
							     INSERT INTO PurchaseLineReceipt
										(RequisitionNo,
										 ReceiptNo,
										 PackingSlipNo,
										 DeliveryDate,
										 DeliveryDateEnd,
										 ReceiptItem,
										 ReceiptItemNo,
										 ReceiptQuantity,	
										 ReceiptUoM,
										 ReceiptOrderMultiplier,	
										 <cfif vol neq "">
										 ReceiptVolume,	
										 </cfif>							 
										 <cfif whs neq "">
											 Warehouse,
											 WarehousePrice,
											 WarehouseCurrency,
											 TransactionLot,
										 </cfif>						
										 WarehouseItemNo,
										 WarehouseUoM,		
										 ReceiptMultiplier,
										 WorkOrderId,
										 WorkOrderLine,			
										 RequirementId,		
										 Currency,
										 ReceiptZero,
										 ReceiptPrice,
										 ReceiptDiscount,
										 ReceiptTax,
										 TaxIncluded,
										 TaxExemption,
										 ReceiptAmountCost,
										 ReceiptAmountTax,
										 ExchangeRate,
										 ReceiptAmountBaseCost,
										 ReceiptAmountBaseTax,
										 OfficerUserId,
										 OfficerLastName,
										 OfficerFirstName)
								 SELECT  P.RequisitionNo,
									     '#ReceiptNo#',
										 '#Form.PackingSlipNo#',
										 #dte#,
										 #dte#,										
										 P.OrderItem,
										 P.OrderItemNo,
										 '#qty#',
										 '#uom#', 
										 '#omu#',
										 <cfif vol neq "">										 
										 '#vol#',
										 </cfif>
										 <cfif whs neq "">
											 '#whs#',
											 '#whsprc#',
											 '#whscur#',
											 '#lot#',
										 </cfif>							
										 R.WarehouseItemNo,
										 <cfif wuo neq "">
											 '#wuo#',
										 <cfelse>
											 R.WarehouseUoM,
										 </cfif>
										 '#wmu#',										 										 
										 R.WorkOrderId,
										 R.WorkOrderLine,	
										 R.RequirementId,										 										 
										 P.Currency,
										 P.OrderZero,
										 '#prc#',
										 P.OrderDiscount,
										 P.OrderTax,
										 P.TaxIncluded,
										 '#Line.TaxExemption#',
										 '#cost#',
										 <cfif Line.TaxExemption eq "1">							 
										 '0',
										 <cfelse>
										 '#tax#',
										 </cfif>
										 '#exc#',
										 '#costB#',
										 <cfif Line.TaxExemption eq "1">	
										 '0',
										 <cfelse>
										 '#TaxB#',
										 </cfif>
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#'
								FROM      PurchaseLine P, RequisitionLine R
								WHERE     P.RequisitionNo = R.RequisitionNo
								AND       P.RequisitionNo = '#reqNo#'
								
								
							</cfquery>
							
							<cfinvoke component = "Service.Process.Procurement.PurchaseLine"  
								   method           = "getDeliveryStatus" 
								   RequisitionNo    = "#reqNo#">							
										
					</cfif> 			
									
			<cfelse>		
								
				    <!--- open contract or delivery via task orders --->
																
					<cfparam name="form.detailProcess" default="omit">		
																			
					<cfif url.mode eq "task" and form.detailProcess eq "accept">	
																	
					    <!--- will be saving this now first --->
															
						<cfset url.action = "new">
	
						<cf_assignid>
						<cfset url.id              = rowguid>
						<cfset url.taskid          = form.taskid>					
						<cfset url.tbl             = "stPurchaseLineReceipt">
						<cfset form.RequisitionNo  = reqNo> 
						<cfset url.reqNo = reqNo> 						
						
					    <cfinclude template="ReceiptLineEditSubmit.cfm">
						<cfset form.RequisitionNo_1 = reqNo> 	
						
					<cfelse>	
					
					     <cfparam name="form.RequisitionNo_1" default="#ReqNo#">
										
					</cfif>
													
					<cfset reqno  = Evaluate("FORM.RequisitionNo_#Rec#")>
																
					<cfquery name="Line" 
						 datasource="AppsPurchase" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT H.OrderType, T.ReceiptValueValidate,
						        P.*, R.Warehouse, R.Mission
						 FROM   Purchase H,
						        PurchaseLine P, 
						        RequisitionLine R,
								Ref_OrderType T
						 WHERE  H.PurchaseNo = P.PurchaseNo		
						 AND    T.Code = H.orderType
						 AND    P.RequisitionNo = '#reqNo#'
						 AND    P.RequisitionNo = R.Requisitionno
					</cfquery>			
												
					<cfquery name="Check" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *
						 FROM     stPurchaseLineReceipt
						 WHERE    RequisitionNo = '#reqNo#' 
					 </cfquery>
					 
					 <cfif Check.recordcount gte "1">
				    	  <cfset commit = "1">
					 </cfif>
					 
					<!--- line --->
																					
					<cfquery name="AddReceipt" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    INSERT INTO PurchaseLineReceipt
								(RequisitionNo,
								 ReceiptId,
								 ReceiptNo,
								 PackingSlipNo,
								 DeliveryDate,
								 DeliveryDateEnd,
								 DeliveryOfficer,
								 ReceiptItem,
								 ReceiptItemNo,
								 ReceiptQuantity,
								 ReceiptOrderMultiplier,
								 WorkOrderId,
								 WorkOrderLine,
								 RequirementId,
								 WarehouseTaskId,
								 Warehouse,
								 TransactionLot,
								 WarehouseItemNo,
								 WarehouseUoM,
								 ReceiptMultiplier,
								 ReceiptUoM,
								 Currency,
								 ReceiptZero,
								 ReceiptPrice,
								 ReceiptDiscount,
								 ReceiptTax,
								 TaxIncluded,
								 ReceiptAmountCost,
								 ReceiptAmountTax,
								 ExchangeRate,
								 ReceiptAmountBaseCost,
								 ReceiptAmountBaseTax,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						 SELECT  P.RequisitionNo,
						         P.ReceiptId,
							     '#ReceiptNo#',
								 '#Form.PackingSlipNo#',
								 P.DeliveryDate,
								 P.DeliveryDateEnd,
								 P.DeliveryOfficer,
								 P.ReceiptItem,
								 P.ReceiptItemNo,
								 P.ReceiptQuantity,
								 P.ReceiptOrderMultiplier,
								 P.WorkOrderId,
								 P.WorkOrderLine,
								 P.RequirementId,
								 P.WarehouseTaskId,
								 P.Warehouse,
								 P.TransactionLot,
								 P.WarehouseItemNo,
								 P.WarehouseUoM,
								 P.ReceiptMultiplier,
								 P.ReceiptUoM,
								 P.Currency,
								 P.ReceiptZero,
								 P.ReceiptPrice,
								 P.ReceiptDiscount,
								 P.ReceiptTax,
								 P.TaxIncluded,
								 P.ReceiptAmountCost,
								 P.ReceiptAmountTax,
								 P.ExchangeRate,
								 P.ReceiptAmountBaseCost,
								 P.ReceiptAmountBaseTax,
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#'
						FROM     stPurchaseLineReceipt P
						WHERE    P.RequisitionNo = '#reqNo#'  
						AND      OfficerUserId = '#session.acc#'
					</cfquery>
					
					<!--- also pass the detail lines --->
					
					<cfquery name="AddReceiptDetails" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    INSERT INTO PurchaseLineReceiptDetail
								(ReceiptId, 
								 ReceiptLineNo,
								 ContainerName, 
								 ContainerSeal, 						
								 QuantityShipped, 
								 MeterReadingInitial,
								 MeterReadingFinal,
								 Measurement0,
								 Measurement1,
								 Measurement2,
								 Measurement3,
								 ReceiptMetric1,
								 ReceiptMetric2,
								 ReceiptMetric3,
								 ReceiptMetric4,
								 QuantityAccepted, 
								 Observation,
								 StorageId,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						 SELECT  ReceiptId, 
								 ReceiptLineNo,
								 ContainerName, 
								 ContainerSeal, 
								 QuantityShipped, 
								 MeterReadingInitial,
								 MeterReadingFinal,
								 Measurement0,
								 Measurement1,
								 Measurement2,
								 Measurement3,
								 ReceiptMetric1,
								 ReceiptMetric2,
								 ReceiptMetric3,
								 ReceiptMetric4,
								 QuantityAccepted, 
								 Observation,
								 StorageId,
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#'
						FROM     stPurchaseLineReceiptDetail P
						WHERE    P.ReceiptId IN (SELECT ReceiptId
						                         FROM   stPurchaseLineReceipt 
												 WHERE  RequisitionNo = '#reqNo#')
						<!--- exists in parent --->						 
						AND      P.ReceiptId IN (SELECT ReceiptId  			 
						                         FROM   PurchaseLineReceipt
												 WHERE  ReceiptId = P.ReceiptId) 						 
												 
												
					</cfquery>
													
					<cfquery name="clean" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 DELETE  FROM  stPurchaseLineReceipt
					 WHERE   RequisitionNo = '#reqNo#'
					 AND     OfficerUserId = '#session.acc#'
					</cfquery>	
					
					<cfif Line.ReceiptValueValidate eq "1">
					
						<cf_validateAmount reqno="#reqno#" currency="#line.currency#" errormessage="#vMessage1#">
						
						<cfif purchasevalidate eq "0">								
				  
							 <script>
								 	try{
										document.getElementById("submit").className = "regular"								
										parent.document.getElementById("submit").className = "regular"
									} catch(e) {}	
									Prosis.busy('no')
							  </script>									 
							  <cfabort>
						  	
						</cfif>
						
					</cfif>	
									  
				  <cfinvoke component      = "Service.Process.Procurement.PurchaseLine"  
							method         = "getDeliveryStatus" 
							RequisitionNo  = "#reqNo#">		
											
			</cfif>
			
		</cfloop>

	</cfif>
			
</cftransaction>

<cfif workflowenabled eq "1" and url.receiptNo eq "" and form.entityclass neq "">	
		
	 <cfset link = "Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id=#receiptNo#&mode=receipt">
		 	 					 				   			   				
		   <cf_ActionListing 
		    EntityCode       = "ProcReceipt"
			EntityClass      = "#Form.EntityClass#"
			EntityClassReset = "1"
			EntityGroup      = ""
			EntityStatus     = ""			
			Mission          = "#Form.Mission#"
			OrgUnit          = ""			
			ObjectReference  = "#receiptNo#"
			ObjectReference2 = "#Form.ReceiptReference1#"
			ObjectKey1       = "#receiptNo#"			
		  	ObjectURL        = "#link#"
			Show             = "No"
			ActionMail       = "Yes"
			Questionaire     = "Yes"
			FormData         = "#Form#"
			PersonNo         = ""
			PersonEMail      = ""
			TableWidth       = "100%"
			DocumentStatus   = "0">		
			
</cfif>		

<cfif url.mode eq "task" or url.mode eq "direct">

  <cfoutput>
	  <script>  
			 try {	 
			 parent.opener.document.getElementById("refresh_#url.box#").click()     
			 } catch(e) {}
			 Prosis.busy('no')
		     parent.window.close()	 
	  </script>
  </cfoutput>

<cfelseif commit eq "1">
			
	<cfoutput>
		<script language="JavaScript">
		    ptoken.location("ReceiptEditContent.cfm?header=#URL.header#&id=#receiptNo#&mode=receipt")		    
		 </script>
	</cfoutput>	
		
<cfelse>

	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    ReceiptSerialNo = ReceiptSerialNo - 1
			WHERE  Mission  = '#Form.Mission#'
	</cfquery>
				
	<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE  Receipt
			WHERE   ReceiptNo = '#Parameter.ReceiptPrefix#-#ser#'
	</cfquery>
	
	<cf_tl id="You have not entered any receipts. Operational not allowed" var="1">					
	<cf_alert message = "#lt_text#" return = "back">
	
	<script>
		document.getElementById("submit").className = "regular"
		Prosis.busy('no')
	</script>
			    
</cfif>



