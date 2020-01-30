 

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM RequisitionLineQuote Q, Organization.dbo.Organization O
	WHERE Q.OrgUnitVendor = O.OrgUnit
	AND  QuotationId = '#URL.ID#'
</cfquery>
  
['<cfoutput>#Line.OrgUnitName#</cfoutput>',null, 

<cfquery name="Quote" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, Q.QuotationId
    FROM RequisitionLine R, RequisitionLineQuote Q
	WHERE R.JobNo = Q.JobNo
	AND   R.RequisitionNo = Q.RequisitionNo
	AND   Q.OrgUnitVendor = '#Line.OrgUnitVendor#'
	AND   R.JobNo = '#Line.JobNo#' 
	AND R.ActionStatus != '9' 
</cfquery>

<cfoutput query="Quote">

['#RequestDescription#','QuotationEdit.cfm?Mode=#URL.Mode#&ID=#QuotationId#'], 

</cfoutput>
 
]


