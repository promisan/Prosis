
<cfparam name="Form.QuoteZero"               default="0">
<cfparam name="Form.ReceiptPrice"            default="0">
<cfparam name="Form.PersonNo"                default="">
<cfparam name="Form.Remarks"                 default="">
<cfparam name="Form.ReceiptVolume"           default="0">
<cfparam name="Form.WarehouseReceiptUoM"     default="">
<cfparam name="Form.RequisitionNo"           default="#URL.reqno#">

<cfif not LSIsNumeric(Form.ReceiptPrice)>

	<cf_tl id="Incorrect Price" var="1">
		
	<cfoutput>
	
		<script>
		    alert('#lt_text#')
		</script>	
				
		<cfabort>
		
	</cfoutput>
	
</cfif>

<cfquery name="Requisition" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine L INNER JOIN ItemMaster M ON L.ItemMaster  = M.Code
	WHERE  RequisitionNo = '#form.RequisitionNo#'	
</cfquery>

<cfquery name="PO" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   PurchaseLine L 
	       INNER JOIN Purchase P ON L.PurchaseNo = P.PurchaseNo
	       INNER JOIN Ref_OrderType R ON P.OrderType  = R.Code
	WHERE  RequisitionNo = '#Form.RequisitionNo#' 	
</cfquery>

<cfif URL.action eq "new">	
	<cfset NewLine()>
<cfelse>
	<cfif url.process eq "delete"> 
		<cfset DeleteLine()>			
	<cfelse>	
		<cfset EditLine()>	
	</cfif>	
</cfif>

<cfif url.process eq "savekeep"> 

	<!--- no action --->
	
<cfelse>
	
	<cfoutput>
				
		<script language="JavaScript">				
		
			se = parent.document.getElementById('add#Form.RequisitionNo#Exp')		
			if (se) {	  
			    se.click()	  
			} else {
			    se = parent.document.getElementById('box_#url.taskid#')
			    if (se) {
				    se.click()
				} else {				
					 se = parent.document.getElementById('financial')
			         if (se) {					    
				        parent.reload()
					 } else {	
				       parent.parent.history.go()
					}
				}	
			}			
			parent.ProsisUI.closeWindow('receiptdialog');
						
		</script>
				
	</cfoutput>

</cfif>

<cffunction name="NewLine">

	<cf_tl id="You entered a receipt for a value which exceeded the Purchase Order amount of " class="message" var="vMessage1">

	<cftransaction>
				
	<cfquery name="Clean" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    DELETE FROM #URL.Tbl#
		WHERE  ReceiptId = '#url.id#'   
	</cfquery>
	
	<!--- start --->
	
	<cfparam name="Form.receiptstarthour"   default="12">
	<cfparam name="Form.TransactionLot"     default="0">
	<cfparam name="Form.receiptstartminute" default="00">
	
	<cfparam name="Form.receiptendhour"     default="12">
	<cfparam name="Form.receiptendminute"   default="00">
			
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DeliveryDate#">
	<cfset dte = dateValue>
	
	<cfset dte = dateadd("H",  Form.receiptstarthour,  dte)>
	<cfset dte = dateadd("N",  Form.receiptstartminute,  dte)>
	
	<!--- end --->
	
	 <cfif form.RequestType eq "warehouse" or  form.RequestType eq "generate">
	  	<cfparam name="Form.Warehouse"   default="">
		
		<cfif Form.warehouse eq "">
			<script>
			alert("No destination site/facility selected.")
			</script>
			<cfabort>
		</cfif>
		
	 </cfif>
	 			
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DeliveryDate#">
	<cfset dtd = dateValue>
	
	<cfset dtd = dateadd("H",  Form.receiptendhour, dtd)>
	<cfset dtd = dateadd("N",  Form.receiptendminute, dtd)>
	
	<!--- we first will generate an warehouse item/uom/mission 
	     or validate if it is indeed there --->
	
	<cfif form.requestType eq "generate">	
		<cfset GenerateItem()>			
	</cfif>	
	
	<cfparam name="Form.WarehouseReceiptUoM" default="">
	<cfif Form.WarehouseReceiptUoM eq "">
	    <cfset ReceiptUoM = Form.receiptuom>
	<cfelse>
	    <cfset ReceiptUoM = Form.WarehouseReceiptUoM>
	</cfif>		
	
	<cfif form.WarehouseReceiptUoM eq "" or
		  form.RequestType neq "warehouse">
		  
		<cfset OrderMultiplier   = "1">  
				
		<cfset StockMultiplier   = Form.ReceiptMultiplier>
		<cfset ReceiptQty        = Form.ReceiptQuantity>		
														
	<cfelse>
					
		<!--- determine the multiplier of the receipt to the ordered quantity in order to show the pending
		by taking the multiplier of the receipt UoM and divide it by the multiplier that underlies the 
		of the purchase line, this is an indirect way. 
		
		Imagine the requisition was in each (1), the purchase in packages of 7 (7), the receipt in sixpacks (6), to match the receipt
		to the order quantity the receipt quantity has to be muliplied by 6/7 to compare it with the ordered quantity --->
						 
		 <cfquery name="UoMRequest" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Materials.dbo.ItemUoM
			WHERE  ItemNo = '#Requisition.WarehouseItemNo#'				
			AND    UoM    = '#Requisition.WarehouseUoM#'
		</cfquery>		 
	 
		<cfif form.WarehouseReceiptUoM eq "asis">
			<cfset form.WarehouseReceiptUoM =Requisition.WarehouseUoM> 
		</cfif>	 	 
	 
	 	 <cfquery name="UoMReceipt" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Materials.dbo.ItemUoM
			WHERE  ItemNo = '#Requisition.WarehouseItemNo#'				
			AND    UoM    = '#form.WarehouseReceiptUoM#'
		</cfquery>	
				
		 <cfquery name="UoMStock" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Materials.dbo.ItemUoM
			WHERE  ItemNo = '#Requisition.WarehouseItemNo#'				
			AND    UoM    = '#form.ItemUoM#'
		</cfquery>	
		
		<cfif UoMRequest.recordcount eq "0">
		
			<cfset OrderMultiplier = 1>
		
		<cfelse>
				
			<cfset OrderMultiplier = (PO.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMReceipt.UOMMultiplier>
			
		</cfif>					
							
		<!--- the actual receipt in the warehouse UoM drives the transactions --->
						
		<cf_getUoMMultiplier Datasource= "AppsPurchase"
		                     ItemNo    = "#Form.ItemNo#" 
		                     UoMFrom   = "#form.WarehouseReceiptUoM#" 
							 UoMTo     = "#form.ItemUoM#">
							 
														 
		<cfset StockMultiplier  = UoMMultiplier*OrderMultiplier>
		<cfset ReceiptQty       = Form.ReceiptQuantity>
												
	</cfif>		 
	
	<cf_assignId>	
	
	<!--- ------------------------------------------------------------------------------------------ --->
	<!--- provision to verify if the workorder requirementid is still valid or needs to be corrected --->
	<!--- ------------------------------------------------------------------------------------------ --->	
	
	<cfif form.workorderid neq "" and form.RequirementId neq "">
	
		<cfquery name="checkWorkOrder" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderLineItem
				WHERE     WorkOrderItemId = '#Form.RequirementId#'
		</cfquery>
		
		
		<cfquery name="checkResource" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderLineResource
				WHERE     ResourceId      = '#Form.RequirementId#'
		</cfquery>
		
		<cfif checkworkorder.recordcount eq "1" or checkresource.recordcount eq "1">
		
			<cfset reqid = form.requirementid>
		
		<cfelse>
		
			<cfquery name="checkWorkOrder" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderLineItem
				WHERE     WorkOrderId     = '#form.WorkOrderId#' 
				AND       WorkOrderLine   = '#form.WorkOrderline#' 
				AND       ItemNo          = '#Requisition.WarehouseItemNo#'
				AND       UoM             = '#Requisition.WarehouseUoM#'
		    </cfquery>
			
			<cfif checkworkorder.recordcount eq "1">
			
				<cfset reqid = checkWorkOrder.WorkOrderItemId>
				
			<cfelse>
			
				<cf_tl id="Workorder line not found" var="1">
		
				<cfoutput>
				
					<script>
					    alert('#lt_text#')
					</script>	
							
					<cfabort>
					
				</cfoutput>
			
			</cfif>		
			
		</cfif>		
			
	</cfif>	
			
	<cfquery name="Insert" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		 		  		  
		  INSERT INTO #URL.Tbl#
			  (ReceiptId,
			   RequisitionNo, 
			   DeliveryDate, 
			   DeliveryDateEnd, 
			   DeliveryOfficer,
			   PersonNo,
			   ReceiptItemNo,		   
			   ReceiptUoM,
			   ReceiptQuantity, 	
			   ReceiptOrderMultiplier,						   			   
			   ReceiptItem,
			   <cfif form.workorderid neq ""> 
			   WorkOrderId,
			   WorkOrderLine,
			   <cfif form.RequirementId neq "">
			   RequirementId,
			   </cfif>
			   </cfif>
			   WarehouseTaskId,
			   Warehouse, 
			   TransactionLot,
			   WarehouseItemNo, 
			   WarehouseUoM, 		
			   ReceiptMultiplier, 
			   Remarks, 
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
			   ActionStatus, 
			   OfficerUserid, 
			   OfficerLastName, 
			   OfficerFirstName) 
		  VALUES
			  ('#rowguid#',
			   '#Form.RequisitionNo#', 
			   #dte#, 
			   #dtd#, 
			   '#Form.DeliveryOfficer#',
			   '#Form.PersonNo#',
			   <cfif form.RequestType eq "regular">
				   '#Form.ReceiptItemNo#',
				   '#ReceiptUoM#',
			   <cfelse>	  
			       '#Form.ItemNo#',
				   '#ReceiptUoM#', 
			   </cfif>
			   '#ReceiptQty#',
			   '#OrderMultiplier#',
			   
			   <!--- purchase quantity --->
			   
			   '#Form.ReceiptItem#',
			   <cfif form.workorderid neq "">
				   '#Form.WorkOrderId#',
				   '#Form.WorkOrderLine#',
				    <cfif form.RequirementId neq "">
				   '#reqid#', <!--- revised id in case no longer exists --->
				   </cfif>
			   </cfif>			   
			   <cfif url.taskid neq "">
			   '#url.taskid#',
			   <cfelse>
			   NULL,
			   </cfif>
			   <cfif form.RequestType eq "warehouse"> 
				   '#Form.Warehouse#',
				   '#Form.TransactionLot#',
				   '#Form.ItemNo#',
				   '#Form.ItemUoM#', 
			   <cfelseif form.RequestType eq "generate"> 
				   '#Form.Warehouse#',
				   '#Form.TransactionLot#',
				   '#Form.ItemNo#',
				   '#Form.ItemUoM#',	   
			   <cfelse>
			       NULL,
				   '0',
				   NULL,
				   NULL,	   
			   </cfif>
			   '#StockMultiplier#',
			   '#Form.Remarks#',
			   '#Form.Currency#',
			   <cfif Form.QuoteZero eq "1" and Form.CostPriceB eq "0">1,<cfelse>0,</cfif>
			   '#Form.ReceiptPrice#',
			   '#Form.ReceiptDiscount/100#',
			   '#Form.ReceiptTax/100#',
			   '#Form.TaxIncl#',
			   '#Form.TaxExemption#',
			   '#Form.CostPrice#',
			    <cfif Form.TaxExemption eq "1">
					0,	
				 <cfelse>
					'#Form.TaxPrice#',
				 </cfif>		  
			   '#Form.ExchangeRate#',
			   '#Form.CostPriceB#',
			   <cfif Form.TaxExemption eq "1">
					 0,	
			   <cfelse>
					 '#Form.TaxPriceB#',
			    </cfif>
			   '0',
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#')		
			   
		</cfquery>
				
		<cfloop index="itm" from="1" to="#PO.receiptentrylines#">
		
			<cfparam name="f#itm#_containername"         default="">
			<cfparam name="f#itm#_containerseal"         default="">
			<cfparam name="f#itm#_quantityshipped"       default="0">
			<cfparam name="f#itm#_quantityaccepted"      default="0">
			<cfparam name="f#itm#_meterreadinginitial"   default="0">
			<cfparam name="f#itm#_meterreadingfinal"     default="0">
			<cfparam name="f#itm#_measurement0"          default="0">
			<cfparam name="f#itm#_measurement1"          default="0">
			<cfparam name="f#itm#_measurement2"          default="0">
			<cfparam name="f#itm#_measurement3"          default="0">
			<cfparam name="f#itm#_receiptmetric1"        default="0">
			<cfparam name="f#itm#_receiptmetric2"        default="0">
			<cfparam name="f#itm#_receiptmetric3"        default="0">
			<cfparam name="f#itm#_receiptmetric4"        default="0">
			<cfparam name="f#itm#_observation"           default="">
			<cfparam name="f#itm#_storageid"             default="00000000-0000-0000-0000-000000000000">
		
			<cfset con = evaluate("f#itm#_containername")>
			<cfset sea = evaluate("f#itm#_containerseal")>
			<cfset shp = evaluate("f#itm#_quantityshipped")>
			<cfset acc = evaluate("f#itm#_quantityaccepted")>
			
			<cfset mei = evaluate("f#itm#_meterreadinginitial")>
			<cfset mef = evaluate("f#itm#_meterreadingfinal")>
			
			<cfset ms0 = evaluate("f#itm#_measurement0")>
			<cfset ms1 = evaluate("f#itm#_measurement1")>
			<cfset ms2 = evaluate("f#itm#_measurement2")>
			<cfset ms3 = evaluate("f#itm#_measurement3")>
			
			<cfset me1 = evaluate("f#itm#_receiptmetric1")>
			<cfset me2 = evaluate("f#itm#_receiptmetric2")>
			<cfset me3 = evaluate("f#itm#_receiptmetric3")>
			<cfset me4 = evaluate("f#itm#_receiptmetric4")>
			<cfset obs = evaluate("f#itm#_Observation")>
			<cfset sti = evaluate("f#itm#_StorageId")>
								
			<cfif acc gt "0">
					
				<cfquery name="InsertLines" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">				  
				  INSERT INTO #URL.TBL#Detail
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
						StorageId)
				  VALUES
					     ('#rowguid#',
						  '#itm#',
						  '#con#',
						  '#sea#',
						  '#shp#',
						  '#mei#',	
						  '#mef#',			  						  
						  '#ms0#',	
						  '#ms1#',						  
						  '#ms2#',	
						  '#ms3#',	
						  '#me1#',	
						  '#me2#',
						  '#me3#',
						  '#me4#',
						  '#acc#',	
						  '#obs#',
						  '#sti#')	
				</cfquery>
			
			</cfif>		
		
		</cfloop>	
					
		<cfif PO.ReceiptValueValidate eq "1">
		
			<!--- check if the amount of the receipt does not exceed the purchase --->	
							
			<cf_validateAmount reqno="#URL.reqno#" currency="#Form.currency#" errormessage="#vMessage1#">
								
			 <cfif purchasevalidate eq "0">					 			  
				 					 
					 <cfabort>
				  	
			  </cfif>
									
		</cfif>	
				
	</cftransaction>	
						
</cffunction>

<cffunction name="DeleteLine">
	<cfargument name="purge" type="boolean" required="yes" default="TRUE">  

		 <cfquery name="Check" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   #URL.Tbl#		  
			  WHERE  ReceiptId = '#URL.ID#'
		</cfquery>
		
		<!--- reset the PO status as the receipt will mean PO needs to be reset --->
		
		<cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  UPDATE Purchase
			  SET    ActionStatus = '3'
			  WHERE  ActionStatus = '4'
			  AND    PurchaseNo IN (SELECT PurchaseNo 
			                        FROM   #URL.Tbl# 
						  		    WHERE  ReceiptId = '#URL.ID#')
		 </cfquery> 
		 
		 <!--- Not sure if this also applies for open contract --->
		 
		 <cfinvoke component = "Service.Process.Procurement.PurchaseLine"  
							   method           = "getDeliveryStatus" 
							   RequisitionNo    = "#Check.RequisitionNo#">		
							   
		<cftransaction>
		
		<cfquery name="getLines" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   ItemTransaction	  
			  WHERE  ReceiptId = '#URL.ID#'
		</cfquery>
		
		<cfloop query="getLines">
		
			<cfquery name="RemoveValuationSource" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  DELETE FROM ItemTransactionValuation	  
				  WHERE  TransactionId = '#TransactionId#'
			</cfquery>
		
			<cfquery name="RemoveTransaction" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  DELETE FROM ItemTransaction	  
				  WHERE  TransactionId = '#TransactionId#'
			</cfquery>
			
			<!-- this will also cancel the postings in ledger --->
		
		</cfloop>			
						   	 			
		 
		<cfif Purge>
		
			  <cfquery name="CheckPrior" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM Purchase.dbo.#URL.Tbl#Cost
				WHERE  ReceiptId = '#URL.ID#'						
		    </cfquery>
		
			<cfquery name="Remove" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  DELETE FROM Purchase.dbo.#URL.Tbl#		  
				  WHERE  ReceiptId = '#URL.ID#'
			</cfquery>
			
		</cfif> 	
		
		</cftransaction>	
		
		<!--- ----------------------------------------------------------------------------------------------------- --->		
		<!--- this removes the materials transaction lines as well AS WELL AS the general ledger records associated --->
		<!--- ----------------------------------------------------------------------------------------------------- --->
		
		

</cffunction>

<cffunction name="EditLine">
	
		<cfparam name="Form.TransactionLot"     default="0">
		<cfparam name="Form.receiptstarthour"   default="00">
		<cfparam name="Form.receiptstartminute" default="00">
	
		<cfparam name="Form.receiptendhour"     default="00">
		<cfparam name="Form.receiptendminute"   default="00">

		<cfquery name="Check" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    #URL.Tbl#
			  WHERE   ReceiptId = '#URL.ID#' 
		 </cfquery> 

		<cfif form.requestType eq "generate">
				
			<cfset GenerateItem()>			
			
			<cfif FORM.ItemNo neq Check.WarehouseItemNo>
				<!--- We have to revert the transaction of the line receipt --->			
				<cfset DeleteLine(FALSE)>		
			</cfif>				
			
		</cfif>
				
		<cfset DoEdit()>	

</cffunction>

<cffunction name="DoEdit">

		<cfparam name="Form.TransactionLot"     default="0">

		<cfif FORM.ItemNo eq "" or Form.RequestType is "regular">
			<cfset vFilledWarehouse = FALSE>
		<cfelse>
			<cfset vFilledWarehouse = TRUE>
		</cfif>
				
		<cf_tl id="You entered a receipt for a value which exceeded the Purchase Order amount of " class="message" var="vMessage1">
		 
		<cftransaction>
					
		<!--- start --->
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DeliveryDate#">
		<cfset dte = dateValue>
		
		<cfset dte = dateadd("H",  Form.receiptstarthour,  dte)>
		<cfset dte = dateadd("N",  Form.receiptstartminute,  dte)>
		
		<!--- end --->
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DeliveryDate#">
		<cfset dtd = dateValue>
		
		<cfset dtd = dateadd("H",  Form.receiptendhour, dtd)>
		<cfset dtd = dateadd("N",  Form.receiptendminute, dtd)>
				
		<cfparam name="Form.WarehouseReceiptUoM" default="">
		<cfif Form.WarehouseReceiptUoM eq "">
		    <cfset ReceiptUoM = Form.receiptuom>
		<cfelse>
		    <cfset ReceiptUoM = Form.WarehouseReceiptUoM>
		</cfif>
										
		<!--- End if embedding this into the Item tables --->
	
		<cfif form.WarehouseReceiptUoM eq "" or form.RequestType neq "warehouse">	
		
			  
		<!--- 	  
		<cfif form.WarehouseReceiptUoM eq "" or 
		      Line.WarehouseUoM eq form.WarehouseReceiptUoM or   <!--- no difference --->
			  form.RequestType neq "warehouse">					  
			  --->
			  
			<cfset OrderMultiplier   = "1">   
			  		  			  
			<cfparam name="FORM.ItemUoM" default="">			  			 
				  			
			<cfset Stockmultiplier   = Form.ReceiptMultiplier>
			<cfset ReceiptQty        = Form.ReceiptQuantity>
														
		<cfelse>
		
			<!--- the actual receipt in the warehouse UoM drives the transactions --->
			
			<!--- determine the multiplier of the receipt to the ordered quantity in order to show the pending
			by taking the multiplier of the receipt UoM and divide it by the multiplier that underlies the 
			of the purchase line, this is an indirect way. 
			
			Imagine the requisition was in each (1), the purchase in packages of 7 (7), the receipt in sixpacks (6), to match the receipt
			to the order quantity the receipt quantity has to be muliplied by 6/7 to compare it with the ordered quantity --->			
			
			 <cfquery name="UoMRequest" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Materials.dbo.ItemUoM
				WHERE  ItemNo = '#Requisition.WarehouseItemNo#'		
				AND    UoM    = '#Requisition.WarehouseUoM#'				
			</cfquery>				
		
			<cfif Form.WarehouseReceiptUoM eq "asis">
			
				<cfquery name="UoMReceipt" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Materials.dbo.ItemUoM
					WHERE  ItemNo = '#Form.ItemNo#'				
					AND    UoM    = '#Form.ItemUoM#'
				</cfquery>	
	
				<cfset ordermultiplier = 1>
				
				<cfset stockmultiplier = (PO.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMReceipt.UOMMultiplier>
											
			<cfelse>
			
				<cfquery name="getUoM" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT * 
					FROM   Materials.dbo.ItemUoM
					WHERE  ItemNo = '#Form.ItemNo#'
					AND    UoM    = '#Form.WarehouseReceiptUoM#' 
				</cfquery>	
				
				<cfset Ordermultiplier = (PO.OrderMultiplier * UoMRequest.UOMMultiplier) / getUOM.UOMMultiplier>		
				
				<cf_getUoMMultiplier Datasource="AppsPurchase"
			                     ItemNo  = "#Form.ItemNo#" 
			                     UoMFrom = "#form.WarehouseReceiptUoM#" 
								 UoMTo   = "#form.ItemUoM#">
								 
				<cfset Stockmultiplier = UoMMultiplier * OrderMultiplier>		
				
								
			</cfif>	
									
			<cfset ReceiptQty      = Form.ReceiptQuantity>			
					
		</cfif>		
		
		
		<cfparam name="form.warehouseprice" default="">
		
		<cfquery name="get" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * FROM #URL.Tbl#		  
		  WHERE ReceiptId              = '#URL.ID#'
		</cfquery>				
						 	
		<cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  		 
		  UPDATE #URL.Tbl#
		  SET  ReceiptItemNo           = '#Form.ReceiptItemNo#',
			   ReceiptItem             = '#Form.ReceiptItem#',
			   ReceiptQuantity         = '#ReceiptQty#', 
			   ReceiptOrderMultiplier  = '#OrderMultiplier#',
			   DeliveryDate            =  #dte#,
		       DeliveryDateEnd         =  #dtd#,
			   DeliveryOfficer         = '#Form.DeliveryOfficer#', 
			   PersonNo                = '#Form.PersonNo#', 
			   ReceiptUoM              = '#ReceiptUoM#', 
			   ReceiptMultiplier       = '#StockMultiplier#', 
			   ReceiptVolume           = '#Form.ReceiptVolume#',
			   Currency                = '#Form.Currency#',
			   <cfif Form.QuoteZero eq "1" and Form.CostPriceB eq "0">
			   		ReceiptZero             = 1,
			   <cfelse>
				    ReceiptZero             = 0,
			   </cfif>
			   <cfif vFilledWarehouse> 
				 Warehouse             = '#Form.Warehouse#', 
				 TransactionLot        = '#Form.TransactionLot#',
				 WarehouseItemNo       = '#Form.ItemNo#', 
				 WarehouseUoM          = '#Form.ItemUoM#', 				 
			   <cfelse>
				 Warehouse             = NULL, 
				 TransactionLot        = '#Form.TransactionLot#',
				 WarehouseItemNo       = NULL, 
				 WarehouseUoM          = NULL, 	
			   </cfif>
			   <cfif form.warehouseprice neq "">
				   WarehouseCurrency       = '#Form.WarehouseCurrency#',
				   WarehousePrice          = '#Form.WarehousePrice#',
			   <cfelse>
			   	   WarehouseCurrency       = NULL,
			       WarehousePrice          = NULL,
			   </cfif>
			   ReceiptPrice            = '#Form.ReceiptPrice#',
			   ReceiptDiscount         = '#Form.ReceiptDiscount/100#',
			   ReceiptTax              = '#Form.ReceiptTax/100#', 
			   TaxIncluded             = '#Form.TaxIncluded#',
			   TaxExemption            = '#Form.TaxExemption#',			 
			   ReceiptAmountCost       = '#Form.CostPrice#',
			   <cfif Form.TaxExemption eq "1">
				 ReceiptAmountTax      = 0,	
			   <cfelse>
				 ReceiptAmountTax      = '#Form.TaxPrice#',
			   </cfif>				 
			   ExchangeRate            = '#Form.ExchangeRate#',
			   ReceiptAmountBaseCost   = '#Form.CostPriceB#',
			   <cfif Form.TaxExemption eq "1">
				     ReceiptAmountBaseTax  = 0,	
			   <cfelse>
				     ReceiptAmountBaseTax  = '#Form.TaxPriceB#',
			   </cfif>				 
			   Remarks                 = '#Form.Remarks#'
		  WHERE ReceiptId              = '#URL.ID#' 
		</cfquery>
				
		<!--- check if we have associated costs to be recorded --->
		
		<cfquery name="CostItem" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">				 
		 	 SELECT    *
			 FROM ReceiptCost
			 WHERE ReceiptNo  = '#get.ReceiptNo#'				
	    </cfquery>	
		
		<cfloop query="CostItem">
				
			<cfparam name="Form.AmountCalculation_#left(CostId,8)#" default="">
			<cfparam name="Form.Percent_#left(CostId,8)#"        default="">
			<cfparam name="Form.AmountCost_#left(CostId,8)#"        default="">
			
			<cfset costcal = evaluate("Form.AmountCalculation_#left(CostId,8)#")>
			<cfset costper = evaluate("Form.Percent_#left(CostId,8)#")>
			<cfset costamt = evaluate("Form.AmountCost_#left(CostId,8)#")>
			
			<cfset costcal = replace("#costcal#",",","")>
			<cfset costamt = replace("#costamt#",",","")>
			
			<cfif costcal neq "">
			
				<cfquery name="getCost" 
				 datasource="AppsPurchase"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
			 		 SELECT    *
					 FROM     PurchaseLineReceiptCost
					 WHERE    ReceiptId   = '#url.id#'				
					 AND      CostId      = '#CostId#'
			    </cfquery>	
				
				<cfif getCost.recordcount eq "1">
				
					<cfquery name="setCost" 
					 datasource="AppsPurchase"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">				 
				 		 UPDATE  PurchaseLineReceiptCost
						 SET     AmountCalculation = '#costcal#', 
						         Percentage        = '#costper#', 
								 AmountCost        = '#costamt#'
						 WHERE   ReceiptId         = '#url.id#'				
						 AND     CostId            = '#CostId#'
				    </cfquery>	
				
				<cfelse>
				
					<cfquery name="setCost" 
					 datasource="AppsPurchase"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">				 
				 		 INSERT INTO PurchaseLineReceiptCost
						 (ReceiptId,CostId, AmountCalculation,Percentage,AmountCost,OfficerUserId,OfficerLastName,OfficerFirstName)
						 VALUES ('#url.id#','#CostId#','#costcal#','#costper#','#costamt#','#session.acc#','#session.last#','#session.first#')
				    </cfquery>	
							
				</cfif>
			
			</cfif>
				
		</cfloop>
						
		<!--- get the default number of rows --->
		<cfset rows = "#PO.receiptentrylines#">
			
		 <cfquery name="CheckPrior" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   #URL.Tbl#Detail
				WHERE  ReceiptId = '#URL.ID#'						
		 </cfquery>
						
		 <cfif checkprior.recordcount gt rows>
			  <cfset rows = checkprior.recordcount>
		 </cfif>	
		 
		  <cfquery name="CheckPrior" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    DELETE FROM #URL.Tbl#Detail
				WHERE  ReceiptId = '#URL.ID#'						
		 </cfquery>
		 		 
		 <cfloop index="itm" from="1" to="#rows#">
		 
		 	<cfparam name="f#itm#_containername"         default="">
			<cfparam name="f#itm#_containerseal"         default="">
			<cfparam name="f#itm#_quantityshipped"       default="0">
			<cfparam name="f#itm#_quantityaccepted"      default="0">
			<cfparam name="f#itm#_meterreadinginitial"   default="0">
			<cfparam name="f#itm#_meterreadingfinal"     default="0">
			<cfparam name="f#itm#_measurement0"          default="0">
			<cfparam name="f#itm#_measurement1"          default="0">
			<cfparam name="f#itm#_measurement2"          default="0">
			<cfparam name="f#itm#_measurement3"          default="0">
			<cfparam name="f#itm#_receiptmetric1"        default="0">
			<cfparam name="f#itm#_receiptmetric2"        default="0">
			<cfparam name="f#itm#_receiptmetric3"        default="0">
			<cfparam name="f#itm#_receiptmetric4"        default="0">
			<cfparam name="f#itm#_observation"           default="">
			<cfparam name="f#itm#_storageid"             default="00000000-0000-0000-0000-000000000000">
		
			<cfset con = evaluate("f#itm#_containername")>
			<cfset sea = evaluate("f#itm#_containerseal")>
			<cfset shp = evaluate("f#itm#_quantityshipped")>
			<cfset acc = evaluate("f#itm#_quantityaccepted")>
			
			<cfset mei = evaluate("f#itm#_meterreadinginitial")>
			<cfset mef = evaluate("f#itm#_meterreadingfinal")>
			
			<cfset ms0 = evaluate("f#itm#_measurement0")>
			<cfset ms1 = evaluate("f#itm#_measurement1")>
			<cfset ms2 = evaluate("f#itm#_measurement2")>
			<cfset ms3 = evaluate("f#itm#_measurement3")>
			
			<cfset me1 = evaluate("f#itm#_receiptmetric1")>
			<cfset me2 = evaluate("f#itm#_receiptmetric2")>
			<cfset me3 = evaluate("f#itm#_receiptmetric3")>
			<cfset me4 = evaluate("f#itm#_receiptmetric4")>
			<cfset obs = evaluate("f#itm#_Observation")>
			<cfset sti = evaluate("f#itm#_StorageId")>
			
			<cfif acc gt "0">
					
				<cfquery name="InsertLines" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO #URL.Tbl#Detail
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
						StorageId)
				  VALUES
					     ('#url.id#',
						  '#itm#',
						  '#con#',
						  '#sea#',
						  '#shp#',
						  '#mei#',	
						  '#mef#',			  						  
						  '#ms0#',	
						  '#ms1#',						  
						  '#ms2#',	
						  '#ms3#',	
						  '#me1#',	
						  '#me2#',
						  '#me3#',
						  '#me4#',
						  '#acc#',	
						  '#obs#',
						  '#sti#')	
				</cfquery>
			
			</cfif>							
		
		</cfloop>	
		
		<!--- check --->		
		
		<cfif PO.ReceiptValueValidate eq "1">
					
			<cf_validateAmount reqno="#URL.reqno#" currency="#Form.currency#" errormessage="#vMessage1#">
						
			 <cfif purchasevalidate eq "0">		
			 	
					 <cfabort>
				  	
			  </cfif>
									
		</cfif>	
						
		</cftransaction>		

</cffunction>

<cffunction name="GenerateItem">

	   <cfif Form.ReceiptQuantity neq "">

	   <cfset cost = Form.CostPriceB / Form.ReceiptQuantity>
		
	   <!--- generate a variable with all the submitted classifications --->
		
	   <cfquery name="getTopics" 
	      datasource="AppsPurchase"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Materials.dbo.Ref_Topic T, Materials.dbo.Ref_TopicEntryClass C
		  WHERE    T.Code        = C.Code
		  AND      EntryClass    = '#Requisition.EntryClass#'
		  AND      (T.ValueClass  = 'List' OR T.ValueClass = 'Lookup')
		  AND      T.Operational = 1
		  ORDER BY ListingOrder
	   </cfquery>
	   
	   <cfset fields=ArrayNew(1)>
	   
	   <cfset itm = 0>
	   <cfset UoM = "">
	   
	   <cfparam name="Form.CategoryItem" default="">
	   
	   <cfif form.CategoryItem eq "">
		   	<script>alert("No category item selected.")</script>
			<cfabort>	   
	   </cfif>
		
		<!--- helper --->

		<cfif not isDefined("SESSION.helper")>
			<cfset helper = StructNew() /> 
		<cfelse>
			<cfset helper  = SESSION.helper>
		</cfif>
		
		<cfset helper.mode = "generate" /> 
		
		<cfset helper.category[Form.Category] = Form.CategoryItem>		
		
		<cfset values="">
		<!--- /helper --->
		
		<cfset UoMDescription = "">
	   
	    <cfloop query="getTopics">
	   
	   		<cfif values eq "">
		   		<cfset values= #evaluate("Topic_#Code#")#>
			<cfelse>
		   		<cfset values= values & "," & #evaluate("Topic_#Code#")#>
			</cfif>
	   
	   		<cfset val = evaluate("Topic_#Code#")>			
						
			<cfif itempointer eq "UoM">
			
				<cfset UoM = val>
		   		
		   		<cfquery name="getUoMDetails" 
		      	datasource="AppsPurchase"
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
			  		SELECT ListValue
			  		FROM   Materials.dbo.Ref_TopicList
			  		WHERE  Code     = '#Code#'
					AND    ListCode = '#val#'   
				</cfquery>  
				
				<cfset UoMDescription = "#getUoMDetails.ListValue#">				
				
			<cfelse>
			
				<cfset itm = itm+1>
				
				<cfset des = evaluate("Topic_#Code#")>
	   		   
				<cfset fields[itm] = {Item         = "#itm#",
		                 			  Topic        = "#Code#",                   
								      ListCode     = "#val#",
									  ListValue    = "#des#",
									  ItemPointer  = "#ItemPointer#"}>	  
									  								  
			</cfif>		
				   
	    </cfloop>
	   
  	 	 <!--- helper --->
	     <cfset helper.topics[Requisition.EntryClass] = values>
	     <cfset SESSION.helper = helper />
   		 <!--- /helper --->
	   
	    <cfif UoM eq "">
	   
		   <cfquery name="getDefaultUoM" 
		      datasource="AppsPurchase"
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT TOP 1 Code
			  FROM   Ref_UoM
			  WHERE  FieldDefault = '1'
			</cfquery>  
			
			<cfset UoM = getDefaultUoM.code>
	   
	   </cfif>
	   
	   <cfif UoMDescription eq "">
	   		<cfset UoMDescription = UoM>
	   </cfif>
	
        <cfif form.workorderid neq "">
               <cfif form.RequirementId neq "">
				   <cfquery name="getParentItem" 
				      datasource="AppsPurchase"
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">               	
							SELECT ItemNo 
							FROM   Workorder.dbo.WorkOrderLineItem
  							WHERE  WorkOrderItemId = '#FORM.RequirementId#'
				   </cfquery>
				   
				   <cfset ParentItemNo = getParentItem.ItemNo>
					
              </cfif>
        <cfelse>
            <cfset ParentItemNo = ""> 
        </cfif>  
	
	   <cfinvoke component = "Service.Process.Materials.Item"  
			   method           = "GenerateItem" 
			   mission          = "#Requisition.Mission#"
			   Category         = "#form.Category#"
			   CategoryItem     = "#Form.CategoryItem#"
			   ItemMaster       = "#Requisition.ItemMaster#"
			   UoM              = "#UoM#"
			   UoMDescription   = "#UoMDescription#"
			   Classification   = "#fields#"
			   Cost             = "#cost#"
			   ParentItemNo     = "#ParentItemNo#"			   
			   datasource       = "AppsPurchase"
			   returnvariable   = "item">	
			   
		<!--- now we have the item as if the user has recorded it directly which allows us in due course
			to post the receipt --->   
			
	    <cfif Form.TransactionLot neq 0>		
		    
		   		<cfinvoke component = "Service.Process.Materials.Item"  
				   method           = "createItemLot" 
				   Mission          = "#Requisition.Mission#"
				   ItemNo		    = "#Item.ItemNo#"
				   UoM              = "#Item.ItemUoM#"
				   Lot			    = "#Form.TransactionLot#"
				   LotDate          = "#Form.DeliveryDate#" 
				   datasource       = "AppsPurchase">
				   
		</cfif>			
		
   		<cfset FORM.ItemNo  = Item.ItemNo>
	    <cfset FORM.ItemUoM = Item.ItemUoM>
	    </cfif>
</cffunction>

<script>
	Prosis.busy('no')
</script>