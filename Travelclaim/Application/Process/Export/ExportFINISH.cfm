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
<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE     stExportFileLine
	SET    ClaimantType = R.ClaimantType
	FROM   stExportFileLine L, 
	       ClaimRequest R
	WHERE  L.ExportNo = '#no#' 
	AND    L.ReqDocumentId = R.ClaimRequestId 
</cfquery>	

<!--- 1b. obligated line --->
<cfquery name="IndexNo" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    stExportFileLine
	SET      LineClaimantType = R.ClaimantType
	FROM     stExportFileLine L,
	         ClaimRequestLine R
	WHERE    L.ReqDocumentId = R.ClaimRequestId		
	AND      L.ReqDocumentNo = R.ClaimRequestLineNo		 
	AND      L.ExportNo = '#No#'
	AND      L.ClaimObligated = 1 
</cfquery>	

<!--- 1c. correction indexNo non-obligated line --->
<cfquery name="IndexNo" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    stExportFileLine
	SET      LineIndexNo      = P.IndexNo,
      	     LineClaimantType = R.ClaimantType
	FROM     stExportFileLine L,
	         ClaimRequest R,
			 stPerson P
	WHERE    L.ReqDocumentId = R.ClaimRequestId		 
	AND      P.PersonNo = R.PersonNo
	AND      L.ExportNo = '#No#'
	AND      L.ClaimObligated = 0
</cfquery>	
			
<!--- 2. update field values reimbursement mode --->
<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    stExportFileLine
	SET      ReferenceACPD = Ref_PaymentMode.ReferenceACPD, 
	         ReferencePYMD = Ref_PaymentMode.ReferencePYMD
	FROM     stExportFileLine INNER JOIN
	         Ref_PaymentMode ON stExportFileLine.PaymentMode = Ref_PaymentMode.Code
	WHERE    ExportNo = '#No#'
</cfquery>	

<!--- 3. update description/Itin --->
<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    stExportFileLine
SET       PaymentDescription = STR(Req.DocumentNo)+ ' ' + ITN.Itinerary,
	      ReqDocumentId      = Req.ClaimRequestId,
		  ReqDocumentNo      = Req.DocumentNo,
		  PointerClaimFinal  = C.PointerClaimFinal
FROM      stExportFileLine E INNER JOIN
          Claim C ON E.DocumentNo = C.DocumentNo INNER JOIN
          ClaimRequest Req ON C.ClaimRequestId = Req.ClaimRequestId INNER JOIN
          ClaimRequestItinerary ITN ON C.ClaimRequestId = ITN.ClaimRequestId
WHERE     C.ExportNo = '#no#' 
AND       ITN.Itinerary is not NULL
</cfquery>	

<!--- 4. update association --->
<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE     stExportFileLine
	SET    ReqLineNo = NULL
	WHERE  ClaimObligated = '0' 
	AND    ExportNo = '#no#' 
</cfquery>	

<!---
<cfquery name="Check" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   * 
FROM     stExportFileLine
WHERE    ExportNo = '#no#'
</cfquery>	
--->

<!--- 5. update bankinfo --->
<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    stExportFileLine
SET       BankCode = PA.BankCode, 
          BankAccountNo = PA.AccountNo
FROM      ClaimReimbursement C, 
          PersonAccount PA,
		  stExportFileLine st
WHERE     C.FieldValue = PA.AccountId 
AND       C.ClaimId = st.ClaimId
AND       C.FieldName IN (SELECT FieldName 
                          FROM Ref_ClusterField 
						  WHERE FieldLookup = 'PersonAccount')
</cfquery>	

<!--- 6. assign a unique serialNo per --->

<cfquery name="Duplicates" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   DocumentNo, PortalLineNo, COUNT(*) AS Expr1
FROM     stExportFileLine
WHERE    (ExportNo = '#no#')
GROUP BY DocumentNo, PortalLineNo
HAVING   (COUNT(*) > 1)
ORDER BY DocumentNo, PortalLineNo
</cfquery>	

<cfoutput query="Duplicates" group="DocumentNo">

	<cfoutput group="PortalLineNo">
	
	    <cfset serial = "0">
		
		<cfquery name="Line" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     stExportFileLine
			WHERE    ExportNo = '#no#'
			AND      PortalLineNo = '#PortalLineNo#'
		</cfquery>	
	
		<cfloop query="Line">
				
			<cfset serial = #serial#+1>
			
			<cfquery name="Update" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE   stExportFileLine
				SET    PortalLineAccountNo = '#serial#'
				WHERE  ExportNo = '#no#'
				AND    ExportSerialNo = '#ExportSerialNo#'
			</cfquery>	
		
		</cfloop>

	</cfoutput>

</cfoutput> 

<!--- 6. update totals --->
<cfquery name="sum" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    COUNT(*) AS Lines, 
          SUM(LineAccountAmount) AS Amounts
FROM      stExportFileLine
WHERE     ExportNo = '#no#' 
</cfquery>	

<cfset dt = #DateFormat(now(),"YYYYMMDD")#>

<cfquery name="UpdateReimbursement" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    stExportFile
	SET   SummaryLines = '#sum.Lines#', 
	      SummaryAmounts = '#sum.Amounts#', 
		  ExportFileId = '#URL.Mission#_#sum.Lines#_#dt#.dat' 
WHERE     ExportNo = '#no#' 			 
</cfquery>	
