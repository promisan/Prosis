
<!--- candidate recommendation --->

<cfparam name="form.reviewstatus" default="#url.wfinal-1#">
	
<cfquery name="UpdateCandidate" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE DocumentCandidate
		SET    Status                  = '#form.ReviewStatus#',		       
		       StatusDate              = getDate(),
			   StatusOfficerUserId     = '#SESSION.acc#',
			   StatusOfficerLastName   = '#SESSION.last#',
			   StatusOfficerFirstName  = '#SESSION.first#'
		WHERE  DocumentNo              =  '#url.documentno#'
		AND    PersonNo                =  '#url.personno#'  
		AND    Status < '3' or Status = '9' 
</cfquery>	

<!--- entry in the review table --->
			 
 <cfquery name="Check" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM  DocumentCandidateReview
		WHERE DocumentNo     = '#url.documentno#'
		AND   PersonNo       = '#url.personno#'	 
		AND   ActionCode     = '#url.ActionCode#'  
 </cfquery>	
		 
 <cfif Check.Recordcount eq "1">
 
	 <cfquery name="Update" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE DocumentCandidateReview
		SET    ReviewMemo    = '#Form.Reviewmemo#',						 
		       ReviewDate    = getDate(),
			   ReviewStatus  = '#Form.ReviewStatus#',
			   ActionStatus  = '1'
		WHERE  DocumentNo    = '#url.documentno#'
		AND    PersonNo      = '#url.personno#'	 
		AND    ActionCode    = '#url.ActionCode#' 
	</cfquery>
 
 <cfelse>
 
	 <cfquery name="Insert" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO DocumentCandidateReview
				 (DocumentNo,
				  PersonNo,		  
				  ActionCode,							
				  ReviewMemo,
				  ReviewStatus,
				  ReviewDate, 
				  ActionStatus,							 
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		 VALUES ('#url.documentno#', 
				 '#url.PersonNo#',		  
				 '#url.ActionCode#',							  
				 '#form.Reviewmemo#',
				 '#Form.ReviewStatus#',
				  getDate(),
				 '1',							
				 '#SESSION.acc#',
				 '#SESSION.last#',		  
				 '#SESSION.first#')
		</cfquery>
	
</cfif>

<!--- add candidates to buckets for roster search --->

<cfquery name="fun" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *	   
		FROM    FunctionOrganization				   	   
		WHERE   DocumentNo = '#url.documentno#'		 		 	 
</cfquery>

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DefaultStatus
	FROM    Ref_SubmissionEdition
	WHERE   SubmissionEdition = '#fun.submissionedition#'
</cfquery>

<!---

<cfquery name="Class" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ExerciseClass
	FROM   Ref_SubmissionEdition
	WHERE  SubmissionEdition = '#Form.Edition#'
</cfquery>

--->

<cfparam name="Form.FunctionId" type="any" default="">

<cf_RosterActionNo ActionCode="FUN" 
                   ActionRemarks="Manual Entry"> 

<cftransaction>
	
	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  ApplicantNo
		FROM    ApplicantSubmission
		WHERE   PersonNo          = '#url.personno#'
		AND     Source            = '#Form.Source#' 
	    AND     SubmissionEdition = '#fun.submissionedition#'  
		ORDER BY Created DESC
	</cfquery>
	
	<cfif verify.recordcount eq "0">
	
	<!--- we check for any entry with this source --->
		
		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  ApplicantNo
			FROM    ApplicantSubmission
			WHERE   PersonNo          = '#url.PersonNo#'
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
				 SourceOrigin,
				 SubmissionEdition,
				 eMailAddress,
				 LanguageId,
			 	 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
	      VALUES ('#url.PersonNo#',
			      '#new#', 
		          '#DateFormat(Now(),CLIENT.DateSQL)#',
				  '0',
				  '#Form.Source#',
				  '#fun.DocumentNo#',
				  '#fun.submissionedition#',
				  '',
				  '001',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  '#DateFormat(Now(),CLIENT.DateSQL)#') 
	     </cfquery>
		 
		 <cfset appno = new>
	
	<cfelse> 
	
	     <cfset appno = Verify.ApplicantNo>
		 
	</cfif>
    
<!--- Update Function --->   

	<cfloop index="Item" 
	        list="#Form.FunctionId#" 
	        delimiters="' ,">			
					
			<cfquery name="Verify" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT FunctionId
				FROM   ApplicantFunction
				WHERE  ApplicantNo = '#AppNo#' 
				AND    FunctionId  = '#Item#'
			</cfquery>
			
			<cfif Verify.recordCount is 1 > 
			
				<cfquery name="Update" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ApplicantFunction
					SET    Status = '3'  <!--- rostered --->
					WHERE  ApplicantNo = '#AppNo#' 
					AND    FunctionId  = '#Item#'
					-- AND    Status NOT IN ('5','9')
				</cfquery>
				
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
					   '3')
				</cfquery> 
				
			<cfelse>
					
				<cfquery name="InsertFunction" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO dbo.[ApplicantFunction] 
					         (ApplicantNo,
							 FunctionId,
							 FunctionDate,
							 Status,
							 StatusDate,
							 Source,
							 FunctionJustification,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#AppNo#', 
					      	  '#Item#',
							  '#dateformat(now(),client.dateSQL)#',
							  '3',		
							  '#dateformat(now(),client.dateSQL)#',					  
							  'Track',
							  'Recommendation from track',
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
					
				<!--- additional entry to make it as 3 rostered --->
									
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
					   '3')
				</cfquery> 
				
			</cfif>	
	
	</cfloop>

</cftransaction>
	
<cfoutput>
	
	<script>
	ProsisUI.closeWindow('decisionbox')
    <cfif form.reviewstatus eq url.wfinal>		
	document.getElementById('status#url.personno#').innerHTML = 'Recommended'
	document.getElementById('status#url.personno#').className = 'highlight'
	<cfelse>
	document.getElementById('status#url.personno#').innerHTML = ''	
	document.getElementById('status#url.personno#').className = 'regular'
	</cfif>
	</script>
	
</cfoutput>
