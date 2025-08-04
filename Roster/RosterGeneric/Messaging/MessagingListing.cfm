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

<!--- extract for this user the data --->


<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ApplicantMail">	 

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="Mail" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
    
		SELECT   MailId, 
		         A.PersonNo, 
				 A.FirstName+' '+A.LastName as Name,				
				 ApplicantNo, 
				 FunctionId, 
				 RosterActionNo, 
				 MailBatchId, 
				 MailAddress, 
				 MailAddressFrom, 
				 MailSubject, 
				 MailDateSent, 
				 MailStatus,               
		         (SELECT OfficerLastName FROM System.dbo.BroadCast WHERE BroadcastId = M.Functionid) as OfficerLastName

		INTO     userQuery.dbo.#client.acc#ApplicantMail
				 
	    FROM     Applicant.dbo.ApplicantMail M INNER JOIN Applicant.dbo.Applicant A ON M.PersonNo = A.PersonNo
		 
		<!--- only message of this owner --->
		 		 
		WHERE    M.PersonNo IN (
				
					SELECT   DISTINCT SA.PersonNo
					FROM     Applicant.dbo.Ref_SubmissionEdition S INNER JOIN
			                 Applicant.dbo.FunctionOrganization FO ON S.SubmissionEdition = FO.SubmissionEdition INNER JOIN
			                 Applicant.dbo.ApplicantFunction AF ON FO.FunctionId = AF.FunctionId INNER JOIN
			                 Applicant.dbo.ApplicantSubmission SA ON AF.ApplicantNo = SA.ApplicantNo
					WHERE    S.Owner = '#url.owner#'
					
				 )	
		
		<!--- only message with status = 1, users can disable messages to be longer shown --->		 
		AND      M.MailStatus = '1'  

</cfquery>		

</cftransaction>

<cfinclude template="MessagingListingContent.cfm">