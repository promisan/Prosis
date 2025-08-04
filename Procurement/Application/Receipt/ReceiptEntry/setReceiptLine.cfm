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

<!--- retrieve purchase lines --->
<cfquery name="get" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
	  SELECT  Req.RequestType, 
 	          Req.CaseNo,
	          Req.RequestQuantity, 
			  Req.QuantityUoM,
			  Req.WarehouseItemNo,
			  Req.WarehouseUoM,
	          PL.*, 			  
			  Req.Warehouse,			  
			  (	   SELECT   SUM(RCT.ReceiptQuantity*RCT.ReceiptOrderMultiplier) <!--- 6/3 to add the multiplier to determine the quantiy expressed in UoM of the order --->
			   	   FROM     PurchaseLineReceipt RCT 
				   WHERE    RCT.RequisitionNo = PL.RequisitionNo
	    	       AND      RCT.ActionStatus != '9'
			  ) AS ReceiptQuantity
			  			  
	  FROM    RequisitionLine Req INNER JOIN PurchaseLine PL ON PL.RequisitionNo = Req.RequisitionNo		 	  
	  AND     PL.RequisitionNo = '#url.RequisitionNo#' 	  
 </cfquery>
 
 <cfif get.Currency eq url.currency>
 
	 <cfset exc = "1">
		 
 <cfelse>
  
 	<cf_exchangeRate datasource = "appsMaterials"		
        CurrencyFrom        = "#get.Currency#"
		CurrencyTo          = "#url.currency#"> 	
				 
 </cfif>
  
 <!--- express the purchase line currency into the select expressing valuation price --->
  
 <cfset ordercostvalue     = (get.OrderAmountCost/get.OrderQuantity)/exc>
 
<cfoutput> 

     <!--- in the purchase we set a multiplier for the line, which is defined with the 
	 original requisition as the basis for that item --->  
		 
	 <cfquery name="UoMRequest" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemUoM
		WHERE  ItemNo = '#get.WarehouseItemNo#'				
		AND    UoM    = '#get.WarehouseUoM#'
	</cfquery>		 
	
	<!--- this is the UoM of the receipt, which will be usually asis defined in the purchase line --->
 
 	 <cfquery name="UoMReceipt" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemUoM
		WHERE  ItemNo = '#get.WarehouseItemNo#'				
		AND    UoM    = '#url.uom#'
	</cfquery>	
	
	<!--- this is the UoM of the stocking, which will usually be the UoM of the request --->
	
	<cfif url.WarehouseItemUoM neq "as is">
			
	 <cfquery name="UoMStock" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemUoM
		WHERE  ItemNo = '#get.WarehouseItemNo#'				
		AND    UoM    = '#url.WarehouseItemUoM#' 
	</cfquery>	
	
	<cfelse>
	
		<cfparam name="UoMStock.UOMMultiplier" default="#get.OrderMultiplier * UoMRequest.UOMMultiplier#">		
			
	</cfif>
	
	<cfif url.uom eq "asis">
	
		<cfset receiptmultiplier = 1>
	
	<cfelse>
			
		<!--- this is an effort to correct the receipt to the proper order quantity,
		if for example the PO is in bundles and you decide to receive
		in each, then the multiplier for the PO receipt = 0.5 --->	
		<cfset receiptmultiplier = (get.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMReceipt.UOMMultiplier>
		
					
	</cfif>	
			
	<input type     = "hidden"
	       name     = "ReceiptOrderMultiplier_#url.box#"
	       id       = "ReceiptOrderMultiplier_#url.box#"											   
	       value    = "#receiptmultiplier#"
		   class    = "regularxl">		 	 	    
	 
	<cfset receiptonorder = round(url.quantity/receiptmultiplier*100000)/100000>
	
	<cfif get.OrderUoMVolume neq "">
		<cfset volume = round(receiptonorder * get.OrderUoMVolume *1000)/1000>
	<cfelse>
		<cfset volume = 0>
	</cfif>	
		
	<cfset stockmultiplier = (get.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMStock.UOMMultiplier>
	<cfset stockmultiplier = round(stockmultiplier*10000)/10000>
		
	<cfset receiptinstock  = round((receiptonorder * stockmultiplier)*100000)/100000>	
		
	<cfset stockprice      = ordercostvalue / stockmultiplier>
	
	<cfif url.mode eq "quantity" or url.mode eq "currency" or url.mode eq "editcurrency">
	
		<cfif stockprice lte "0.01">
			<cfset sp = numberformat(stockprice,"._____")>
		<cfelse>
			<cfset sp = numberformat(stockprice,".___")> 
		</cfif>	
		
	<cfelse>
	
		<cfset sp = url.price>
	
	</cfif>	
		
	<cfif not LSIsNumeric(url.price)>
	
		<script>
		    alert('Incorrect stock price')
		</script>	 		
		<cfabort>
		
	</cfif>	
		   
	 <input type     = "hidden"
	       name      = "ReceiptMultiplier_#url.box#"
	       id        = "ReceiptMultiplier_#url.box#"											   
	       value     = "#StockMultiplier#"
		   class     = "regularxl">	     
	  	 	   
	   <script language="JavaScript">
	   	   	   
		   	<cfif url.mode eq "quantity">					
				  	
				  document.getElementById('boxwarehousemultiplier_#url.box#').innerHTML  = "#StockMultiplier#"					 					  	  
				  document.getElementById('boxordermultiplier_#url.box#').innerHTML      = "#receiptonorder#"					 
				  document.getElementById('boxwarehousequantity_#url.box#').innerHTML    = "#numberformat(receiptinstock,"__._")#"	
				
				  <cfif url.quantity neq "" and url.quantity neq "0">
				  document.getElementById('ReceiptQuantity_#url.box#').style.backgroundColor = "80FF00"
				  <cfelse>
				  document.getElementById('ReceiptQuantity_#url.box#').style.backgroundColor = "white"
				  </cfif>
				   	 
				  // set the estimated price of the items as to be stored into the stock	
				  document.getElementById('ReceiptVolume_#url.box#').value               = "#volume#"		 				  
				  document.getElementById('WarehousePrice_#url.box#').value              = "#sp#"		 
				  document.getElementById('boxwarehousevalue_#url.box#').innerHTML       = "#numberformat(receiptinstock*(ordercostvalue/stockmultiplier),".__")#"		 
				  
			<cfelseif url.mode eq "quantityline">		
				 						
				  document.getElementById('warehousequantity').value                     = "#round(url.quantity*StockMultiplier/receiptmultiplier*100)/100#"		
				  document.getElementById('warehousetotal').value                        = "#round(url.quantity*StockMultiplier/receiptmultiplier*url.price*100)/100#"								  	  
				
			
			<cfelseif url.mode eq "currency">
											
				   document.getElementById('WarehousePrice_#url.box#').value             = "#sp#"					 
				   <cfset val = sp>						 	
				   document.getElementById('boxwarehousevalue_#url.box#').innerHTML      = "#numberformat(receiptinstock*(val),".__")#"	
				   
			<cfelseif url.mode eq "editcurrency">
			
				   document.getElementById('warehouseprice').value                       = "#sp#"		
				   <cfset val = sp/exc>					
				   document.getElementById('warehousetotal').value                       = "#numberformat(receiptinstock*(val),".__")#"											
				   
			<cfelseif url.mode eq "price">
													
				<cfset val = sp/exc>					
			    document.getElementById('boxwarehousevalue_#url.box#').innerHTML         = "#numberformat(receiptinstock*(val),".__")#"									
				
			<cfelseif url.mode eq "editprice">
			
				<cfset val = sp/exc>					
			    document.getElementById('warehousetotal').value                          = "#numberformat(receiptinstock*(val),".__")#"		
							  
			</cfif> 
		    
	   </script>	 
	   
</cfoutput>
