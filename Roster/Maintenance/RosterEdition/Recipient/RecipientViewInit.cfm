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
