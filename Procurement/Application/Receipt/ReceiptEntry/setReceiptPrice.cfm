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
			  			  
	  FROM    RequisitionLine Req,
	          PurchaseLine PL
	        
	  WHERE   PL.RequisitionNo = Req.RequisitionNo		 	  
	  AND     PL.RequisitionNo = '#url.RequisitionNo#' 	  
 </cfquery>
   
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
 
 	
	
	<!--- this is the UoM of the stocking, which will usually be the UoM of the request --->
		
	<cfif url.prior eq "asis">
	
		<cfset priormultiplier = 1>
	
	<cfelse>
			
		<!--- this is an effort to correct the receipt to the proper order quantity,
		if for example the PO is in bundles and you decide to receive
		in each, then the multiplier for the PO receipt = 0.5 --->	
		
		 <cfquery name="UoMReceipt" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   ItemUoM
			WHERE  ItemNo = '#get.WarehouseItemNo#'				
			AND    UoM    = '#url.prior#'
		</cfquery>			
		
		<cfset priormultiplier = (get.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMReceipt.UOMMultiplier>
		
	</cfif>	
	
		
	<cfif url.uom eq "asis">
	
		<cfset receiptmultiplier = 1>
	
	<cfelse>
	
		 <cfquery name="UoMReceipt" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   ItemUoM
			WHERE  ItemNo = '#get.WarehouseItemNo#'				
			AND    UoM    = '#url.uom#'
		</cfquery>	
				
		<!--- this is an effort to correct the receipt to the proper order quantity,
		if for example the PO is in bundles and you decide to receive
		in each, then the multiplier for the PO receipt = 0.5 --->	
		<cfset receiptmultiplier = (get.OrderMultiplier * UoMRequest.UOMMultiplier) / UoMReceipt.UOMMultiplier>
		
	</cfif>	
	
	<cfset price = numberformat(url.receiptprice*priormultiplier/receiptmultiplier,'.__')>
	
   <script language="JavaScript">
   
   		document.getElementById('WarehouseReceiptUoMPrior').value = '#url.uom#'
		document.getElementById('receiptprice').value = '#price#'
		document.getElementById('receiptpriceShow').value = '#price#'
		document.getElementById('receiptpriceShow').onchange()
			    
   </script>	  	    
  
</cfoutput>

