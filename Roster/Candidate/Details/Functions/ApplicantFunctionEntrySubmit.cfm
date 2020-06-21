
<cf_screentop html="No" jquery="Yes">
 
<!--- verify if Submission record submission exists --->

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DefaultStatus
	FROM    Ref_SubmissionEdition
	WHERE   SubmissionEdition = '#Form.Edition#'
</cfquery>

<cfquery name="Class" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ExerciseClass
	FROM   Ref_SubmissionEdition
	WHERE  SubmissionEdition = '#Form.Edition#'
</cfquery>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  ApplicantNo
	FROM    ApplicantSubmission
	WHERE   PersonNo          = '#FORM.PersonNo#'
	AND     Source            = '#Form.Source#'
    AND     SubmissionEdition = '#Form.Edition#'  
</cfquery>

<cfif verify.recordcount eq "0">

	<!--- we check for the last entry with this source --->
	
	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  ApplicantNo
		FROM    ApplicantSubmission
		WHERE   PersonNo          = '#FORM.PersonNo#'
		AND     Source            = '#Form.Source#'   
		ORDER BY Created DESC 
	</cfquery>

</cfif>

<cfif Verify.recordcount eq "0">

     <!--- temp measure --->

     <cfquery name="Last" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT     TOP 1 ApplicantNo AS LastNo
     FROM       ApplicantSubmission
	 ORDER BY   ApplicantNo DESC
     </cfquery>
	 
	 <cfif Last.LastNo neq "">
	    <cfset new = Last.LastNo+1>
	 <cfelse>	
	    <cfset new = "1">
	 </cfif> 

   <cfquery name="AssignNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE Parameter SET ApplicantNo = #new#
     </cfquery>

     <cfquery name="LastNo" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
    	 FROM Parameter
	 </cfquery>
 
      <!--- Submit submission --->

     <cfquery name="InsertApplicant" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ApplicantSubmission
	         (PersonNo,
			 ApplicantNo,
	  		 SubmissionDate,
			 ActionStatus,
			 Source,
			 SubmissionEdition,
			 eMailAddress,
			 LanguageId,
		 	 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
      VALUES ('#Form.PersonNo#',
		      '#LastNo.ApplicantNo#', 
	          '#DateFormat(Now(),CLIENT.DateSQL)#',
			  '0',
			  '#Form.Source#',
			  '#Form.Edition#',
			  '',
			  '001',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#DateFormat(Now(),CLIENT.DateSQL)#') 
     </cfquery>
	 
	 <cfset appno = LastNo.ApplicantNo>

<cfelse> 

     <cfset appno = Verify.ApplicantNo>
	 
</cfif>
   
<!--- Update Function --->   

<cfparam name="Form.FunctionId" type="any" default="">

<cf_RosterActionNo ActionCode="FUN" 
                   ActionRemarks="Manual Entry"> 

<cftransaction>

<cfloop index="Item" 
        list="#Form.FunctionId#" 
        delimiters="' ,">
				
		<cfquery name="Remove" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ApplicantFunction
			WHERE ApplicantNo = '#AppNo#' 
			AND   FunctionId = '#Item#'
			AND   Status = '0'
		</cfquery>		
		
		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT FunctionId
			FROM   ApplicantFunction
			WHERE  ApplicantNo = '#AppNo#' 
			AND    FunctionId  = '#Item#'
		</cfquery>
		
		<CFIF Verify.recordCount is 1 > 
		
				<cfquery name="Update" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ApplicantFunction
					SET    Status = '1'
					WHERE  ApplicantNo = '#AppNo#' 
					AND    FunctionId = '#Item#'
					AND    Status NOT IN ('5','9')
				</cfquery>
			
				<!--- 
				do nothing, already registered
				--->
		
		<cfelse>
				
				<cfquery name="InsertFunction" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO dbo.[ApplicantFunction] 
					         (ApplicantNo,
							 FunctionId,
							 Status,
							 Source,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#AppNo#', 
					      	  '#Item#',
							  '#Edition.DefaultStatus#',
							  'Manual',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				 </cfquery>
				 
				 <!--- initial entry --->
				 <cfquery name="UpdateFunctionStatusAction" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO  ApplicantFunctionAction
					   (ApplicantNo,
					   FunctionId, 
					   RosterActionNo, 
					   Status)
					VALUES 
					   ('#AppNo#',
					   '#Item#',
					   '#RosterActionNo#',
					   '0')
					</cfquery> 
					
					<!--- additional entry --->
					
					<cfif Edition.DefaultStatus neq "0">	
					
							<cf_RosterActionNo ActionCode="FUN" ActionRemarks="Manual Entry"> 
				
							<cfquery name="UpdateFunctionStatusAction" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO  ApplicantFunctionAction
								   (ApplicantNo,
								   FunctionId, 
								   RosterActionNo, 
								   Status)
							VALUES 
								   ('#AppNo#',
								   '#Item#',
								   '#RosterActionNo#',
								   '#Edition.DefaultStatus#')
							</cfquery> 
							
					</cfif>			
			
		</cfif>	

</cfloop>

</cftransaction>

<cfoutput>

<cfif url.scope eq "Entry">

	<script>
	 ptoken.location('#client.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?ID=#URLEncodedFormat(Form.PersonNo)#&source=#form.source#&submissionedition=#Form.Edition#')	
	</script>
    
<cfelse>

	<script>
	 ptoken.location('ApplicantFunction.cfm?ID=#URLEncodedFormat(Form.PersonNo)#&ID1=#Form.Edition#')	
	</script>

</cfif>	

</cfoutput>
	
	

