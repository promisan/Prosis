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

<cfparam name="url.receiptno" default="">

<cfif URL.Mode eq "Entry">
  <cfset tbl = "stPurchaseLineReceipt">
<cfelse>
  <cfset tbl = "PurchaseLineReceipt">
</cfif>  

<cfquery name="Check" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   #tbl#
		 WHERE  ReceiptId = '#URL.rctid#' 
</cfquery>

<cfif Check.actionStatus eq "1" or Check.actionStatus eq "0">
	
    <!--- check if receipt exists in  Materials 
	     trigger will remove asset  + GL --->
	
	<!---
	<cftry>
	--->
	
	<cftransaction>
		 
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   Materials.dbo.ItemTransaction
			 WHERE  ReceiptId = '#URL.rctid#'
			 UNION
			 SELECT * 
			 FROM   Materials.dbo.ItemTransaction
			 WHERE  TransactionBatchNo IN (SELECT BatchNo
			                               FROM   Materials.dbo.WarehouseBatch 
										   WHERE  BatchId = '#URL.rctid#') 
	</cfquery>
	
	
	
	<cfloop query="Lines">
					
		<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     DELETE 
			 FROM   Materials.dbo.ItemTransaction
			 WHERE  TransactionId = '#TransactionId#' 
		</cfquery>
					
	</cfloop>
			
	<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     UPDATE #tbl#
			 SET    ActionStatus = '9'
			 WHERE  ReceiptId = '#URL.rctid#'
	</cfquery>
	
	<!--- define purchase delivery status --->
	
		<cfquery name="PurchaseLine" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   PurchaseLine
			 WHERE  RequisitionNo = '#Check.RequisitionNo#'
		</cfquery>
			
		<cfquery name="Line" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT SUM(ReceiptQuantity) as ReceiptQuantity
			 FROM   PurchaseLineReceipt
			 WHERE  RequisitionNo = '#Check.RequisitionNo#'
			 AND    ActionStatus != '9'
		</cfquery>
		
		<cfif Line.receiptQuantity eq "">
		
		      <cfset st = "0">
				
		<cfelseif Line.receiptQuantity gte PurchaseLine.OrderQuantity>
				
			  <cfset st = "3">
				
		<cfelse>
			
			  <cfset st = "2"> <!--- partial --->
								
		</cfif>
				
		<cfquery name="Line" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE PurchaseLine
			 SET    DeliveryStatus = '#st#'
			 WHERE  RequisitionNo = '#Check.RequisitionNo#' 
		</cfquery>
		
		<cfquery name="Get" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
				 FROM   #tbl#
				 WHERE  ReceiptId = '#URL.rctid#'
		</cfquery>		
		
		<cfset url.taskid = get.warehousetaskid>
		
	</cftransaction>
		
	<cfif url.receiptno eq "">
		<cfinclude template="ReceiptDetail.cfm">
	</cfif>
	
	<!---
				
	<cfcatch>
	
	    <script>
			alert("Transaction can no longer be removed")
		</script>	
		
		<cfif url.receiptno eq "">	
			<cfinclude template="ReceiptDetail.cfm">
		</cfif>
			
	</cfcatch>
		
	</cftry>
	
	--->
				
<cfelse>

     <!--- check if receipt transaction exists in  Materials 
	     and remove transaction + GL (trigger) --->
		 
	<cftransaction>	 
		
		<cfquery name="Delete" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE FROM Materials.dbo.ItemTransaction
				 WHERE ReceiptId = '#URL.rctid#'
		</cfquery>
		
		<cfquery name="Get" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT * FROM #tbl#
				 WHERE ReceiptId = '#URL.rctid#'
		</cfquery>
	
		<cfquery name="Delete" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE FROM #tbl#
				 WHERE ReceiptId = '#URL.rctid#'
		</cfquery>
			
		<cfif url.receiptno eq "">			
		    <cfset url.taskid = get.warehousetaskid>
		    <cfinclude template="ReceiptDetail.cfm">
		</cfif>
			
	</cftransaction>

</cfif>

