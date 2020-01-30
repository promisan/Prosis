<cfset vInit = GetTickCount()>


<!---- action -- --->
<cfquery name="Action" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT *
    FROM DocumentAction VA, DocumentFlow A
    WHERE VA.DocumentNo = '#vDocumentNo#'
	AND  VA.ActionId  = A.ActionId
	AND  VA.DocumentNo = A.DocumentNo
    ORDER BY VA.ActionOrder, A.ActionOrderSub
</cfquery>
	
<!---
-- actioncurrent --
-- get earliest pending document-level action for this request
--->
<cfquery name="ActionCurrent" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DISTINCT V.DocumentNo, MIN(ActionOrder) as ActionOrder
    FROM DocumentAction V
    WHERE V.ActionStatus = '0' 
    AND  V.DocumentNo = '#vDocumentNo#'
    GROUP BY V.DocumentNo
</cfquery>

	
<!-- -- actioncurrent first--
-- get earliest pending document-level sub-action for this request
--->
<cfquery name="ActionCurrentFirst" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DISTINCT V.DocumentNo, MIN(ActionOrderSub) as ActionOrderSub
    FROM DocumentAction V
    WHERE V.ActionStatus = '0' 
    AND  V.DocumentNo = '#vDocumentNo#'
    GROUP BY V.DocumentNo
</cfquery>
	
	
	<cfsilent>
		<cf_logpoint fileName="DocumentEdit.txt">
			<cfoutput>
			***********************************************************************************************************************
			1: Query time elapsed: #GetTickCount() - vInit# milisecs
			</cfoutput>
		</cf_logpoint>
	</cfsilent>
		
	
<!---	
-- actioncandidatecurrent --
-- retrieve last completed action for each 'non-revoked' candidate in this request
-- 25Apr04 - added 'P.IndexNo' and 'VC.Status' in SELECT, 'Person' in FROM and GROUP BY, 
--           and 'VC.PersonNo *= P.PersonNo' in WHERE
-- 040830 mm - added VC.PlannedDeployment and SatPassInd in SELECT and GROUP BY clauses --
-- 041005 mm - added MedicalPassInd and MedicalFailInd in SELECT and GROUP BY clauses --
--->
<cfquery name="ActionCandidateCurrent" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DISTINCT VC.DocumentNo, VC.PersonNo, P.IndexNo, VC.LastName, VC.FirstName, VC.PostNumber, VC.Status, S.IndexNo as StfIndexNo, VC.PlannedDeployment, 
     CASE WHEN st.PersonNo IS NULL THEN 0 ELSE 1 END AS SatPassInd,
     CASE WHEN ip.PersonNo IS NULL THEN 0 ELSE 1 END AS IncidentInd,
     CASE WHEN mc.PersonNo IS NULL THEN 0 ELSE 1 END AS MedicalPassInd,
     CASE WHEN mf.PersonNo IS NULL THEN 0 ELSE 1 END AS MedicalFailInd,
     MAX(VA.ActionOrderSub) as ActionOrderSub       
FROM DocumentCandidate VC INNER JOIN 
     DocumentCandidateAction VA ON (VC.DocumentNo = VA.DocumentNo AND VC.PersonNo = VA.PersonNo) LEFT OUTER JOIN
     Sat st ON VC.PersonNo = st.PersonNo LEFT OUTER JOIN
     IncidentPerson ip ON VC.PersonNo = ip.PersonNo LEFT OUTER JOIN
     vwMedicallyClearedPerson mc ON VC.PersonNo = mc.PersonNo LEFT OUTER JOIN
     vwMedicallyFailedPerson mf ON VC.PersonNo = mf.PersonNo LEFT OUTER JOIN
     EMPLOYEE.DBO.Person P ON VC.PersonNo = P.PersonNo LEFT OUTER JOIN
     Employee.DBO.Staff S ON P.IndexNo = S.IndexNo
WHERE VC.DocumentNo = '#vDocumentNo#'
AND  VA.ActionStatus IN ('1' ,'5')
AND  (VC.Status <> '9' AND VC.Status <> '6')
--    AND   S.IndexNo IS NOT NULL  *** dont add this line, else only actual matches get retrieved!! ***
GROUP BY VC.DocumentNo, VC.PersonNo, P.IndexNo, VC.LastName, VC.FirstName, VC.PostNumber, 
         VC.Status, S.IndexNo, VC.PlannedDeployment, st.PersonNo, ip.PersonNo, mc.PersonNo, mf.PersonNo
</cfquery>		 

	<cfsilent>
		<cf_logpoint mode="append" fileName="DocumentEdit.txt">
			<cfoutput>
			***********************************************************************************************************************
			2: Query time elapsed: #GetTickCount() - vInit# milisecs
			</cfoutput>
		</cf_logpoint>
	</cfsilent>


<!---
-- actioncandidatelast --
-- get latest completed workflow action for this request (regardless of candidate)
--->
<cfquery name="ActionCandidateLast" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT MAX(ActionOrderSub) as ActionOrderSub
    FROM DocumentCandidateAction VA
    WHERE VA.DocumentNo = '#vDocumentNo#'
    AND  VA.ActionStatus >= '1'
</cfquery>	



