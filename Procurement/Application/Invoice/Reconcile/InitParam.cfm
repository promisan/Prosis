<cfparam name="URL.invoice" default="0">
<cfparam name="URL.extern" default="0">
<cfparam name="URL.VendorCode" default="0">
<cfparam name="URL.VendorCode2" default="0">
<cfparam name="URL.VendorCode3" default="0">

<cftransaction>
	<cfquery name="Default" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Invoice
		SET    ReconciliationNo=NULL
		WHERE  ReconciliationNo in (
						SELECT ReconciliationNo
						FROM   stReconciliation
						WHERE  Status='Partial')
	</cfquery>
	
	<cfquery name="Default" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE  stReconciliationIMIS
	WHERE  ReconciliationNo IN (
						SELECT ReconciliationNo
						FROM   stReconciliation
						WHERE  Status='Partial')
	</cfquery>

	<cfquery name="Default" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE  stReconciliation
	WHERE   Status='Partial'
	</cfquery>
	
</cftransaction>

<cfif URL.VendorCode eq "0">

	<cfquery name="Default" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   top 1 VendorCode,VendorName 
		FROM     stLedgerIMIS I 
		WHERE    NOVADestination = 'Match'
		 AND     TransactionSerialNo NOT IN (
		  
		                SELECT   RI.TransactionSerialNo
						FROM     stReconciliationIMIS RI INNER JOIN
				                 stReconciliation R ON RI.ReconciliationNo = R.ReconciliationNo 
						         AND R.Status = 'Complete' 
						)
	
		AND      TransactionSerialNo NOT IN (#URL.extern#)
		AND      Mission = '#url.mission#' 
		AND      VendorCode is not null
		ORDER BY VendorName 
	</cfquery>

	<cfset URL.VendorCode = Default.VendorCode>
	
</cfif>

<cfif URL.VendorCode2 eq "0">

	<cfquery name="Default2" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
			SELECT TOP 1 O.OrgUnit, OrgUnitName
			FROM   Invoice I, 
			       Organization.dbo.Organization O
			WHERE  InvoiceId not in
                          ( SELECT     InvoiceId
                            FROM       Invoice I INNER JOIN
                                       stReconciliation R ON I.ReconciliationNo = R.reconciliationNo
                            WHERE      I.mission = '#URL.mission#' 
							AND        I.ActionStatus <> '9' 
							AND        R.status = 'Complete')
			AND  InvoiceId IN (
						SELECT IP.InvoiceId
						FROM   PurchaseLine PL INNER JOIN
		                       RequisitionLine RL ON PL.RequisitionNo = RL.RequisitionNo INNER JOIN
		                       InvoicePurchase IP ON PL.RequisitionNo = IP.RequisitionNo 
						WHERE  RL.Mission = '#url.mission#' 
						AND    RL.ActionStatus <> '9'
						)			
			AND      I.OrgUnitVendor = O.OrgUnit
			AND      I.TransactionNo NOT IN ('#URL.Invoice#')
			AND      I.ActionStatus<>'9' 
			AND      O.OrgUnit IS NOT null
			ORDER BY OrgUnitName
	</cfquery>

	<cfset URL.VendorCode2 = Default2.OrgUnit>	

</cfif>
