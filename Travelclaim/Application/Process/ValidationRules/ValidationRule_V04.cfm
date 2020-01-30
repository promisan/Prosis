
<!--- 
Validation Rule :  V04
Name			:  Pending Advances
Steps			:  Determine if some advances are pending
Date			:  02 January 2008 : revised 11/04/2008 Hanno)
--->

<cfquery name="Check" 
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
	SELECT DISTINCT A.*, R.Description as StatusDescription, R.PointerStatus
	FROM   IMP_ClaimAdvance A, Ref_Status R
	WHERE  Doc_No          = '#ClaimRequest.DocumentNo#'
	AND    db_mdst_source  = '#ClaimRequest.Mission#'
	AND    A.AdvanceStatus = R.Status
	AND    R.StatusClass   = 'Advance'
	AND    (A.cnvrt_bal > 0 or A.AdvanceMode = '4')
	AND    R.PointerStatus = 0
	AND    (A.Requester is NULL or A.Requester != A.db_mdst_source) <!--- added 11/4/2008 for Terry --->
</cfquery>
 
<cfif Check.recordcount gte 1>		 

 <cf_ValidationInsert
   	ClaimId        = "#URL.ClaimId#"
	ClaimLineNo    = ""
	CalculationId  = "#rowguid#"
	ValidationCode = "#code#"
	ValidationMemo = "#Description#"
	Mission        = "#ClaimRequest.Mission#">
	
</cfif>	

