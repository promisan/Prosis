
<CF_DropTable dbName="AppsQuery"  tblName="rosterLastAction"> 
<CF_DropTable dbName="AppsQuery"  tblName="rosterLastAction2"> 
<CF_DropTable dbName="AppsQuery"  tblName="rosterMailBase">

<!--- create a batch id --->

<cfset cnt = 0>

<cf_assignId>  
<cfset batchid = rowguid> 

<cfquery name="Log" 
datasource="AppsSelection">
	INSERT INTO MailBatchLog 
			(BatchId,ProcessClass,ProcessStart,OfficerUserId,ProcessStatus)
	VALUES  ('#batchid#','Roster',getDate(),'#CGI.Remote_Addr#','In process') 
</cfquery>

<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Prepare data for roster batch mail (1)">

<!--- define the last action that were performed for all roster actions --->
<cfquery name="Base" 
datasource="AppsSelection">
	SELECT    ApplicantNo, 
	          FunctionId, 
			  MAX(RosterActionNo) AS RosterActionNo
	INTO      userQuery.dbo.rosterLastAction
	FROM      ApplicantFunctionAction
	GROUP BY  ApplicantNo, FunctionId
</cfquery>

<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Prepare data for roster batch mail (2)">

<!--- get a subtabel with the last actions that are taken for a person --->		
<cfquery name="Base2" 
datasource="AppsSelection">
	SELECT  FA.ApplicantNo, 
	        FA.FunctionId, 
			FA.RosterActionNo, 
			FA.Status, 
			RA.Created
	INTO    userQuery.dbo.rosterLastAction2
	FROM    ApplicantFunctionAction FA 
	        INNER JOIN userQuery.dbo.RosterLastAction Last 
			                ON  FA.ApplicantNo = Last.ApplicantNo 
							AND FA.FunctionId = Last.FunctionId 
							AND FA.RosterActionNo = Last.RosterActionNo 
			INNER JOIN RosterAction RA ON FA.RosterActionNo = RA.RosterActionNo 
	WHERE   FA.status != '0' 		
		<!--- condition for sending --->
</cfquery>		


<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Prepare data for roster batch mail (3)">

<!--- link the last action with a record in Applicant mail to determine if a mail was sent for this applicant/roster action already --->

<cfquery name="BaseSet" 
datasource="AppsSelection">
	SELECT    RA.ApplicantNo, 
	          RA.FunctionId, 
			  RA.RosterActionNo, 
			  RA.Status, 
			  RA.Created
	INTO      userQuery.dbo.rosterMailBase	
	FROM      ApplicantMail M 
	          RIGHT OUTER JOIN  userQuery.dbo.RosterLastAction2 RA 
			         ON  M.ApplicantNo    = RA.ApplicantNo
					 AND M.FunctionId     = RA.FunctionId 
					 AND M.RosterActionNo = RA.RosterActionNo
	GROUP BY  RA.ApplicantNo, RA.FunctionId, RA.RosterActionNo, RA.Status, RA.Created, M.MailId	
	HAVING    M.MailId IS NULL
</cfquery>

<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Preparation completed">

<CF_DropTable dbName="AppsQuery"  tblName="rosterLastAction"> 
<CF_DropTable dbName="AppsQuery"  tblName="rosterLastAction2"> 

<cfquery name="OwnerStep" 
	datasource="AppsSelection">
	SELECT  * 
	FROM    Ref_StatusCode C, 
	        Ref_ParameterOwner R
	WHERE   C.MailConfirmation = 'Batch'
	AND     C.MailSubject > ''  <!--- has indeed something to be sent --->
	AND     C.Id      = 'Fun'
	AND     C.Owner = R.Owner
	AND     R.Operational = 1
</cfquery>

<cfloop query="OwnerStep">

	<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Process #Owner# - #Status# - #Meaning#">

	<!--- associate to candidate information so we have enough data to be used for sending here --->
		
	<cfquery name="Candidate" 
	datasource="AppsSelection">
		SELECT    A.*, 
		          Mail.*, 
				  F.FunctionDescription AS FunctionTitle, 
				  S.eMailAddress AS SubmissionMail,
				  FO.ReferenceNo, 
				  FO.DateEffective,
				  FO.GradeDeployment AS Grade
				  
		FROM      FunctionOrganization FO 
				  INNER JOIN userQuery.dbo.rosterMailBase Mail ON FO.FunctionId = Mail.FunctionId 
				  INNER JOIN ApplicantSubmission S ON Mail.ApplicantNo = S.ApplicantNo 
				  INNER JOIN Applicant A ON S.PersonNo = A.PersonNo AND S.PersonNo = A.PersonNo 
				  INNER JOIN FunctionTitle F ON FO.FunctionNo = F.FunctionNo 
				  INNER JOIN Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition   
		
		WHERE     (R.Owner = 'EAD') AND (Mail.Status = '1') AND (S.PersonNo = '1002543')
		<!---	   
		WHERE     R.Owner     = '#Owner#'
		AND       Mail.Status = '#Status#'		
		AND       Mail.Created < getdate()-#mailBatchDelay#  
		AND       Mail.Created >= '#dateformat(mailDateStart,client.dateSQL)#'
		--->
		
	</cfquery>
	
	<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Process #Status# - #Meaning# for #Candidate.recordcount# candidates">
	
	<cfoutput query="Candidate">
		
		<cfset subject = OwnerStep.MailSubject>
		
		<cfif candidate.gender eq "F">
			<cfset subject = ReplaceNoCase("#subject#", "@name", "Mrs. #firstname# #lastName#", "ALL")>
		<cfelse>
			<cfset subject = ReplaceNoCase("#subject#", "@name", "Mr. #firstname# #lastName#", "ALL")>
		</cfif>	
		
		<!---
		<cfset exp = #dateformat("#now()#+#Ownerstep.rosterDays#", "#CLIENT.DateFormatShow#")#>		
		<cfset subject = ReplaceNoCase("#subject#", "@expiration", "#exp#", "ALL")>
		--->
		
		<cfset subject = ReplaceNoCase("#subject#", "@effective", "#dateformat(DateEffective, CLIENT.DateFormatShow)#", "ALL")>		
		<cfset subject = ReplaceNoCase("#subject#", "@grade", "#grade#", "ALL")>
		<cfset subject = ReplaceNoCase("#subject#", "@RefNum", "#ReferenceNo#", "ALL")>							
		<cfset subject = ReplaceNoCase("#subject#", "@function", "#functiontitle#", "ALL")>
		<cfset subject = ReplaceNoCase("#subject#", "@dob", "#dateformat(dob, CLIENT.DateFormatShow)#", "ALL")>
		<cfset subject = ReplaceNoCase("#subject#", "@officer", "#SESSION.first# #SESSION.last#", "ALL")>
	
		<!--- send eMail --->
		<cfset body = "#ownerStep.MailText#">
	
		<cfif candidate.gender eq "F">
			<cfset body = ReplaceNoCase("#body#", "@name", "Mrs. #firstname# #lastName#", "ALL")>
		<cfelse>
			<cfset body = ReplaceNoCase("#body#", "@name", "Mr. #firstname# #lastName#", "ALL")>
		</cfif>	
		
		<cfset exp = #dateformat("#now()#+#Ownerstep.rosterDays#", "#CLIENT.DateFormatShow#")#>
		<cfset body = ReplaceNoCase("#body#", "@expiration", "#exp#", "ALL")>
		
		<cfset body = ReplaceNoCase("#body#", "@effective", "#dateformat(DateEffective, CLIENT.DateFormatShow)#", "ALL")>			
		<cfset body = ReplaceNoCase("#body#", "@grade", "#grade#", "ALL")>
		<cfset body = ReplaceNoCase("#body#", "@function", "#functiontitle#", "ALL")>
		<cfset body = ReplaceNoCase("#body#", "@RefNum", "#ReferenceNo#", "ALL")>							
		<cfset body = ReplaceNoCase("#body#", "@dob", "#dateformat(dob, CLIENT.DateFormatShow)#", "ALL")>
		<cfset body = ReplaceNoCase("#body#", "@officer", "#SESSION.first# #SESSION.last#", "ALL")>
								
		<cfif candidate.SubmissionMail neq "" and OwnerStep.DefaultEMailAddress neq "">
		
			<cfif isValid("email", "#SubmissionMail#")>
		
				<cfset cnt = cnt + 1>
			
				<cf_MailSend
					class        = "Applicant"
					classId      = "#PersonNo#"
					ApplicantNo  = "#ApplicantNo#"
					FunctionId   = "#FunctionId#"
					ReferenceId  = "#RosterActionNo#"
					BatchId      = "#BatchId#"
					TO           = "#SubmissionMail#"
					FROM         = "#OwnerStep.DefaultEMailAddress#"
					subject      = "#subject#"
					bodycontent  = "#body#"
					saveMail     = "1">
				
				<cfquery name="Update" 
				datasource="AppsSelection">
					UPDATE Applicant
					SET    eMailValidation = 'Correct'
					WHERE  PersonNo = '#PersonNo#'	
				</cfquery>	
				
			<cfelse>
			
				<cf_MailSend
					class        = "Applicant"
					classId      = "#PersonNo#"
					ApplicantNo  = "#ApplicantNo#"
					FunctionId   = "#FunctionId#"
					ReferenceId  = "#RosterActionNo#"
					BatchId      = "#BatchId#"
					TO           = "#OwnerStep.DefaultEMailAddress#"
					FROM         = "#OwnerStep.DefaultEMailAddress#"
					subject      = "INVALID address #SubmissionMail# - #OwnerStep.MailSubject#"
					bodycontent  = "#body#"
					saveMail     = "1">
			
				<cfquery name="Update" 
				datasource="AppsSelection">
					UPDATE  Applicant
					SET     eMailValidation = 'Invalid'
					WHERE   PersonNo = '#PersonNo#'	
				</cfquery>				
			
			</cfif>
		
		</cfif>
	
	</cfoutput>					  

</cfloop>

<cf_ScheduleLogInsert
   		ScheduleRunId  = "#schedulelogid#"
		Description    = "Completed, a total of #cnt# mails sent">

<cfquery name="Log" 
datasource="AppsSelection">
	UPDATE MailBatchLog
	SET    ProcessEnd    = getDate(),
	       eMailSent     = #cnt#,  
		   ProcessStatus = 'Completed' 
	WHERE  BatchId = '#BatchId#'
</cfquery>

