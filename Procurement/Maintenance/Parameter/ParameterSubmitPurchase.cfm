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
<cfparam name="Form.EnableExecutionRequest" default="0">
<cfparam name="Form.addToPurchaseFund" default="0">
<cfparam name="Form.PayrollOrderType" default="">

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET PurchasePrefix           = '#Form.PurchasePrefix#', 
		PurchaseSerialNo         = '#Form.PurchaseSerialNo#',
		TreeVendor               = '#Form.TreeVendor#',
		<cfif form.PayrollOrderClass neq "">
		PayrollOrderClass        = '#Form.PayrollOrderClass#',
		</cfif>
		<cfif form.payrollordertype neq "">
		PayrollOrderType         = '#Form.PayrollOrderType#',
		</cfif>
		PurchaseCustomField      = '#Form.PurchaseCustomField#',
		EnableExpressPurchase    = '#Form.EnableExpressPurchase#',
		PurchaseFromSingleJob    = '#Form.PurchaseFromSingleJob#',
		TaxExemption             = '#Form.TaxExemption#',
		AddToPurchaseMode        = '#Form.AddToPurchaseMode#',
		AddToPurchaseAlways      = '#Form.AddToPurchaseAlways#',
		AddToPurchaseFund        = '#Form.AddToPurchaseFund#',
		AddToPurchasePeriod      = '#Form.AddToPurchasePeriod#',
		EditPurchaseAfterIssue   = '#Form.EditPurchaseAfterIssue#',
		EnableExecutionRequest   = '#Form.EnableExecutionRequest#',
		EnablePurchaseClass      = '#Form.EnablePurchaseClass#',
		PurchaseLibrary          = '#Form.PurchaseLibrary#', 
		PurchaseTemplate         = '#Form.PurchaseTemplate#',
		PurchaseExceed           = '#Form.PurchaseExceed#',
		AddressTypeInvoice       = '#Form.AddressTypeInvoice#',
		AddressTypeShipping      = '#Form.AddressTypeShipping#',
		AddressTypeTransport     = '#Form.AddressTypeTransport#',
		OfficerUserId 	 		 = '#SESSION.ACC#',
		OfficerLastName  		 = '#SESSION.LAST#',
		OfficerFirstName 		 = '#SESSION.FIRST#',
		Created          		 =  getdate()						
	WHERE 	Mission              = '#url.Mission#'
</cfquery>

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_CustomFields
	SET PurchaseReference1 = '#Form.PurchaseReference1#',
	    PurchaseReference2 = '#Form.PurchaseReference2#',
		PurchaseReference3 = '#Form.PurchaseReference3#',
		PurchaseReference4 = '#Form.PurchaseReference4#'
</cfquery>

<cfinclude template="ParameterEditPurchase.cfm">
