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
