
<cf_preventCache>

<cfparam name="Form.UnitConfirmation" default="0">
<cfparam name="Form.TaxManagement" default="1">

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
