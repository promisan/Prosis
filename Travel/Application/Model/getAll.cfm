<cfparam name="URL.USERID" default="">
<cfparam name="#URL.STATUS#" default="">
<cfparam name="#URL.SORT#" default="">
<cfparam name="#URL.MISSION#" default="">
<cfparam name="#URL.PERMMISSION#" default="">
<cfparam name="#URL.CLASS#" default="">
<cfparam name="#URL.TUSTAFF#" default="">
<cfparam name="#URL.AREA#" default="">
<cfparam name="#URL.iLASTNAME#" default="">
<cfparam name="#URL.oLASTNAME#" default="">
<cfparam name="#URL.DOCNO#" default="">
<cfparam name="#URL.DOCNO1#" default="">

<cfquery name="tmp0" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DISTINCT DA.DocumentNo, MIN(DA.ActionOrder) as TmpActionOrd 
INTO Userquery.dbo._#SESSION.acc#_tmp0
FROM DocumentAction DA, Document D
WHERE DA.DocumentNo = D.DocumentNo
  AND DA.DocumentNo >= '#URL.DOCNO#'
  AND DA.DocumentNo <= '#URL.DOCNO1#'
AND (DA.ActionStatus = '0' OR D.Status > '0')
AND D.Status!='9'
GROUP BY DA.DocumentNo 
ORDER BY DA.DocumentNo
</cfquery>

<cfquery name="tmp2" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DISTINCT DCA.DocumentNo, MAX(DCA.ActionOrder) as TmpActionOrd
INTO Userquery.dbo._#SESSION.acc#_tmp2
FROM DocumentCandidateAction DCA, Document D
WHERE DCA.DocumentNo = D.DocumentNo
  AND DCA.DocumentNo >= '#URL.DOCNO#'
  AND DCA.DocumentNo <= '#URL.DOCNO1#'
  AND DCA.ActionStatus IN ('1','7','8')
  AND DCA.PersonNo NOT IN ( SELECT DC.PersonNo FROM DocumentCandidate DC 
                            WHERE  DC.PersonNo = DCA.PersonNo
                            AND    DC.Status IN ('6','9')
			    AND    DC.DocumentNo = DCA.DocumentNo )
  AND D.Status!='9'
GROUP BY DCA.DocumentNo, DCA.PersonNo
</cfquery>

<cfquery name="tmp0" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
INSERT INTO Userquery.dbo._#SESSION.acc#_tmp0 ( DocumentNo, TmpActionOrd )
SELECT T2.DocumentNo, Min(T2.TmpActionOrd)
FROM Userquery.dbo._#SESSION.acc#_tmp2 T2
GROUP BY T2.DocumentNo
</cfquery>

<cfquery name="tmp0" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
INSERT INTO Userquery.dbo._#SESSION.acc#_tmp0 ( DocumentNo, TmpActionOrd )
SELECT DISTINCT DCA.DocumentNo, MIN(DCA.ActionOrder)
FROM Document D, DocumentCandidateAction DCA
WHERE D.DocumentNo = DCA.DocumentNo 
  AND D.DocumentNo NOT IN (SELECT DocumentNo FROM #tmplist2 WHERE DocumentNo = D.DocumentNo)
  AND D.DocumentNo >= '#URL.DOCNO#'
  AND D.DocumentNo <= '#URL.DOCNO1#'
  AND D.Status!='9'
GROUP BY DCA.DocumentNo
</cfquery>

<cfquery name="tmp1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT DocumentNo, MIN(TmpActionOrd) as TmpActionOrder 
INTO Userquery.dbo._#SESSION.acc#_tmp1
FROM Userquery.dbo._#SESSION.acc#_tmp0
WHERE DocumentNo >= '#URL.DOCNO#'
  AND DocumentNo <= '#URL.DOCNO1#'
GROUP BY DocumentNo 
ORDER BY DocumentNo
</cfquery>

<cfquery name="tmp1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT AA.Mission, RC.Category INTO Userquery.dbo._#SESSION.acc#_tmp3
FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
WHERE AA.ActionId = FA.ActionID
AND   FA.ActionClass = RT.TravellerTypeCode
AND   RT.TravellerType = RC.TravellerType
AND   AA.AccessLevel <> '9'
AND   AA.UserAccount = '#URL.USERID#'
GROUP BY AA.Mission, RC.Category
</cfquery>



<cfif URL.iLASTNAME neq "" AND URL.oLASTNAME neq "">

	<cfquery name="tmp4a" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		CREATE TABLE Userquery.dbo._#SESSION.acc#_tmp4a (DocumentNo Int, ActionOrder int)
	</cfquery>	

	<cfquery name="tmp4a" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	   INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4a (DocumentNo, ActionOrder)
	   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
	   FROM Userquery.dbo._#SESSION.acc#_tmp1 T1, Document D, #tmplist3 T3, DocumentCandidate DC
	   WHERE T1.DocumentNo = D.DocumentNo
	   AND   D.DocumentNo = DC.DocumentNo
	   AND   D.PersonCategory = T3.Category
	   AND   DC.LastName LIKE '#URL.iLASTNAME#'
	   AND  (DC.Status = '0' OR DC.Status = '3')
	   AND D.Status!='9'
	   GROUP BY T1.DocumentNo
	 </cfquery>
	   
</cfif> 


<cfif URL.iLASTNAME neq "" AND URL.oLASTNAME neq "">
	<cfquery name="tmp4b" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		CREATE TABLE Userquery.dbo._#SESSION.acc#_tmp4b (DocumentNo Int, ActionOrder int)
	</cfquery>	
	
	<cfquery name="tmp4a" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	   INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4b (DocumentNo, ActionOrder)
	   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder 
	   FROM Userquery.dbo._#SESSION.acc#_tmp1 T1, Document D, #tmplist3 T3, DocumentRotatingPerson DRP, EMPLOYEE.DBO.Person P
	   WHERE T1.DocumentNo = D.DocumentNo
	   AND   D.PersonCategory = T3.Category
	   AND   D.DocumentNo = DRP.DocumentNo
	   AND   DRP.PersonNo = P.PersonNo
	   AND   P.LastName LIKE '#URL.oLASTNAME#'
	   AND D.Status!='9'
	   GROUP BY T1.DocumentNo
	 </cfquery>  
</cfif>

<cfif URL.iLASTNAME neq "" AND URL.oLASTNAME neq "">
	<cfquery name="tmp4c" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		CREATE TABLE Userquery.dbo._#SESSION.acc#_tmp4c (DocumentNo Int, ActionOrder int)
	</cfquery>

	<cfquery name="tmp4c" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	   INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4c (DocumentNo, ActionOrder)
	   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
	   FROM Userquery.dbo._#SESSION.acc#_tmp1 T1, Document D, #tmplist3 T3, DocumentCandidate DC,
	        DocumentRotatingPerson DRP, EMPLOYEE.DBO.Person P
	   WHERE T1.DocumentNo = D.DocumentNo
	   AND   D.PersonCategory = T3.Category
	   AND   D.DocumentNo = DC.DocumentNo
	   AND  (DC.Status = '0' OR DC.Status = '3')
	   AND   DC.LastName LIKE '#URL.iLASTNAME#'
	   AND   D.DocumentNo = DRP.DocumentNo
	   AND   DRP.PersonNo = P.PersonNo
	   AND   P.LastName LIKE '#URL.oLASTNAME#'
	   AND   D.Status!='9'
	   GROUP BY T1.DocumentNo
   </cfquery>
</cfif>


<cfif URL.iLASTNAME neq "" AND URL.oLASTNAME neq "">
	<cfquery name="tmp4d" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		CREATE TABLE Userquery.dbo._#SESSION.acc#_tmp4d (DocumentNo Int, ActionOrder int)
	</cfquery>

	<cfquery name="tmp4d" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	   INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4d (DocumentNo, ActionOrder)
	   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
	   FROM Userquery.dbo._#SESSION.acc#_tmp1 T1, Document D, #tmplist3 T3
	   WHERE T1.DocumentNo = D.DocumentNo
	   AND   D.PersonCategory = T3.Category
	   AND D.Status!='9'
	   GROUP BY T1.DocumentNo
	</cfquery>
</cfif>


<cfquery name="tmp4" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * INTO Userquery.dbo._#SESSION.acc#_tmp4 FROM Userquery.dbo._#SESSION.acc#_tmp4a 
</cfquery>

<cfquery name="tmp4" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo._#SESSION.acc#_tmp4b
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo._#SESSION.acc#_tmp4)
</cfquery>

<cfquery name="tmp4" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo._#SESSION.acc#_tmp4c
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo._#SESSION.acc#_tmp4)
</cfquery>
	
<cfquery name="tmp4" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
INSERT INTO Userquery.dbo._#SESSION.acc#_tmp4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo._#SESSION.acc#_tmp4d
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo._#SESSION.acc#_tmp4)
</cfquery>



0000000000-- Build tmplist5 from tmplist4 adding fields ActionLevel, and ActionDateActual to hold action dates (see next 2 steps)
<cfquery name="tmp4" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT T4.*, T4.ActionOrder-1 AS ActionOrderLessOne, DF.ActionId, DF.ActionClass, DF.ActionLevel, 
	'0' AS SubmitToTu, 0 AS ProcDaysGiven,
       CAST('01/01/1900' AS DateTime) AS SubmitToTuDate, CAST('01/01/1900' AS DateTime) AS ExpDeployDate 
INTO #tmplist5
FROM #tmplist4 T4, DocumentFlow DF
WHERE T4.DocumentNo = DF.DocumentNo
AND   T4.ActionOrder= DF.ActionOrder
</cfquery>

-- 20Oct04 - Build tmpSubmitToTu to contain req# + ealiest candidate process date for requests that completed SubmitToTu step (exclude reset actions)


SELECT DocumentCandidateAction.DocumentNo, MIN(DocumentCandidateAction.ActionDateActual) AS DateSubmitTu
INTO   #tmpSubmitToTu
FROM   DocumentCandidateAction INNER JOIN
       DocumentFlow ON DocumentCandidateAction.DocumentNo = DocumentFlow.DocumentNo AND 
       DocumentCandidateAction.ActionId = DocumentFlow.ActionId INNER JOIN
       FlowActionRule ON DocumentFlow.ActionId = FlowActionRule.ActionId AND DocumentFlow.ActionClass = FlowActionRule.RuleTemplate
WHERE  FlowActionRule.RuleTriggerClass = 'SubmitToTu'
  AND  DocumentCandidateAction.ActionDateActual IS NOT NULL
  AND  DocumentCandidateAction.ActionStatus NOT IN ('2','9','6')
GROUP BY DocumentCandidateAction.DocumentNo

-- 20Oct04 - For each req, update SubmitTu fields based on matching req# in tmpSubmitToTu table
UPDATE #tmplist5
SET SubmitToTuDate = TU.DateSubmitTu, SubmitToTu = '1'
FROM #tmplist5 T5, #tmpSubmitToTu TU
WHERE T5.DocumentNo = TU.DocumentNo

-- Get earliest deployment date for ANY active candidate
UPDATE #tmplist5
SET ExpDeployDate = (SELECT Min(DC.PlannedDeployment) 
                     FROM DocumentCandidate DC
		     WHERE DC.DocumentNo = #tmplist5.DocumentNo                                                    
                     AND DC.Status <> '9'
		     AND DC.PlannedDeployment IS NOT NULL) 

-- Compute number of processing days given to Tvl Unit
UPDATE #tmplist5
SET ProcDaysGiven = DATEDIFF(d, SubmitToTuDate, ExpDeployDate)
WHERE SubmitToTu = '1'
AND   ExpDeployDate IS NOT NULL
AND   SubmitToTuDate IS NOT NULL

-- Aggregate the ActionOrder column in TMPLIST5 to reflect the next action pending --
-- Do this only for CANDIDATE-Level steps EXCEPT the first and last steps --
UPDATE #tmplist5 SET ActionOrder = ActionOrder+1 
WHERE ActionOrder > (SELECT MIN(ActionOrder) 
                     FROM DocumentFlow DF 
                     WHERE DF.DocumentNo = #tmplist5.DocumentNo AND DF.ActionLevel = '1')	
  AND ActionOrder <= (SELECT Max(ActionOrder) 
                      FROM DocumentFlow DF 
                      WHERE DF.DocumentNo = #tmplist5.DocumentNo AND DF.ActionLevel = '1')

-- Build TMPLIST from T5, adding ActionArea from DocumentFlow table. 
SELECT T5.*, DF.ActionArea
INTO #tmplist
FROM #tmplist5 T5, DocumentFlow DF
WHERE T5.DocumentNo = DF.DocumentNo
AND   T5.ActionOrder = DF.ActionOrder


CREATE NONCLUSTERED INDEX IDX_#tmplist ON #tmplist (DocumentNo)	

--Delete extra recs as necessary
IF ('#URL.AREA#' = 'TU') BEGIN
  DELETE FROM #tmplist
  WHERE ActionArea LIKE '%FGS%' 
  OR    ActionArea LIKE '%CPD%' 
  OR    ActionArea LIKE '%MS%' 
  OR    ActionArea LIKE '%FM%'
END
IF ('#URL.AREA#' = 'FGS-All' OR '#URL.AREA#' = 'FGS-DO' OR '#URL.AREA#' = 'FGS-RC' OR '#URL.AREA#' = 'CPD') BEGIN
  DELETE FROM #tmplist
  WHERE ActionArea LIKE '%TU%'
END
IF ('#URL.AREA#' = 'FGS-DO') BEGIN
  DELETE FROM #tmplist
  WHERE ActionArea LIKE '%TU%'
  OR    ActionArea LIKE '%FGS-RC%'
END
IF ('#URL.AREA#' = 'FGS-RC') BEGIN
  DELETE FROM #tmplist
  WHERE ActionArea LIKE '%TU%'
  OR    ActionArea LIKE '%FGS-DO%'
  OR    ActionArea LIKE 'FM'
END

------------------------------------
-- Retrieve records for display --
------------------------------------
-- Selected :  PM  /  FM  /  TS  --
-- CASE 1      No     No     No
--      2      No     Yes    No
--      3      No     No     Yes
--      4      No     Yes    Yes
--      5      Yes    No     No
--      6      Yes    Yes    No
--      7      Yes    No     Yes
--      8      Yes    Yes    Yes
--**************************** CASE 1 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     No     No
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND   V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 2 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     Yes    No
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,

        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 3 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     No     Yes
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' = 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'

   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 4 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     Yes    Yes
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' = 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 5 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    No     No
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
    '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate    
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 6 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    Yes    No
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
    '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder

   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND ('#URL.TUSTAFF#'='All' OR '#URL.TUSTAFF#'='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 7 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes     No     Yes
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' <> 0 AND ('#URL.MISSION#'='All' OR '#URL.MISSION#'='') AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 8 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    Yes    Yes
if ('#URL.SORT#' = 'DocumentNo' OR 
    '#URL.SORT#' = 'Created' OR 
    '#URL.SORT#' = 'RequestDate' OR 
    '#URL.SORT#' = 'PlannedDeployment' OR 
    '#URL.SORT#' = 'ExpectedDeployment' OR 
    '#URL.SORT#' = 'PersonCount' OR 
    '#URL.SORT#' = 'DutyLength') AND 
   '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY CASE '#URL.SORT#'
       WHEN 'DocumentNo' THEN V.DocumentNo 
       WHEN 'Created' THEN V.Created 
       WHEN 'RequestDate' THEN V.RequestDate 
       WHEN 'PlannedDeployment' THEN V.PlannedDeployment
       WHEN 'ExpectedDeployment' THEN ED.ExpectedDeployment
       WHEN 'PersonCount' THEN V.PersonCount
       WHEN 'DutyLength' THEN V.DutyLength
    END   
    DESC
END
if '#URL.SORT#' = 'ActionOrder' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if '#URL.SORT#' = 'Mission' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND	V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if '#URL.SORT#' = 'Description' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if '#URL.SORT#' = 'ActionDescription' AND '#URL.PERMMISSION#' <> 0 AND '#URL.MISSION#'<>'All' AND '#URL.MISSION#'<>'' AND '#URL.TUSTAFF#'<>'All' AND '#URL.TUSTAFF#'<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	#tmplist C, 
	DocumentFlow A, 
	Ref_PermanentMission PM,
        vwCandidateExpectedDeployment ED 
   WHERE V.DocumentNo *= ED.DocumentNo
   AND  V.PermanentMissionId = PM.PermanentMissionId
   AND  V.DocumentNo   = VA.DocumentNo
   AND  VA.DocumentNo   = C.DocumentNo
   AND  VA.ActionOrder  = C.ActionOrder
   AND  VA.ActionId     = A.ActionId
   AND  VA.DocumentNo   = A.DocumentNo
   AND  V.Status        = '#URL.STATUS#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.PermanentMissionId = '#URL.PERMMISSION#'
   AND  V.Mission       = '#URL.MISSION#'
   AND  V.TuStaff       = '#URL.TUSTAFF#'
   AND  V.ActionClass LIKE '#URL.CLASS#'
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END

