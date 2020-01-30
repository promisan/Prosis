
<!--- Advance Purchase Order --->

<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		SELECT * FROM Ref_ParameterMission
		WHERE   Mission = '#url.mission#' 
	</cfquery>

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no"> 
	
<cf_ListingScript>
<cf_dialogProcurement>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Advance">	
	
<cfquery name="Lines" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   H.Journal,
		         H.JournalSerialNo,
				 H.JournalTransactionNo, 				 
		         H.Description, 
				 H.ReferenceNo as PurchaseNo, 
				 H.TransactionId,
				 H.TransactionDate, 
				 TL.Currency, 
				 TL.AmountDebit, 
				 TL.AmountCredit, 
				 
				      (SELECT  SUM(AmountCredit * ExchangeRate) 
                       FROM    TransactionLine
                       WHERE   ReferenceNo = H.ReferenceNo 
					   AND     Reference = 'Advance'
					   AND     ParentJournal IS NOT NULL 
					   AND     ParentJournalSerialNo IS NOT NULL
					   AND     GLAccount = '#Parameter.AdvanceGLAccount#') AS Offset, 

				 TL.GLAccount,
				 H.ReferenceName, 
				 O.OrgUnitName, 				 
				 H.ActionStatus,
				 H.OfficerFirstName,
				 H.OfficerLastName
		INTO     userQuery.dbo.#SESSION.acc#_Advance			 
		FROM         TransactionHeader AS H INNER JOIN
                      TransactionLine AS TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo INNER JOIN
                      Purchase.dbo.Purchase AS P ON H.ReferenceNo = P.PurchaseNo INNER JOIN
                      Organization.dbo.Organization AS O ON P.OrgUnitVendor = O.OrgUnit

		WHERE    H.Reference            = 'Advance' 			
		AND      TL.TransactionSerialNo != '0'
		AND      H.Mission = '#url.Mission#'
		AND      TL.Currency = '#URL.Currency#'
		ORDER BY H.TransactionDate
</cfquery>

<cfinclude template="ListingVendorContent.cfm">