
<!--- Identify if itemNo or quantity has changed --->

<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT S.*, T.CustomerId 
    FROM Shipping S, Item_Tra T, Request R
	WHERE S.TransactionNo = T.TransactionNo
    AND S.TransactionRecordNo = '#FORM.TransactionRecordNo#' 
</cfquery>

<cfif Get.ShippingItemNo neq #FORM.ShippingItemNo# 
  or   Get.TransactionQuantity neq #FORM.TransactionQuantity# 
  or   ParameterExists(Form.purge)>

<!--- if changed -- first reverse old transaction --->

<CF_RegisterAction 
SystemFunctionId="0415" 
ActionClass="Shipping Line" 
ActionType="Modify Quantity/Price" 
ActionReference="#Form.TransactionRecordNo#" 
ActionScript="">  

<!--- positive transaction --->

<cf_StockTransact 
                TransactionType="2"
				RequestId="#Get.RequestId#"
                Item="#Get.ShippingItemNo#" 
				ItemOrig="#Get.RequestItemNo#" 
                Warehouse="#Get.Warehouse#" 
				Location="#Get.Location#" 
				Quantity="#Get.TransactionQuantity#"
				Date="'#Get.TransactionDate#'"
				TransactionBatchNo=""
				TransactionNoReceipt=""
				TransactionNoReceiptCost=""
				Section="#Get.Customer#"
				OrgUnit="#Get.OrgUnit#"
				CustomerId="#Get.CustomerId#"
				Remarks="Shipping Modification"
				Reference="#Get.Reference#"
				Account=""
				Journal=""
				Reservation="No"
				Shipping="No"
				ShippingTrigger="">
				
		<cfif ParameterExists(Form.update)>		
		
		<!--- renewed shipping transaction --->
		
		<cf_StockTransact 
		                TransactionType="2"
						RequestId="#Form.RequestId#"
		                Item="#Form.ShippingItemNo#" 
						ItemOrig="#Get.RequestItemNo#" 
		                Warehouse="#Form.Warehouse#" 
						Location="#Form.Location#" 
						Quantity="#-FORM.TransactionQuantity#"
						Date="'#Get.TransactionDate#'"
						TransactionBatchNo=""
						TransactionNoReceipt=""
						TransactionNoReceiptCost=""
						Section="#Get.Customer#"
						OrgUnit="#Get.OrgUnit#"
						CustomerId="#Get.CustomerId#"
						Remarks="Shipping Modification"
						Reference="#Get.Reference#"
						Account=""
						Journal=""
						Reservation="No"
						Shipping="Yes"
						ShippingTrigger="#Get.TransactionRecordTrigger#">
						
		</cfif>						
				
		<!--- remove old shipping record --->
		
		<cfquery name="Revoke" 
		datasource="AppsMaterials" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		    DELETE FROM Shipping 
			WHERE TransactionRecordNo = '#FORM.TransactionRecordNo#' 
		</cfquery>		
		
		
<cfelse>

<!---
		<CF_RegisterAction 
		SystemFunctionId="0415" 
		ActionClass="Shipping Line" 
		ActionType="Resubmit" 
		ActionReference="#Form.TransactionRecordNo#" 
		ActionScript="">  
		
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Shipping
		SET 
		DeliveryReference = '#Form.DeliveryReference#'
		WHERE TransactionRecordNo  = #Form.TransactionRecordNo#
		</cfquery>
		
		--->

</cfif>

<script language="JavaScript">
 	 opener.history.go()
	 window.close()
</script>  

</body>
</html>
