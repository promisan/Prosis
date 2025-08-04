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


<cf_PreventCache>

<cfquery name="Listing" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * 
FROM Shipping
WHERE TransactionRecordNo  IN (#PreserveSingleQuotes(Form.Selected)#)
ORDER BY OrgUnit
</cfquery>

<cfif ParameterExists(Form.Packing)>

<CF_RegisterAction 
SystemFunctionId="0415" 
ActionClass="Batch" 
ActionType="Create Packingslip" 
ActionReference="Process" 
ActionScript="">   

<cfset shipNos = ""> 

<cfoutput query="Listing" group="OrgUnit">

<!--- create a batch --->

 <cfquery name="Set" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE dbo.Paramete 
    SET BatchNoShipping = (BatchNoShipping + 1.0)
 </cfquery>

 <cfquery name="Get" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *  xxxxxxx
   FROM Paramete 
 </cfquery>
 
 <cfset BatNo = #Get.BatchNoShipping#>
  
	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ShippingBatch
	         (TransactionBatchNo,
			 Warehouse,
			 TransactionDate,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Status,	
			 Created)
	VALUES   ('#batNo#',
	          '#Listing.Warehouse#', 
	          '#DateFormat(Now(),CLIENT.DateSQL)#',
	          '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '0',
			  getDate())
	</cfquery>

<!--- loop the requistions to be processed --->

<cfoutput>

	<cfquery name="Shipping" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Shipping
	SET 
	Status              = '1',
	ShippingNo          = '#BatNo#',
	ShippingDate        = '#DateFormat(Now(),CLIENT.DateSQL)#' 
	WHERE TransactionRecordNo  IN (#PreserveSingleQuotes(Form.Selected)#)
	</cfquery>

</cfoutput>

   <cfset URL.ID = #BatNo#>
   <!--- dependent on the customer you can also send an eMail --->
   
   <cfinclude template="PackingslipPDF.cfm">

</cfoutput>

</cfif>

<cfif ParameterExists(Form.Return)>

<cfoutput query="Listing" group="OrgUnit">

     <cf_StockTransact 
                TransactionType="2"
				RequestId="#RequestId#"
                Item="#ShippingItemNo#" 
				ItemOrig="#RequestItemNo#" 
                Warehouse="#Warehouse#" 
				Location="#Location#" 
				Quantity="#TransactionQuantity#"
				Date="'#DeliveryDate#'"
				TransactionBatchNo=""
				TransactionNoReceipt=""
				TransactionNoReceiptCost=""
				Section="#Section#"
				OrgUnit="#OrgUnit#"
				CustomerId="#CustomerId#"
				Remarks="Return"
				Reference="#Reference#"
				Account=""
				Journal=""
				Reservation="No"
				Shipping="No"
				ShippingTrigger="">
						
				<!--- remove old shipping record --->
				
				<cfquery name="Revoke" 
				datasource="AppsMaterials" 
				username=#SESSION.login# 
				password=#SESSION.dbpw#>
				    DELETE FROM Shipping 
					WHERE TransactionRecordNo = '#TransactionRecordNo#' 
				</cfquery>		
 
</cfoutput>        

</cfif>

<!---
<cfelse>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DeliveryDate#">
<cfset dte = #dateValue#>

<CF_RegisterAction 
SystemFunctionId="0415" 
ActionClass="Batch" 
ActionType="Confirm receipt" 
ActionReference="Process" 
ActionScript="">   

<cfquery name="Shipping" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Shipping
SET 
Status              = '2',
DeliveryDate        = #dte#,
DeliveredIndexNo    = '#FORM.IndexNo#',
DeliveredLastName   = '#FORM.LastName#',
DeliveredFirstName  = '#FORM.FirstName#',
DeliveryReference   = '#FORM.DeliveryReference#'
WHERE TransactionRecordNo  IN (#PreserveSingleQuotes(Form.Selected)#)
</cfquery>

</cfif>

--->

<cfoutput>
<script language="JavaScript">
    window.location = "ShippingListing.cfm?IDWarehouse=#Listing.Warehouse#" <!--- &Pick=#Batch.Warehouse#_#Batch.TransactionBatchNo#_.pdf" --->
</script>
</cfoutput>

