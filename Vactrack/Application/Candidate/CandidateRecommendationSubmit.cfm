
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
		WHERE DocumentNo = '#url.documentno#'
		AND   PersonNo   = '#url.personno#'	 
		AND   ActionCode = '#url.ActionCode#'  
 </cfquery>	
		 
 <cfif Check.Recordcount eq "1">
 
	 <cfquery name="Update" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE DocumentCandidateReview
		SET    ReviewMemo    = '#Form.Reviewmemo#',						 
		       ReviewDate    = getDate(),
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
				  ReviewDate, 
				  ActionStatus,							 
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
		 VALUES ('#url.documentno#', 
				 '#url.PersonNo#',		  
				 '#url.ActionCode#',							  
				 '#form.Reviewmemo#',
				  getDate(),
				 '1',							
				 '#SESSION.acc#',
				 '#SESSION.last#',		  
				 '#SESSION.first#')
		</cfquery>
	
	</cfif>
	
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
