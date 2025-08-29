<!--
    Copyright © 2025 Promisan B.V.

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


