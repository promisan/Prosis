<!--
    Copyright © 2025 Promisan

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
-- consider date when applied in Galaxy
/*
UPDATE Parameter SET RosterActionNo = RosterActionNo+1

DECLARE @RANo int
SET @RANo = (SELECT RosterActionNo FROM  Parameter)

INSERT INTO RosterAction (RosterActionNo, ActionCode, 
	ActionSubmitted, OfficerUserId, OfficerUserLastName,
	OfficerUserFirstName, ActionEffective, ActionStatus, 
	ActionRemarks, Created)
VALUES (@RANo, 'FUN', getdate(), 'fodnymc2', 'Data upload', 'PMSS',
	getdate(), '1', 'Batch outdate (365 Cleanup)', getdate())

drop table tmp50
SELECT DISTINCT ApplicantFunction.ApplicantNo, ApplicantFunction.FunctionId
into tmp50
FROM         ApplicantFunction INNER JOIN
                      FunctionOrganization ON ApplicantFunction.FunctionId = FunctionOrganization.FunctionId
WHERE     (DATEDIFF(d, ApplicantFunction.FunctionDate, GETDATE()) >= 365) AND (ApplicantFunction.Status <> '5') AND 
                      (FunctionOrganization.SubmissionEdition = 'galaxyps')

INSERT INTO  ApplicantFunctionAction (ApplicantNo, FunctionId,
	RosterActionNo, Status)
Select distinct a.ApplicantNo,a.FunctionId,@RANo, '5'
from tmp50 a

UPDATE ApplicantFunction
SET Status=5, StatusDate= getDate()  select * 
FROM ApplicantFunction a inner join tmp50
 on a.applicantno = tmp50.applicantno and a.functionid=tmp50.functionid

drop table tmp50
*/