<!--
    Copyright © 2025 Promisan B.V.

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
<!---  Name: /Component/Process/Procurement/PurchaseLine.cfc
       Description: Purchase Line procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "PurchaseLineRoutine">
	
	<cffunction name="getDeliveryStatus"
             access="public"
             returntype="struct"
             displayname="DeliveryStatus">
		
		<cfargument name="RequisitionNo"      type="string" required="true"  default="">	
		
		<!--- get the entry mode --->
		
		<cfquery name="Purchase" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      PurchaseLine P INNER JOIN
                   RequisitionLine RL ON P.RequisitionNo = RL.RequisitionNo
		 WHERE     P.RequisitionNo = '#RequisitionNo#'		
		</cfquery>
		
		<cfquery name="Mode" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_OrderType
				 WHERE  Code IN (SELECT OrderType FROM Purchase WHERE PurchaseNo = '#Purchase.PurchaseNo#')
		</cfquery>
		
		<cfif Purchase.RecordStatus eq "1">			
			
			<cfset st = "0">	
		   				
			<!--- the receipt is again the order line quantity or determined as such as the underlying item was a stockitem --->
						
			<cfif Mode.ReceiptEntry eq "0">
			
					<!--- this is purely driven by quantities --->
														
					<cfquery name="Check" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT SUM(ReceiptOrder)   as ReceiptQuantity,
						        SUM(ReceiptAmount)  as ReceiptValue
						 FROM   PurchaseLineReceipt
						 WHERE  ActionStatus != '9'
						 AND    RequisitionNo = '#RequisitionNo#' 
					</cfquery>
					
					<cfif check.recordcount eq "1">
									
						<cfif Check.receiptQuantity gte Purchase.OrderQuantity>					
							 <cfset st = "3">											 				
						<cfelse>					
						     <cfset st = "2">													
						</cfif>				
									
					</cfif>
																				
					<cfset quantityreceived  = Check.receiptQuantity>
					<cfset totalreceived     = Check.receiptValue>
					
					
			<cfelse>
			
					<cfset quantityreceived = "0">
			
				    <cfquery name="getCurrency" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT DISTINCT Currency
						 FROM   PurchaseLineReceipt
						 WHERE  ActionStatus != '9'
						 AND    RequisitionNo = '#RequisitionNo#' 
					</cfquery>		 
			
				   <cfquery name="Receipts" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   PurchaseLineReceipt
						 WHERE  ActionStatus != '9'
						 AND    RequisitionNo = '#RequisitionNo#'
					</cfquery>
					
					<cfset totalreceived = 0>
					
					<cfif Receipts.recordcount gte "1">
					
						<cfloop query="Receipts">
						
							<cfif Receipts.Currency eq Purchase.Currency and getCurrency.recordcount eq "1">	
							
								<!--- same currency as PO --->							
								<cfset totalreceived = totalreceived + ReceiptAmount>										
							
							<cfelse>
							
								<!--- base currency --->						
								<cfset totalreceived = totalreceived + ReceiptAmountBase>				
													
							</cfif>
																
						</cfloop>
					
						<cfif Receipts.Currency eq Purchase.Currency and getCurrency.recordcount eq "1">	
						
							<cfset totalorder = Purchase.OrderAmount>
						
							<cfif totalreceived gt "0" and (Purchase.OrderAmount - totalreceived) lte 0.01>
								    <cfset st = "3">
							<cfelseif (Purchase.OrderAmount - totalreceived) gt 0.01>
								    <cfset st = "2">		
							<cfelse>
								    <cfset st = "0">	
							</cfif>			
							
			
						<cfelse>
						
							<cfset totalorder = Purchase.OrderAmountBase>
						
							<cfif totalreceived gt "0" and (Purchase.OrderAmountBase - totalreceived) lte 0.01>
								    <cfset st = "3">
							<cfelseif (Purchase.OrderAmount - totalreceived) gt 0.01>							
								    <cfset st = "2">
							<cfelse>
								    <cfset st = "0">	
							</cfif>			
						
						</cfif>
									
					</cfif>	
								
			</cfif>	
		
			<cfquery name="SetStatus" 
				 datasource="AppsPurchase" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
					 UPDATE PurchaseLine
					 SET    DeliveryStatus     = '#st#', 
					        DeliveryStatusDate = getDate() 
					 WHERE  RequisitionNo = '#RequisitionNo#'
					 -- AND    DeliveryStatus != '#st#'
			</cfquery>		
			
		<cfelse>
		
			<!--- it is always completed --->
			<cfset st = "3">
		
			<cfquery name="SetStatus" 
				 datasource="AppsPurchase" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				
					 UPDATE PurchaseLine
					 SET    DeliveryStatus = '3', 
					        DeliveryStatusDate = getDate()  
					 WHERE  RequisitionNo = '#RequisitionNo#'
					 -- AND    DeliveryStatus != '3'
			</cfquery>				
		
		</cfif>		
		
		<cfparam name="QuantityReceived" default="0">
		<cfparam name="TotalOrder"       default="0">
		<cfparam name="TotalReceived"    default="0">
		
		<cfset Receipt.Status        = st>
		<cfset Receipt.quantity      = QuantityReceived>
		<cfset Receipt.orderquantity = Purchase.OrderQuantity>
		
		<cfset Receipt.value         = TotalReceived>
		
		<cfset Receipt.ordervalue    = TotalOrder>
		
		<cfset Receipt.Threshold     = Mode.ReceiptValueComplete>
								   
		<cfreturn Receipt>		
		 
   </cffunction>
			
</cfcomponent>	 