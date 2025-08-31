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
<cfquery name="qExercise"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  EX.*
	FROM    Ref_ExerciseClass EX INNER JOIN Ref_SubmissionEdition S
	ON      EX.ExcerciseClass = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#'
</cfquery>

<cfquery name="qRecipients" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	  INSERT INTO Ref_SubmissionEditionOrganization
	        (SubmissionEdition,OrgUnit,Operational,OfficerUserId,OfficerLastName,OfficerFirstName)
	  SELECT '#URL.SubmissionEdition#', OrgUnit, 0, '#SESSION.acc#','#SESSION.last#','#SESSION.first#'
	  FROM   Organization.dbo.Organization O
	  WHERE  Mission       = '#qExercise.TreePublish#'
	  AND    OrgUnitClass  = '#qExercise.OrgUnitClass#' 
	  AND NOT EXISTS (
		  	SELECT 'X'
			FROM   Ref_SubmissionEditionOrganization 
			WHERE OrgUnit = O.OrgUnit 
			AND   SubmissionEdition = '#URL.SubmissionEdition#'
	  )
</cfquery>

<cfquery name="qRecipientsTypes" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  * 
  FROM    Ref_SubmissionEditionAddressType
  WHERE   SubmissionEdition = '#URL.SubmissionEdition#'  
</cfquery>

<cfif qRecipientsTypes.recordcount eq 0>

	<!--- ----------- --->
	<!--- Prepopulate --->
	<!--- ----------- --->

	<cfquery name="qRecipients" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  INSERT  INTO Ref_SubmissionEditionAddressType 
	          (SubmissionEdition,
			   AddressType,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
	  SELECT  DISTINCT '#URL.SubmissionEdition#', OA.AddressType, '#SESSION.acc#','#SESSION.last#','#SESSION.first#'
	  FROM    Organization.dbo.OrganizationAddress OA INNER JOIN Organization.dbo.Organization O ON OA.OrgUnit = O.OrgUnit
	  WHERE   O.Mission    = '#qExercise.TreePublish#'
	  AND     OrgUnitClass = '#qExercise.OrgUnitClass#' 
	</cfquery>

</cfif>
