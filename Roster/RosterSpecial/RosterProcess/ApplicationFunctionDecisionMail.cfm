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
 
<!--- prepare eMail text --->
			
<cfquery name="OwnerStep" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_StatusCode C, 
	       Ref_ParameterOwner R
	WHERE  C.Owner = '#URL.Owner#'
	AND    Id      = 'Fun'
	AND    Status  = '#Form.Status#'
	AND    C.Owner = R.Owner
</cfquery>
				
<!--- send Action eMail automatically --->
				
<cfif OwnerStep.MailConfirmation eq "INDIVIDUAL">

    <!--- run query --->
	<cfquery name="Candidate" 
	datasource="AppsSelection" 
	maxrows="1"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*,
		          AF.FunctionId,
		          S.ApplicantNo, 
			      F.FunctionDescription AS FunctionTitle, 
			      FO.ReferenceNo, 
				  FO.DateEffective,
			      FO.GradeDeployment AS Grade
		FROM      Applicant A INNER JOIN 
	              ApplicantSubmission S ON A.PersonNo = S.PersonNo INNER JOIN
	              ApplicantFunction AF ON S.ApplicantNo = AF.ApplicantNo INNER JOIN
	              FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
	              FunctionTitle F ON FO.FunctionNo = F.FunctionNo
		WHERE     AF.ApplicantNo = '#Form.ApplicantNo#'
		AND       AF.FunctionId  = '#Form.FunctionId#'
	</cfquery>
	
	<!--- populate variable table for reference puposes --->
							
	<!--- send eMail --->
		
	<cfset subject = OwnerStep.MailSubject>
	
	<cfif candidate.gender eq "F">
		<cfset subject = ReplaceNoCase("#subject#", "@name", "Mrs. #Candidate.firstname# #Candidate.lastName#", "ALL")>
	<cfelse>
		<cfset subject = ReplaceNoCase("#subject#", "@name", "Mr. #Candidate.firstname# #Candidate.lastName#", "ALL")>
	</cfif>	
	
	<cfset exp = dateformat("#now()#+#Ownerstep.rosterDays#", "#CLIENT.DateFormatShow#")>
	
	<cfset subject = ReplaceNoCase("#subject#", "@effective", "#dateformat(Candidate.DateEffective, CLIENT.DateFormatShow)#", "ALL")>
	<cfset subject = ReplaceNoCase("#subject#", "@expiration", "#exp#", "ALL")>
	<cfset subject = ReplaceNoCase("#subject#", "@grade", "#Candidate.grade#", "ALL")>
	<cfset subject = ReplaceNoCase("#subject#", "@RefNum", "#Candidate.ReferenceNo#", "ALL")>							
	<cfset subject = ReplaceNoCase("#subject#", "@function", "#Candidate.functiontitle#", "ALL")>
	<cfset subject = ReplaceNoCase("#subject#", "@dob", "#dateformat(Candidate.dob, CLIENT.DateFormatShow)#", "ALL")>
	<cfset subject = ReplaceNoCase("#subject#", "@officer", "#SESSION.first# #SESSION.last#", "ALL")>
	
	<cfset body = "#ownerStep.MailText#">
			
	<cfif candidate.gender eq "F">
		<cfset body = ReplaceNoCase("#body#", "@name", "Mrs. #Candidate.firstname# #Candidate.lastName#", "ALL")>
	<cfelse>
		<cfset body = ReplaceNoCase("#body#", "@name", "Mr. #Candidate.firstname# #Candidate.lastName#", "ALL")>
	</cfif>	
	<!---
	<cfset exp = #dateformat("#now()#+#Ownerstep.rosterDays#", "#CLIENT.DateFormatShow#")#>		
	<cfset body = ReplaceNoCase("#body#", "@expiration", "#exp#", "ALL")>
	--->
	<cfset body = ReplaceNoCase("#body#", "@grade", "#Candidate.grade#", "ALL")>
	<cfset body = ReplaceNoCase("#body#", "@RefNum", "#Candidate.ReferenceNo#", "ALL")>							
	<cfset body = ReplaceNoCase("#body#", "@function", "#Candidate.functiontitle#", "ALL")>
	<cfset body = ReplaceNoCase("#body#", "@dob", "#dateformat(Candidate.dob, CLIENT.DateFormatShow)#", "ALL")>
	<cfset body = ReplaceNoCase("#body#", "@officer", "#SESSION.first# #SESSION.last#", "ALL")>
	<cfset body = ReplaceNoCase("#body#", "@effective", "#dateformat(Candidate.DateEffective, CLIENT.DateFormatShow)#", "ALL")>
		
		
	<!--- to           = "#app.eMailAddress#" --->
						
	<cfif candidate.eMailAddress neq "" and OwnerStep.DefaultEMailAddress neq "">
	
		<cfif isValid("email", "#Candidate.eMailAddress#")>
		
		    <cfif isValid("email", "#client.email#")>
	
				<cf_MailSend
					class        = "Applicant"
					classId      = "#Candidate.PersonNo#"
					ApplicantNo  = "#Candidate.ApplicantNo#"
					FunctionId   = "#Candidate.FunctionId#"
					ReferenceId  = "#RosterActionNo#"
					TO           = "#Candidate.eMailAddress#"
					BCC          = "#client.email#"
					FROM         = "#OwnerStep.DefaultEMailAddress#"
					subject      = "#subject#"
					bodycontent  = "#body#"
					mailSend     = "Yes"
					saveMail     = "1">
				
			<cfelse>
			
				<cf_MailSend
					class        = "Applicant"
					classId      = "#Candidate.PersonNo#"
					ApplicantNo  = "#Candidate.ApplicantNo#"
					FunctionId   = "#Candidate.FunctionId#"
					ReferenceId  = "#RosterActionNo#"
					TO           = "#Candidate.eMailAddress#"	
					BCC          = "#client.email#"				
					FROM         = "#OwnerStep.DefaultEMailAddress#"
					subject      = "#subject#"
					bodycontent  = "#body#"
					mailSend     = "Yes"
					saveMail     = "1">				
			
			</cfif>	
			
		<cfelse>	
		
			<!--- just log the mail --->
		
			<cf_MailSend
				class        = "Applicant"
				classId      = "#Candidate.PersonNo#"
				ApplicantNo  = "#Candidate.ApplicantNo#"
				FunctionId   = "#Candidate.FunctionId#"
				ReferenceId  = "#RosterActionNo#"
				TO           = "NOT SENT:#Candidate.eMailAddress#"
				FROM         = "#OwnerStep.DefaultEMailAddress#"
				subject      = "#subject#"
				bodycontent  = "#body#"
				mailSend     = "No"
				saveMail     = "1">
		
		</cfif>
		
	<cfelse>
	
		<!--- just log the mail --->
	
		<cf_MailSend
			class        = "Applicant"
			classId      = "#Candidate.PersonNo#"
			ApplicantNo  = "#Candidate.ApplicantNo#"
			FunctionId   = "#Candidate.FunctionId#"
			ReferenceId  = "#RosterActionNo#"
			TO           = "NOT SENT:#Candidate.eMailAddress#"
			FROM         = "#OwnerStep.DefaultEMailAddress#"
			subject      = "#subject#"
			bodycontent  = "#body#"
			mailSend     = "No" <!--- log do not send --->
			saveMail     = "1">
	
	</cfif>
	
</cfif>