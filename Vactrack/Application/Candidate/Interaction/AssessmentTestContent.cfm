<cfparam name="url.documentNo"   default="">
<cfparam name="url.personNo"     default="">
<cfparam name="url.actoncode"    default="">
<cfparam name="url.mode"         default="">
<cfparam name="url.competenceid" default="">

<cfoutput>

<cfif url.mode eq "edit">

      <cfquery name="getSubmission" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT        *
			FROM          DocumentCandidateReviewCompetence
			WHERE 		  DocumentNo = '#url.documentno#' 
			AND           ActionCode = '#url.actioncode#'
			AND           PersonNo   = '#url.personno#'
			AND           CompetenceId = '#url.competenceid#'	
		</cfquery>
						
		<cf_textarea name="content_#itm#"			 					
				 color="ffffff"	 
				 resize="false"	
				 onchange="setcontent('#itm#','#url.documentno#','#url.personno#','#url.competenceid#','#url.actioncode#','#session.acc#')"	
				 border="0" 
				 toolbar="Basic"
				 height="82%"
				 width="100%">#getSubmission.CompetenceContent#</cf_textarea>
		 
		<cfset ajaxOnload("initTextArea")>

<cfelse>
	
	<cfquery name="getSubmission" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT        *
			FROM          DocumentCandidateAssessment
			WHERE 		  DocumentNo    = '#url.documentno#' 
			AND           ActionCode    = '#url.actioncode#'
			AND           PersonNo      = '#url.personno#'
			AND           CompetenceId  = '#url.competenceid#'	
			AND           OfficerUserId = '#url.UserAccount#'
		</cfquery>
	
	<script>	
	   
		document.getElementById('score_#itm#').disabled = true				
		document.getElementById('memo_#itm#').disabled = true		
		
	</script>
	
	<cfif url.competenceid neq "" and url.personno neq "">
	
		<script>
			
			<cfif url.mode eq "View">
			$("##score_#itm#").val('#getSubmission.AssessmentScore#')
			document.getElementById('score_#itm#').disabled = false		
			$("##memo_#itm#").val('#getSubmission.AssessmentMemo#')
			document.getElementById('memo_#itm#').disabled = false
			</cfif>
		
			// document.getElementById('memo_#itm#') = '#getSubmission.AssessmentScore#'
		
		</script>	
		
	</cfif>
	
</cfif>

</cfoutput>


