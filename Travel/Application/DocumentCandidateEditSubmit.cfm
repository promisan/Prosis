<!-- 
	DocumentCandidateEditSubmit.cfm
	
	Process entries made in DocumentCandidateEdit.cfm page
	
	Modification history:
	24Sep03 - Placed code to save LastName and Passport Number in uppercase
	29Sep03 - Added code to update LastName and FirstName in DocumentCandidate
	23Oct03 - added code to update DocumentRotatingPerson to record person rotating out
				of the field mission with the incoming candidate	
	17Feb04 - modified UpdateCandidate query to remove field related to persondocuments
	        - added new query UpdatePassport to handle update of persondocuments
	06May04 - added code to handle new field ServiceJoinDate
	10May04 - added code to handle new field SatDate
	27Sep04 - re-wrote Update passport section to:
			  1. First check if this passport record exists for current person
			  2. If yes, update that persondocument record.
			  3. Else, create a new persondocument record.
			- also removed DateFormat() wrapper from Now() when assigning to Created field.
	10Dec04 - added code to check if each passed form var is defined
			- added code to handle users who are allowed to only update the IndexNo field
-->
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cfparam name="Form.ActionId" default="">
<cfparam name="Form.ActionStatus" default="">
<cfparam name="Form.ActionDatePlanningId" default="">
<cfparam name="Form.ActionMemoId" default="">
<cfparam name="Form.CanEditIndex" default="False">

<!---CF_RegisterAction 
SystemFunctionId="1101" 
ActionClass="Document" 
ActionType="Update Candidate" 
ActionReference="#Form.PersonNo#" 
ActionScript=""--->  

<cfif IsDefined("Form.BirthDate") AND #Form.BirthDate# NEQ "">
 	<cfset dateValue = "">
 	<CF_DateConvert Value="#Form.BirthDate#">
 	<cfset BirthDay = #dateValue#>
<cfelse>
 	<cfset BirthDay = "">
</cfif>

<cfif IsDefined("Form.PlannedDeployment")>
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.PlannedDeployment#">		<!--- this is a required field in the Form --->
	<cfset deploy_date = #dateValue#>
</cfif>

<!---added 6may04 --->
<cfset join_date = "">
<cfif IsDefined("Form.ServiceJoinDate")>
    <cfset dateValue = "">
 	<cfif #Form.ServiceJoinDate# NEQ ""> 
		<cfif Len(#Trim(Form.ServiceJoinDate)#) EQ 4>
			<cfoutput>
			<cfset tmpDt = "31/12" & #Trim(Form.ServiceJoinDate)#>
			<CF_DateConvert Value="#tmpDt#">				
			</cfoutput>
		<cfelse>
			 <CF_DateConvert Value="#Form.ServiceJoinDate#">	
		</cfif>
		<cfset join_date = #dateValue#>
	</cfif>
</cfif>

<!--- added 10 May 04 --->
<cfset sat_date = "">
<cfif IsDefined("Form.SatDate")>
    <cfset dateValue = "">
 	<cfif #Form.SatDate# NEQ ""> 
		<CF_DateConvert Value="#Form.SatDate#">	
		<cfset sat_date = #dateValue#>
	</cfif>
</cfif>
 
<cfif IsDefined("Form.PassportIssue") AND #Form.PassportIssue# NEQ "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.PassportIssue#">
	 <cfset pass_iss = #dateValue#>
<cfelse>
	 <cfset pass_iss = "">
</cfif>

<cfif IsDefined("Form.PassportExpiry") AND #Form.PassportExpiry# NEQ "">	 
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#Form.PassportExpiry#">
	 <cfset pass_exp = #dateValue#>
<cfelse>
	 <cfset pass_exp = "">
</cfif>
 
<!--- 24Sep03 --->
<cfif IsDefined("Form.LastName")>
	<cfset sLastName = UCase(#Form.LastName#)>
</cfif>
<cfif IsDefined("Form.PassportNo")>
	<cfset sPassportNo = UCase(#Form.PassportNo#)>
</cfif>

<!--- If User is permitted only to edit Index Number, just allow code to do this, and then halt template processing --->
<cfif #Form.CanEditIndex#>
	<cfquery name="UpdateCandidate" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		UPDATE 	Person
		SET 	IndexNo  = '#Form.IndexNo#'
		WHERE 	PersonNo = '#Form.PersonNo#'		
	</cfquery>
	<cflocation url="DocumentEdit.cfm?ID=#Form.DocumentNo#">
	<cfexit method="EXITTEMPLATE">
</cfif>

<!--- Proceed for users permitted to edit all fields --->
<cfquery name="UpdateCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE DocumentCandidate
	SET LastName		 = '#sLastName#',
		FirstName		 = '#Form.FirstName#',
		Remarks   		 = '#Form.Remarks#',
		SatDate 		 = <cfif #sat_date# NEQ "">#sat_date#,<cfelse>NULL,</cfif>
		PlannedDeployment= #deploy_date#
	WHERE DocumentNo 	 = '#Form.DocumentNo#'	
	AND   PersonNo   	 = '#Form.PersonNo#'
</cfquery>
 
<cfquery name="UpdateCandidate" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE Person
	SET IndexNo     		= '#Form.IndexNo#',
    	LastName			= '#sLastName#', 
		MiddleName			= '#Form.MiddleName#',
		FirstName			= '#Form.FirstName#',
		Category			= '#Form.Category#',
		Rank				= '#Form.Rank#',
		Gender				= '#Form.Gender#',
		Nationality			= '#Form.Nationality#',
		BirthDate			= #BirthDay#,
		ServiceJoinDate		= <cfif #join_date# NEQ "">#join_date#,<cfelse>NULL,</cfif>
		BirthNationality 	= '#Form.BirthNationality#'
	WHERE PersonNo 			= '#Form.PersonNo#'
</cfquery>

<!--- 
  Assumptions:
  1. That no other user will be creating a passport-type document record between the time the candidate editing
     process starts (when the person's passport info is read from the table), and the time the record is saved
	 back into the database.  MM 17 feb 04	
	 
  27Sep04 - passport number handling procedure re-designed.
--->

<!--- added 27Sep04 MM - only process passport no handling if a passport number was in fact entered. --->  

<cfif #Form.PassportNo# NEQ ''>

	<cfquery name="CheckPassportRec" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    	SELECT * FROM PersonDocument
		WHERE PersonNo = '#Form.PersonNo#'
		AND   DocumentReference = '#sPassportNo#'
		AND   DocumentType = 'Passport'
	</cfquery>

	<!--- added 27Sep04 MM --->  
  	<cfif #CheckPassportRec.RecordCount# GT 0>

		<!--- added 27Sep04 MM - 
			1. check if passport dates were changed
		    2. if yes, set this record's Created date to current date to make this the most 
	    	  current passport record (applicable when there are multiple passport records for this person --->

		<cfif #CheckPassportRec.DateEffective# NEQ #pass_iss# OR
			  #CheckPassportRec.DateExpiration# NEQ #pass_exp#>
			  
		  	<cfquery name="UpdatePassportRec" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
			    UPDATE PersonDocument
				SET   Created = #Now()#
					  , DateEffective = <cfif #pass_iss# NEQ "">#pass_iss#<cfelse>NULL</cfif>
				      , DateExpiration = <cfif #pass_exp# NEQ "">#pass_exp#<cfelse>NULL</cfif>
				WHERE PersonDocument.PersonNo = '#Form.PersonNo#'
				AND   PersonDocument.DocumentType = 'Passport'
		  	</cfquery>
			
		</cfif>

	<cfelse>
  
		<CF_RegisterAction 
	   	SystemFunctionId="1265" 
	   	ActionClass="Person Document" 
	   	ActionType="Enter" 
	   	ActionReference="#Form.PersonNo# #sPassportNo#" 
	   	ActionScript="">    

	  	<cfquery name="InsertPassportRec" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	    INSERT INTO PersonDocument
		 (PersonNo,
		  DocumentType,
		  DocumentReference,
		  <cfif #pass_iss# NEQ "">DateEffective,</cfif>
	      <cfif #pass_exp# NEQ "">DateExpiration,</cfif>
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
    	VALUES 
	     ('#Form.PersonNo#',
		  'Passport',
		  '#sPassportNo#',
		  <cfif #pass_iss# NEQ "">#pass_iss#,</cfif>
	      <cfif #pass_exp# NEQ "">#pass_exp#,</cfif>
		  '#SESSION.acc#',
    	  '#SESSION.last#',
	  	  '#SESSION.first#',
		  #Now()#)
	  	</cfquery>
	  
	</cfif>
  
</cfif>

<!-- Establish link between this candidate and the person rotating out of the mission -->
<!-- Note that variable FORM.RotatingPersonNo is only defined in CandidateEntry.cfm when
	 PersonCategory is 'UNMO'. -->
<cfif IsDefined("Form.RotatingPersonNo")>
	<cfquery name="DetachCandidateFromRotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE DocumentRotatingPerson 
	SET ReplacementPersonNo = ''
	WHERE DocumentNo = '#Form.DocumentNo#'
	AND   ReplacementPersonNo = '#Form.PersonNo#'
	</cfquery>

	<cfquery name="UpdateDocumentRotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE DocumentRotatingPerson
	SET ReplacementPersonNo = '#Form.PersonNo#'
	WHERE DocumentNo = '#Form.DocumentNo#'
	AND   PersonNo = '#Form.RotatingPersonNo#'
	</cfquery>
</cfif>

<cfinclude template="Template/DocumentCandidateEditSubmit_Lines.cfm">

<script>
    opener.location.reload()
</script>

<!---cflocation url="Travel/Application/DocumentCandidateEdit.cfm?ID=#Form.DocumentNo#&ID1=#Form.PersonNo#"--->
