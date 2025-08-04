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

<!--- update the price and also update the totam in the bottom --->

<cfif url.field eq "price">
	
	<cfset val = replaceNoCase(url.value,',','',"ALL")>
	
	<cfif not LSIsNumeric(val)>
	
			<script>
			    alert('Invalid price')
			</script>	 		
			<cfabort>
	
	<cfelse>
			
		<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    PurchaseLineReceipt
		  WHERE   ReceiptId = '#url.receiptid#'
		</cfquery>
		
		<cfif get.ReceiptAmountTax eq "0">
		
		   <cfset cost = val*get.ReceiptQuantity>
		   <cfset tax  = 0>
			
		<cfelse>
			
		   <cfif get.taxIncluded eq "0">
		   
		   	    <cfset cost = val*get.ReceiptQuantity>
	            <cfset tax  = val*get.ReceiptQuantity*GET.ReceiptTax>
			   
		   <cfelse>
		   
		        <cfset damt = val*get.ReceiptQuantity>			
			 	<cfset cost = damt*(1/(1+get.ReceiptTax))>
				<cfset tax  = damt*(get.ReceiptTax/(1+get.ReceiptTax))>
			 		   
		   </cfif>	
		 	
		</cfif>
		
		<cfquery name="set" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE PurchaseLineReceipt
		   SET    InvoicePrice       = '#val#', 
		          InvoiceAmountCost  = '#cost#',
				  InvoiceAmountTax   = '#tax#'	         
		   WHERE  ReceiptId          = '#url.receiptid#'
		</cfquery>
		
		<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    PurchaseLineReceipt
		  WHERE   ReceiptId = '#url.receiptid#'
		</cfquery>
						
		<cfoutput>		
		#NumberFormat(get.InvoiceAmount,",.__")#		
		</cfoutput>
		
	</cfif>	
		
<cfelse>		

	<cfset amt = replaceNoCase(url.value,',','',"ALL")>
	
	<cfif not LSIsNumeric(amt)>
	
			<script>
			    alert('Invalid amount')
			</script>	 		
			<cfabort>
	
	<cfelse>
	
		<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    PurchaseLineReceipt
		  WHERE   ReceiptId = '#url.receiptid#'
		</cfquery>
		
		<cfif get.ReceiptAmountTax eq "0">
		
		   <cfset prc  = amt/get.ReceiptQuantity>
		   <cfset cst  = amt>
		   <cfset tax  = 0>
			
		<cfelse>
			
		   <cfif get.taxIncluded eq "0">
		   
		   	    <cfset prc  = amt/get.ReceiptQuantity>
				<cfset cst  = amt>
	            <cfset tax  = amt*GET.ReceiptTax>
			   
		   <cfelse>
		   
		        <cfset prc  = amt/get.ReceiptQuantity>			
			 	<cfset cst  = amt*(1/(1+get.ReceiptTax))>
				<cfset tax  = amt - cst>
			 		   
		   </cfif>	
		 	
		</cfif>
		
		<cfquery name="set" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   UPDATE  PurchaseLineReceipt
		   SET     InvoicePrice       = '#prc#',
		           InvoiceAmountCost  = '#cst#',
				   InvoiceAmountTax   = '#tax#'	         
		   WHERE   ReceiptId          = '#url.receiptid#'
		</cfquery>
		
		<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT  * 
		   FROM    PurchaseLineReceipt
		   WHERE   ReceiptId = '#url.receiptid#'
		</cfquery>
		
		<cfoutput>
		#NumberFormat(get.InvoicePrice,",.__")#
		</cfoutput>

	</cfif>
	
</cfif>	

<script>
	 total()
</script>

