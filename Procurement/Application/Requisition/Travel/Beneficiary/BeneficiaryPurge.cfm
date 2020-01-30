<cfquery name="validate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE
	    FROM 	RequisitionLineBeneficiary 
		WHERE 	BeneficiaryId = '#url.beneficiaryid#'
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine 
	WHERE RequisitionNo = '#URL.requisitionno#'
</cfquery>

<cfoutput>
	<script>
		ColdFusion.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/beneficiarylisting.cfm?requisitionno=#url.requisitionno#&mission=#line.mission#&access=#url.access#', 'divBeneficiary');
	</script>
</cfoutput>