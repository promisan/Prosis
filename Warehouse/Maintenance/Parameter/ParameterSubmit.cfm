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
<cf_preventCache>

<cfparam name="Form.UnitConfirmation" default="0">
<cfparam name="Form.TaxManagement" default="1">
<cfparam name="Form.PriceManagement" default="1">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.RevaluationCutoff#">
<cfset DTE = dateValue>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ParameterMission
		SET Receiptorgunit           = '#Form.Orgunit#',
		    <cfif form.location neq "">
		    	ReceiptLocation          = '#Form.Location#', 
			</cfif>
			OperationMode            = '#Form.OperationMode#',
			DisableDoubleRequest     = '#Form.DisableDoubleRequest#',
			LastYearDepreciation     = '#Form.LastYearDepreciation#',
			RequisitionTemplate      = '#Form.RequisitionTemplate#',
			PortalInterfaceMode      = '#Form.PortalInterfaceMode#',
			PickticketTemplate       = '#Form.PickTicketTemplate#',
			EnableQuantityChange     = '#Form.EnableQuantityChange#',
			RequestPrefix            = '#Form.RequestPrefix#',
			RequestSerialNo          = '#Form.RequestSerialNo#',
			LotManagement            = '#Form.LotManagement#',
			TaxManagement            = '#Form.TaxManagement#',
			PriceManagement          = '#Form.PriceManagement#',
			RevaluationCutoff        = #dte#,			
			<cfif form.ReceiptDevice eq "">
			ReceiptDevice            = NULL,
			<cfelse>
			ReceiptDevice            = '#Form.ReceiptDevice#',
			</cfif>
			DistributionPrefix       = '#Form.DistributionPrefix#',
			DistributionSerialNo     = '#Form.DistributionSerialNo#',
			TaskorderPrefix          = '#Form.TaskorderPrefix#',
			TaskOrderSerialNo        = '#Form.TaskOrderSerialNo#',
			ForwardBackOrder         = '#Form.ForwardBackorder#',
			RequestEnablePrice       = '#Form.RequestEnablePrice#',
			UnitConfirmation         = '#Form.UnitConfirmation#',
			FundingOrderType         = '#Form.FundingOrderType#',
			TreeCustomer             = '#Form.TreeCustomer#',
			OfficerUserId 	 		 = '#SESSION.ACC#',
			OfficerLastName  		 = '#SESSION.LAST#',
			OfficerFirstName 		 = '#SESSION.FIRST#',
			Created          		 =  getdate()			
WHERE Mission = '#url.mission#'	
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
 action="Update"
 content="#form#">	

<cfoutput>
	<script>
		alert("Parameters were saved.")
		window.location = "ParameterEdit.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#"
	</script>
</cfoutput>
