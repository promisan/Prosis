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
<cfset condition = "">
	
<cfif url.period neq "" and url.id1 neq "locate">	
     <cfset condition = "R.Period = '#URL.Period#' and R.Mission = '#URL.Mission#'">
<cfelse>
     <cfset condition = "R.Mission = '#URL.Mission#'"> 
</cfif>
<cfset text = "Inquiry">

<cfif Form.PackingSlipNo neq "">
      <cfset condition   = "#condition# AND R.PackingSlipNo LIKE '%#PackingSlipNo#%'">
</cfif>

<cfif Form.ReceiptNo neq "">
      <cfset condition   = "#condition# AND R.ReceiptNo LIKE '%#ReceiptNo#%'">
</cfif>

<cfif Form.OrderType neq "">
      <cfset condition   = "#condition# AND P.OrderType = '#Form.OrderType#'">
</cfif>
 
<cfif Form.OrderType neq "">
      <cfset condition   = "#condition# AND P.OrderType = '#Form.OrderType#'">
</cfif>
 
<cfif Form.OrderClass neq "">
      <cfset condition   = "#condition# AND P.OrderClass = '#Form.OrderClass#'">
</cfif>
 
<cfif Form.OrgUnitVendor neq "">
      <cfset condition   = "#condition# AND P.OrgUnitVendor = '#Form.OrgUnitVendor#'">
</cfif>

<cfif Form.ReceiptItem neq "" and form.actionstatus eq "1">
       <cfset condition  = "#condition# AND L.ReceiptItem LIKE  '%#Form.ReceiptItem#%'">	   
</cfif>	
 
<cfif Form.DateStart neq "">
     <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateStart#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND R.ReceiptDate >= #dte#">
</cfif>	
 
<cfif Form.DateEnd neq "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.DateEnd#">
	 <cfset dte = dateValue>
	 <cfset condition = "#condition# AND R.ReceiptDate <= #dte#">
</cfif>	

		
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Receipt">		

<cfif form.actionstatus eq "1">

	<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   R.ReceiptNo,
		         R.Mission,
	    	     R.Period,
		         R.PackingslipNo,
		    	 R.EntityClass,
	    	     L.RequisitionNo,
		      	 R.WarehousetaskId,			 
	    	  	 R.ReceiptReference1,
		      	 R.ReceiptReference2,
		      	 R.ReceiptReference3,
		      	 R.ReceiptReference4,
		      	 R.ReceiptDate,
		      	 R.ReceiptRemarks,
		      	 R.ActionStatus,
		      	 R.AttachmentId,
		      	 R.OfficerUserId,
		      	 R.OfficerLastName,
		      	 R.OfficerFirstName,
	    	  	 R.Created,
				 (SELECT COUNT(*)               FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as Lines,				 
				 (SELECT SUM(ReceiptAmountBase) FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as AmountBase, 
				 (SELECT MIN(ActionStatus) FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as ReceiptStatus, 			 	
				 (SELECT TOP 1 Warehouse FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as Warehouse,
	    	     L.ReceiptId
				 
		INTO     userQuery.dbo.#SESSION.acc#Receipt
		
		FROM     Receipt R INNER JOIN 
		         PurchaseLineReceipt L ON R.ReceiptNo = L.ReceiptNo INNER JOIN
		         PurchaseLine PL ON L.RequisitionNo = PL.RequisitionNo INNER JOIN
		         Purchase P ON PL.PurchaseNo = P.PurchaseNo
		WHERE 	 #preserveSingleQuotes(condition)#  
		AND      R.ActionStatus != '9'
				 
		ORDER BY R.ReceiptNo				
		
	</cfquery>
	
<cfelse>
	
	<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT R.ReceiptNo,
		       R.Mission,
	    	   R.Period,
		       R.PackingslipNo,
	    	   R.EntityClass,
		       PL.RequisitionNo,		   
	    	   R.WarehousetaskId,
		       R.ReceiptReference1,
	      	   R.ReceiptReference2,
	      	   R.ReceiptReference3,
	      	   R.ReceiptReference4,
	      	   R.ReceiptDate,
	      	   R.ReceiptRemarks,
	      	   R.ActionStatus,
	      	   R.AttachmentId,
	      	   R.OfficerUserId,
	      	   R.OfficerLastName,
	      	   R.OfficerFirstName,
	      	   R.Created,
			   (SELECT count(*) FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as Lines,
			   (SELECT SUM(ReceiptAmountBase) FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as AmountBase, 
			   (SELECT MIN(ActionStatus) FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as ReceiptStatus, 
			 			
			   (SELECT TOP 1 Warehouse FROM PurchaseLineReceipt WHERE ReceiptNo = R.ReceiptNo AND ActionStatus != '9') as Warehouse
				 
		INTO   userQuery.dbo.#SESSION.acc#Receipt
		
		FROM   Receipt R INNER JOIN 
		       PurchaseLine PL ON R.RequisitionNo = PL.RequisitionNo INNER JOIN
		       Purchase P ON PL.PurchaseNo = P.PurchaseNo
		WHERE  #preserveSingleQuotes(condition)#  
		AND    R.ActionStatus = '9'
				 
		ORDER BY R.ReceiptNo		
	</cfquery>

</cfif>

<cfinclude template="ReceiptViewListing.cfm">

<script>
	Prosis.busy('no')
</script>
