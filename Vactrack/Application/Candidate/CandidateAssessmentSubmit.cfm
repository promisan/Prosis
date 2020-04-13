<!--- saving --->

<cfparam name="url.actionCode"   default="">
<cfparam name="url.competenceid" default="">

<cfquery name="check" 
     datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   OrganizationObject
		 WHERE  ObjectId = '#url.objectid#'
</cfquery>

<cfif check.recordcount eq "1">
	
	<cfquery name="getReview" 
	     datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   DocumentCandidateReview
		 WHERE  DocumentNo = '#check.ObjectKeyValue1#'
		 AND    PersonNo   = '#url.personNo#'
		 AND    ActionCode = '#url.actionCode#'
	</cfquery>
	
	<cfif getReview.recordcount eq "0">
	
		<cfquery name="Insert" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO DocumentCandidateReview
					 (DocumentNo,
					  PersonNo,		  
					  ActionCode,							 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#check.ObjectKeyValue1#',		  
					  '#url.personNo#',							 
					  '#url.actionCode#',
					  '#SESSION.acc#',
					  '#SESSION.last#',		  
					  '#SESSION.first#')
		</cfquery>	
	
	</cfif>
	
	<cfquery name="getAssessment" 
	     datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT * 
		 FROM   DocumentCandidateAssessment
		 WHERE  DocumentNo    = '#check.ObjectKeyValue1#'
		 AND    PersonNo      = '#url.personno#'
		 AND    ActionCode    = '#url.actionCode#'
		 AND    Competenceid  = '#url.competenceid#'
		 AND    OfficerUserid = '#session.acc#'  
	</cfquery>
	
	<cfif getAssessment.recordcount eq "1">
	
		<cfset val = evaluate("form.#url.formfield#")>	
	
		<cfquery name="updateAssessment" 
	     datasource="AppsVacancy" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE DocumentCandidateAssessment
			 SET    <cfif url.field eq "score">
				    AssessmentScore = '#val#'
				    <cfelse>
				    AssessmentMemo  = '#val#'
				    </cfif>
			 WHERE  DocumentNo      = '#check.ObjectKeyValue1#'
			 AND    PersonNo        = '#url.personno#'
			 AND    ActionCode      = '#url.actionCode#'
			 AND    Competenceid    = '#url.competenceid#'
			 AND    OfficerUserid   = '#session.acc#' 
	     </cfquery>
		
	<cfelse>
	
		<cfset val = evaluate("form.#url.formfield#")>		
	
		<cfquery name="Insert" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateAssessment
						 (DocumentNo,
						  PersonNo,		  
						  ActionCode,							 
						  Competenceid,						  
						  <cfif url.field eq "score">
						  AssessmentScore,
						  <cfelse>
						  AssessmentMemo,
						  </cfif>
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#check.ObjectKeyValue1#',		  
						  '#url.personno#',							 
						  '#url.actionCode#',
						  '#url.competenceid#',
						  '#val#',
						  '#SESSION.acc#',
						  '#SESSION.last#',		  
						  '#SESSION.first#')
			</cfquery>			
		
	 </cfif>
	
</cfif>	
