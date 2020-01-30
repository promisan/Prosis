USE [Travel]
GO
/****** Object:  StoredProcedure [dbo].[spActionListingALLMISSIONS]    Script Date: 06/21/2013 09:21:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER           PROCEDURE [dbo].[spActionListingALLMISSIONS]	-- build 041020
@USERID VARCHAR(20)= 'tempVac', 
@STATUS VARCHAR(2)= '0', 
@SORT VARCHAR(50)= 'Mission',
@MISSION VARCHAR(30) = '',
@PERMMISSION INT = 0,
@CLASS VARCHAR(20) = '',
@TUSTAFF VARCHAR(3) = '',
@AREA VARCHAR(10) = '',
@iLASTNAME VARCHAR(20) = '%%',
@oLASTNAME VARCHAR(20) = '%%',
@DOCNO INTEGER = '0',                  
@DOCNO1 INTEGER = '99999999'
AS
-- NOTE:
-- 1. The main difference between spActionListing and spActionListingALLMISSION is in the WHERE clause 
--    of the steps to build Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__tmplist4a - 4d.
-- 2. The criterion D.Mission = T3.Mission is present in the former version ONLY.
--
-- Modification History --
-- 30Sep03 - added code to capture completed candidate-level actions --
--           in order to provide a more informative status message --
--           be displayed in the Document Listing page --
-- 15Oct03 - added subselect statement in Build Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__TMPLIST2 routine to
--           prevent stalled candidates from affecting the status message
-- 02Feb04 - added code to handle new param TuStaff (responsible for processing request)
-- 04May04 - added code to handle new param Area (All, CPD, FGS, or TU)
-- 04Jun04 - added code to allow filtering by FGS-DO and FGS-RC
-- 19Jun04 - added code to retrieve earliest deployment date of any candidate 
-- 19Jun04 - added code to retrieve last date when SubmitNomineesToTU step was completed
-- 29Jul04 - added code to retrieve Nominee Expected Deployment date. In particular,
--           1. created new view vwCandidateExpectedDeployment which was linked to tables in SELECT statements
--	     2. added field ExpectedDeployment in variable @SORT evaluation and in the ORDER BY statements
-- 09Aug04 - added code to build Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__tmplist4a-4c and the code to populate Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__tmplist4 from these tables.  This
--           is to handle the feature to allow filtering by either RotatingPerson lastname, Nominee lastname, or both.
-- 08Sep04 - added line "AND DC.DocumentNo = DCA.DocumentNo)" to Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__TMPLIST2 section to limit checking for a stalled/
--           revoked candidate to just the current request.
-- 09Sep04 - In Aggregate ActionOrder column, modified next line from:
-- 	     WHERE ActionOrder >= (SELECT MIN(ActionOrder) FROM DocumentFlow DF WHERE DF.DocumentNo = Userquery.dbo.Userquery.dbo.#Session.acc#_Session.accUserquery.dbo.#Session.acc#__tmplist5.DocumentNo
--   				to:
--    	     WHERE ActionOrder > (SELECT MIN(ActionOrder) 
--                                FROM DocumentFlow DF 
--                                WHERE DF.DocumentNo = Userquery.dbo.#Session.acc#_tmplist5.DocumentNo
-- 20Oct04 - Modified procedure for computing SubmitToTu flag, SubmitToTuDate field
--

-- Build TMPLIST1 containing earliest pending document-level actions --
SELECT DISTINCT DA.DocumentNo, MIN(DA.ActionOrder) as TmpActionOrd 
INTO Userquery.dbo.#Session.acc#_tmplist0
FROM DocumentAction DA, Document D
WHERE DA.DocumentNo = D.DocumentNo
  AND DA.DocumentNo >= @DOCNO
  AND DA.DocumentNo <= @DOCNO1
AND (DA.ActionStatus = '0' OR D.Status > '0')
AND D.Status!='9'
GROUP BY DA.DocumentNo 
ORDER BY DA.DocumentNo

-- Build TMPLIST2 containing latest completed action (per candidate)
-- Where: 
-- 1. Candidate actions should be 1, 7, or 8 (i.e., completed, bypassed or not applicable)
-- 2. Candidate should not have had a revoked or stalled action.
-- 3. Candidate should not be currently revoked or stalled.
SELECT DISTINCT DCA.DocumentNo, MAX(DCA.ActionOrder) as TmpActionOrd
INTO Userquery.dbo.#Session.acc#_tmplist2
FROM DocumentCandidateAction DCA, Document D
WHERE DCA.DocumentNo = D.DocumentNo
  AND DCA.DocumentNo >= @DOCNO
  AND DCA.DocumentNo <= @DOCNO1
  AND DCA.ActionStatus IN ('1','7','8')
  AND DCA.PersonNo NOT IN ( SELECT DC.PersonNo FROM DocumentCandidate DC 
                            WHERE  DC.PersonNo = DCA.PersonNo
                            AND    DC.Status IN ('6','9')
			    AND    DC.DocumentNo = DCA.DocumentNo )
  AND D.Status!='9'
GROUP BY DCA.DocumentNo, DCA.PersonNo

-- From TMPLIST2, select earliest action, and append to TMPLIST1 --
INSERT INTO Userquery.dbo.#Session.acc#_tmplist0 ( DocumentNo, TmpActionOrd )
SELECT T2.DocumentNo, Min(T2.TmpActionOrd)
FROM Userquery.dbo.#Session.acc#_tmplist2 T2
GROUP BY T2.DocumentNo

-- Also insert earliest candidate level step into TMPLIST2 (regarless of candidate)
-- ** This is necessary in those cases where there is no candidate level action was ever
--    completed for the request (as in the case when the Confirm Nominee Data step is still pending)
INSERT INTO Userquery.dbo.#Session.acc#_tmplist0 ( DocumentNo, TmpActionOrd )
SELECT DISTINCT DCA.DocumentNo, MIN(DCA.ActionOrder)
FROM Document D, DocumentCandidateAction DCA
WHERE D.DocumentNo = DCA.DocumentNo 
  AND D.DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo.#Session.acc#_tmplist2 WHERE DocumentNo = D.DocumentNo)
  AND D.DocumentNo >= @DOCNO
  AND D.DocumentNo <= @DOCNO1
  AND D.Status!='9'
GROUP BY DCA.DocumentNo

-- Build pm_TMPLIST1 containing earliest document-level action in TMPLIST0 --  STOPPED HERE 040816
SELECT DocumentNo, MIN(TmpActionOrd) as TmpActionOrder 
INTO Userquery.dbo.#Session.acc#_tmplist1
FROM Userquery.dbo.#Session.acc#_tmplist0
WHERE DocumentNo >= @DOCNO
  AND DocumentNo <= @DOCNO1
GROUP BY DocumentNo 
ORDER BY DocumentNo

-- Build TMPLIST3 containing authorized Missions and Traveller Categories that
-- current user is allowed to access
SELECT AA.Mission, RC.Category INTO Userquery.dbo.#Session.acc#_tmplist3
FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
WHERE AA.ActionId = FA.ActionID
AND   FA.ActionClass = RT.TravellerTypeCode
AND   RT.TravellerType = RC.TravellerType
AND   AA.AccessLevel <> '9'
AND   AA.UserAccount = @USERID
GROUP BY AA.Mission, RC.Category

-- Build TMPLIST4a, TMPLIST4b, and TMPLIST4c from TMPLIST1 based on user entries (if any) in the 
-- Rotating Person and Nominee names search fields
--
-- Note: 
-- 1. WHERE clause has does not use criterion D.Mission = T3.Mission as user has access to all missions
-- 2. This criterion is present in spActionListing stored proc
--
-- ********** Case 1: Nominee defined; Rotating Person undefined **********
CREATE TABLE Userquery.dbo.#Session.acc#_tmplist4a (DocumentNo Int, ActionOrder int)
IF (@iLASTNAME <> '%%' AND @oLASTNAME = '%%') 
BEGIN
   INSERT INTO Userquery.dbo.#Session.acc#_tmplist4a (DocumentNo, ActionOrder)
   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
   FROM Userquery.dbo.#Session.acc#_tmplist1 T1, Document D, Userquery.dbo.#Session.acc#_tmplist3 T3, DocumentCandidate DC
   WHERE T1.DocumentNo = D.DocumentNo
   AND   D.DocumentNo = DC.DocumentNo
   AND   D.PersonCategory = T3.Category
   AND   DC.LastName LIKE @iLASTNAME
   AND  (DC.Status = '0' OR DC.Status = '3')
   AND D.Status!='9'
   GROUP BY T1.DocumentNo
END

-- ********** Case 2: Nominee undefined; Rotating Person defined **********
CREATE TABLE Userquery.dbo.#Session.acc#_tmplist4b (DocumentNo Int, ActionOrder int)
IF (@iLASTNAME = '%%' AND @oLASTNAME <> '%%') 
BEGIN   
   INSERT INTO Userquery.dbo.#Session.acc#_tmplist4b (DocumentNo, ActionOrder)
   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder 
   FROM Userquery.dbo.#Session.acc#_tmplist1 T1, Document D, Userquery.dbo.#Session.acc#_tmplist3 T3, DocumentRotatingPerson DRP, EMPLOYEE.DBO.Person P
   WHERE T1.DocumentNo = D.DocumentNo
   AND   D.PersonCategory = T3.Category
   AND   D.DocumentNo = DRP.DocumentNo
   AND   DRP.PersonNo = P.PersonNo
   AND   P.LastName LIKE @oLASTNAME
   AND D.Status!='9'
   GROUP BY T1.DocumentNo
END

-- ********** Case 3: Both Nominee and Rotating Person defined **********
CREATE TABLE Userquery.dbo.#Session.acc#_tmplist4c (DocumentNo Int, ActionOrder int)
IF (@iLASTNAME <> '%%' AND @oLASTNAME <> '%%') 
BEGIN   
   INSERT INTO Userquery.dbo.#Session.acc#_tmplist4c (DocumentNo, ActionOrder)
   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
   FROM Userquery.dbo.#Session.acc#_tmplist1 T1, Document D, Userquery.dbo.#Session.acc#_tmplist3 T3, DocumentCandidate DC,
        DocumentRotatingPerson DRP, EMPLOYEE.DBO.Person P
   WHERE T1.DocumentNo = D.DocumentNo
   AND   D.PersonCategory = T3.Category
   AND   D.DocumentNo = DC.DocumentNo
   AND  (DC.Status = '0' OR DC.Status = '3')
   AND   DC.LastName LIKE @iLASTNAME
   AND   D.DocumentNo = DRP.DocumentNo
   AND   DRP.PersonNo = P.PersonNo
   AND   P.LastName LIKE @oLASTNAME
   AND   D.Status!='9'
   GROUP BY T1.DocumentNo
END

-- ********** Case 4: Neither Nominee nor Rotating Person defined **********
CREATE TABLE Userquery.dbo.#Session.acc#_tmplist4d (DocumentNo Int, ActionOrder int)
IF (@iLASTNAME = '%%' AND @oLASTNAME = '%%') 
BEGIN
   INSERT INTO Userquery.dbo.#Session.acc#_tmplist4d (DocumentNo, ActionOrder)
   SELECT T1.DocumentNo, Min(T1.TmpActionOrder) AS ActionOrder
   FROM Userquery.dbo.#Session.acc#_tmplist1 T1, Document D, Userquery.dbo.#Session.acc#_tmplist3 T3
   WHERE T1.DocumentNo = D.DocumentNo
   AND   D.PersonCategory = T3.Category
   AND D.Status!='9'
   GROUP BY T1.DocumentNo
END

-- Append records from TMPLIST4B (records with matching nominees) and then from TMPLIST4A (records with matching 
-- rotating persons) into TMPLIST4 removing duplicate records in the process.  Important to load first 'nominee' 
-- records as this step is later in the workflow and we want to reflect the later workflow status for each Request doc.
SELECT * INTO Userquery.dbo.#Session.acc#_tmplist4 FROM Userquery.dbo.#Session.acc#_tmplist4a 
--
INSERT INTO Userquery.dbo.#Session.acc#_tmplist4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo.#Session.acc#_tmplist4b
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo.#Session.acc#_tmplist4)
--
INSERT INTO Userquery.dbo.#Session.acc#_tmplist4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo.#Session.acc#_tmplist4c
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo.#Session.acc#_tmplist4)
--
INSERT INTO Userquery.dbo.#Session.acc#_tmplist4 (DocumentNo, ActionOrder)
SELECT DocumentNo, ActionOrder FROM Userquery.dbo.#Session.acc#_tmplist4d
WHERE DocumentNo NOT IN (SELECT DocumentNo FROM Userquery.dbo.#Session.acc#_tmplist4)

-- Build tmplist5 from tmplist4 adding fields ActionLevel, and ActionDateActual to hold action dates (see next 2 steps)
SELECT T4.*, T4.ActionOrder-1 AS ActionOrderLessOne, DF.ActionId, DF.ActionClass, DF.ActionLevel, 
	'0' AS SubmitToTu, 0 AS ProcDaysGiven,
       CAST('01/01/1900' AS DateTime) AS SubmitToTuDate, CAST('01/01/1900' AS DateTime) AS ExpDeployDate 
INTO Userquery.dbo.#Session.acc#_tmplist5
FROM Userquery.dbo.#Session.acc#_tmplist4 T4, DocumentFlow DF
WHERE T4.DocumentNo = DF.DocumentNo
AND   T4.ActionOrder= DF.ActionOrder

-- 20Oct04 - Build tmpSubmitToTu to contain reqUserquery.dbo.#Session.acc#_ + ealiest candidate process date for requests that completed SubmitToTu step (exclude reset actions)
SELECT DocumentCandidateAction.DocumentNo, MIN(DocumentCandidateAction.ActionDateActual) AS DateSubmitTu
INTO   Userquery.dbo.#Session.acc#_tmpSubmitToTu
FROM   DocumentCandidateAction INNER JOIN
       DocumentFlow ON DocumentCandidateAction.DocumentNo = DocumentFlow.DocumentNo AND 
       DocumentCandidateAction.ActionId = DocumentFlow.ActionId INNER JOIN
       FlowActionRule ON DocumentFlow.ActionId = FlowActionRule.ActionId AND DocumentFlow.ActionClass = FlowActionRule.RuleTemplate
WHERE  FlowActionRule.RuleTriggerClass = 'SubmitToTu'
  AND  DocumentCandidateAction.ActionDateActual IS NOT NULL
  AND  DocumentCandidateAction.ActionStatus NOT IN ('2','9','6')
GROUP BY DocumentCandidateAction.DocumentNo

-- 20Oct04 - For each req, update SubmitTu fields based on matching reqUserquery.dbo.#Session.acc#_ in tmpSubmitToTu table
UPDATE Userquery.dbo.#Session.acc#_tmplist5
SET SubmitToTuDate = TU.DateSubmitTu, SubmitToTu = '1'
FROM Userquery.dbo.#Session.acc#_tmplist5 T5, Userquery.dbo.#Session.acc#_tmpSubmitToTu TU
WHERE T5.DocumentNo = TU.DocumentNo

-- Get earliest deployment date for ANY active candidate
UPDATE Userquery.dbo.#Session.acc#_tmplist5
SET ExpDeployDate = (SELECT Min(DC.PlannedDeployment) 
                     FROM DocumentCandidate DC
		     WHERE DC.DocumentNo = Userquery.dbo.#Session.acc#_tmplist5.DocumentNo                                                    
                     AND DC.Status <> '9'
		     AND DC.PlannedDeployment IS NOT NULL) 

-- Compute number of processing days given to Tvl Unit
UPDATE Userquery.dbo.#Session.acc#_tmplist5
SET ProcDaysGiven = DATEDIFF(d, SubmitToTuDate, ExpDeployDate)
WHERE SubmitToTu = '1'
AND   ExpDeployDate IS NOT NULL
AND   SubmitToTuDate IS NOT NULL

-- Aggregate the ActionOrder column in TMPLIST5 to reflect the next action pending --
-- Do this only for CANDIDATE-Level steps EXCEPT the first and last steps --
UPDATE Userquery.dbo.#Session.acc#_tmplist5 SET ActionOrder = ActionOrder+1 
WHERE ActionOrder > (SELECT MIN(ActionOrder) 
                     FROM DocumentFlow DF 
                     WHERE DF.DocumentNo = Userquery.dbo.#Session.acc#_tmplist5.DocumentNo AND DF.ActionLevel = '1')	
  AND ActionOrder <= (SELECT Max(ActionOrder) 
                      FROM DocumentFlow DF 
                      WHERE DF.DocumentNo = Userquery.dbo.#Session.acc#_tmplist5.DocumentNo AND DF.ActionLevel = '1')

-- Build TMPLIST from T5, adding ActionArea from DocumentFlow table. 
SELECT T5.*, DF.ActionArea
INTO Userquery.dbo.#Session.acc#_tmplist
FROM Userquery.dbo.#Session.acc#_tmplist5 T5, DocumentFlow DF
WHERE T5.DocumentNo = DF.DocumentNo
AND   T5.ActionOrder = DF.ActionOrder


CREATE NONCLUSTERED INDEX IDX_Userquery.dbo.#Session.acc#_tmplist ON Userquery.dbo.#Session.acc#_tmplist (DocumentNo)	

--Delete extra recs as necessary
IF (@AREA = 'TU') BEGIN
  DELETE FROM Userquery.dbo.#Session.acc#_tmplist
  WHERE ActionArea LIKE '%FGS%' 
  OR    ActionArea LIKE '%CPD%' 
  OR    ActionArea LIKE '%MS%' 
  OR    ActionArea LIKE '%FM%'
END
IF (@AREA = 'FGS-All' OR @AREA = 'FGS-DO' OR @AREA = 'FGS-RC' OR @AREA = 'CPD') BEGIN
  DELETE FROM Userquery.dbo.#Session.acc#_tmplist
  WHERE ActionArea LIKE '%TU%'
END
IF (@AREA = 'FGS-DO') BEGIN
  DELETE FROM Userquery.dbo.#Session.acc#_tmplist
  WHERE ActionArea LIKE '%TU%'
  OR    ActionArea LIKE '%FGS-RC%'
END
IF (@AREA = 'FGS-RC') BEGIN
  DELETE FROM Userquery.dbo.#Session.acc#_tmplist
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
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission = 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 2 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     Yes    No
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 3 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     No     Yes
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission = 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl, 
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission = 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS

   AND  V.ActionClass LIKE @CLASS
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 4 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             No     Yes    Yes
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission = 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 5 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    No     No
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
    @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.PermanentMissionId = @PERMMISSION
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 6 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    Yes    No
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
    @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND (@TuStaff='All' OR @TuStaff='')
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 7 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes     No     Yes
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission <> 0 AND (@Mission='All' OR @Mission='') AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END
--**************************** CASE 8 **********************************
-- Selected :  PM  /  FM  /  TS  --
--             Yes    Yes    Yes
if (@Sort = 'DocumentNo' OR 
    @Sort = 'Created' OR 
    @Sort = 'RequestDate' OR 
    @Sort = 'PlannedDeployment' OR 
    @Sort = 'ExpectedDeployment' OR 
    @Sort = 'PersonCount' OR 
    @Sort = 'DutyLength') AND 
   @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY CASE @SORT
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
if @Sort = 'ActionOrder' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY C.ActionOrder
END
if @Sort = 'Mission' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY V.Mission
END
if @Sort = 'Description' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY PM.Description
END
if @Sort = 'ActionDescription' AND @PermMission <> 0 AND @Mission<>'All' AND @Mission<>'' AND @TuStaff<>'All' AND @TuStaff<>''
BEGIN
SELECT V.*, '0' as PersonNo, ' ' as LastName, ' ' as FirstName,
   VA.ActionOrder, A.ActionDescription, A.ActionOrderSub, A.ActionArea, A.ActionClass, C.SubmitToTu, C.ProcDaysGiven,
   V.Status, VA.ActionStatus, PM.Description, LEFT(V.Remarks,70) AS sRemarks, LEFT(V.RemarksTvl,70) AS sRemarksTvl,
   (CASE WHEN ED.ExpectedDeployment=NULL THEN CAST('01/01/1900' AS DateTime) ELSE ED.ExpectedDeployment END) AS ExpectedDeployment
   FROM Document V, 
	DocumentAction VA, 
	Userquery.dbo.#Session.acc#_tmplist C, 
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
   AND  V.Status        = @STATUS
   AND  V.ActionClass LIKE @CLASS
   AND  V.PermanentMissionId = @PERMMISSION
   AND  V.Mission       = @MISSION
   AND  V.TuStaff       = @TUSTAFF
   AND  V.ActionClass LIKE @CLASS
   AND  V.Status!='9'
   ORDER BY A.ActionDescription
END

