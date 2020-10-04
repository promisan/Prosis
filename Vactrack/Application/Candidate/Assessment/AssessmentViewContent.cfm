
<cf_screentop label="Question and Answer Evaluation Form" html="No" jquery="Yes" scroll="Yes">

<cfinclude template="AssessmentViewScript.cfm">

<cfparam name="url.group" default="Candidate">
<cfparam name="url.filter" default="Candidate">

<cfoutput>
	<script>	
		function reload(grp,fil) {
		  ptoken.location('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&modality=#url.modality#&group='+grp+'&filter='+fil)
		}
	</script>
</cfoutput>

<cfquery name="get" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Vacancy.dbo.[Document] 
		WHERE   DocumentNo = '#url.documentno#'
</cfquery>

<cfif url.modality eq "interview">

		<cfquery name="BucketCompetencies" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT FC.CompetenceId
			FROM   Document D 
				   INNER JOIN Applicant.dbo.FunctionOrganization FO
						 ON D.FunctionId = FO.FunctionId
				   INNER JOIN Applicant.dbo.FunctionOrganizationCompetence FC
				   		 ON FO.FunctionId = FC.FunctionId
			WHERE  D.DocumentNo = '#URL.DocumentNo#'
		</cfquery>
				
		<cfquery name="Topic" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT        R.Description  as TopicPhrase, 		              
					  R.ListingOrder as TopicOrder,
					  DCRC.DocumentNo, 
					  DCRC.PersonNo, 
					  DCRC.ActionCode, 
					  DCRC.CompetenceId, 					  
					  DCRC.InterviewNotes as CompetenceContent, 
					  DCRC.OfficerUserId, 
	                  DCRC.OfficerLastName, 
					  DCRC.OfficerFirstName, 
					  DCRC.Created
		FROM          DocumentCandidateInterview AS DCRC INNER JOIN
	                  Applicant.dbo.Ref_Competence AS R ON DCRC.CompetenceId = R.CompetenceId INNER JOIN
					  DocumentCandidate DC ON DC.DocumentNo = DCRC.DocumentNo and DC.PersonNo = DCRC.PersonNo
		WHERE         DCRC.DocumentNo = '#url.documentno#' 
		AND           DCRC.ActionCode = '#url.actioncode#'
		AND           R.Operational = 1
		AND           DC.Status IN ('1','2','2s')
		<cfif BucketCompetencies.recordcount gt 0>
		AND R.CompetenceId IN (
					#QuotedValueList(BucketCompetencies.CompetenceId)#
				)
		<cfelse>
			AND    R.CompetenceCategory = 'Core'	
		</cfif>
		<cfif url.filter eq "candidate">
		AND           DCRC.PersonNo = '#url.personno#'	
		</cfif>
		<cfif url.mode eq "View">
		<cfif url.group eq "candidate">
		ORDER BY      DC.CandidateId, R.ListingOrder
		<cfelse>
		ORDER BY      R.ListingOrder,DC.CandidateId
		</cfif>
		<cfelse>
		ORDER BY      DCRC.PersonNo, R.ListingOrder
		</cfif>
		
	</cfquery>
	
	<cfif topic.recordcount eq "0">
	
		<table style="width:100%"><tr class="labelmedium"><td align="center" style="font-size:26px">No interview minutes were recorded for this candidate.</td></tr></table>
	<cfabort>
	
	</cfif>
	
	
<cfelse>
	
	<cfquery name="Topic" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT        R.TopicPhrase, 
		              R.TopicSubject, 
					  R.TopicOrder,
					  R.TopicRatingScale,
					  R.TopicRatingPass,
					  DCRC.DocumentNo, 
					  DCRC.PersonNo, 
					  DCRC.ActionCode, 
					  DCRC.CompetenceId, 
					  DCRC.CompetenceMode, 
					  DCRC.CompetenceContent, 
					  DCRC.OfficerUserId, 
	                  DCRC.OfficerLastName, 
					  DCRC.OfficerFirstName, 
					  DCRC.Created
		FROM          DocumentCandidateReviewCompetence AS DCRC INNER JOIN
	                  Applicant.dbo.FunctionOrganizationTopic AS R ON DCRC.CompetenceId = R.TopicId INNER JOIN
					   DocumentCandidate DC ON DC.DocumentNo = DCRC.DocumentNo and DC.PersonNo = DCRC.PersonNo
		WHERE         DCRC.DocumentNo = '#url.documentno#' 
		AND           DCRC.ActionCode = '#url.actioncode#'
		<cfif url.filter eq "candidate">
		AND           DCRC.PersonNo = '#url.personno#'	
		</cfif>
		AND           DC.Status IN ('1','2','2s')
		<cfif url.mode eq "View">
		<cfif url.group eq "candidate">
		ORDER BY      DC.CandidateId, R.TopicOrder
		<cfelse>
		ORDER BY      R.TopicOrder,DC.CandidateId
		</cfif>
		<cfelse>
		ORDER BY      DCRC.PersonNo, R.TopicOrder
		</cfif>
		
	</cfquery>
	
</cfif>	

<form method="post" name="textevaluation" id="textevaluation">

<table style="width:90%" align="center">
	
<tr><td style="height:4px"></td></tr>

<tr><td colspan="3" align="center" style="height:40px;font-size:30px">
<cfif url.modality eq "interview">
Interview and Competence Evaluation form
<cfelse>
Question and Answer Evaluation form
</cfif>
</td></tr>	

<cfoutput>
	
<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	
<tr><td style="height:10px"></td></tr>	
<tr>
	<td style="min-width:200px;font-size:20px">Function:</td>
	<td colspan="2" style="font-size:20px">#get.FunctionalTitle# #get.PostGrade#</td>
</tr>
<tr>
	<td style="font-size:20px">Unit:</td>
	<td colspan="2" style="font-size:20px">#get.Mission# / #get.OrganizationUnit#</td>
</tr>
</cfoutput>
<tr><td style="height:1px;border-bottom:1px solid silver" colspan="3"></td></tr>	
<tr>
	<td style="height:25px;font-size:12px;padding-bottom:10px">Presentation:</td>
	<td colspan="2" style="font-size:20px">
	
	<table>
			<tr>				
				<td>
				<select style="border:0px;border-left:1px solid silver;border-right:1px solid silver;" class="regularxxl" id="group" name="group" onchange="reload(this.value,document.getElementById('filter').value)">
	                 <option value="Candidate" <cfif url.group eq "Candidate">selected</cfif>><cf_tl id="Candidate"></option>
					 <option value="Question" <cfif url.group eq "Question">selected</cfif>><cf_tl id="Question"></option>
				   </select>
				 </td>  
				   
				 <td style="padding-left:3px">
				    <select style="border:0px;border-right:1px solid silver;" class="regularxxl" id="filter" name="group" onchange="reload(document.getElementById('group').value,this.value)">
	                 <option value="Candidate" <cfif url.filter eq "Candidate">selected</cfif>><cf_tl id="Selected candidate"></option>
					 <option value="All" <cfif url.filter eq "All">selected</cfif>><cf_tl id="All candidates"></option>
				   </select>
				</td>				   				   
		   </tr>
	</table>
	
	</td>
</tr>
<tr><td style="height:1px;border-bottom:1px solid silver" colspan="3"></td></tr>	

<tr class="hide"><td id="result_"></td></tr>

<cfset per = 0>

<cfif url.group eq "Candidate">
	<cfset grp = "PersonNo">
<cfelse>
	<cfset grp = "TopicOrder">
</cfif>
	
<cfoutput query="Topic" group="#grp#">

<cfset per = per+1>

<cfquery name="Candidate" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        *
	FROM          DocumentCandidate
	WHERE         DocumentNo = '#url.documentno#' 
	AND           PersonNo   = '#personno#'	
	
</cfquery>

<tr><td style="height:20px"></td></tr>

<cfif url.group eq "Candidate">	
<tr>
	<td style="font-size:12px">Candidate:</td>
	<td colspan="2" style="font-size:24px;font-weight:bold">
	<cfif url.modality eq "interview">
	#Candidate.FirstName# #Candidate.LastName#
	<cfelse>	
	<cfif url.mode eq "View">Candidate <cfif url.filter neq "candidate">#per#</cfif><cfelse>#Candidate.FirstName# #Candidate.LastName#</cfif>
	</cfif>
	</td>
	
</tr>
<cfelse>
	<cfif url.modality eq "interview">
		<tr>
		<td valign="top" style="font-size:12px"><cf_tl id="Topic"> #per#:</td>
		<td colspan="2" style="font-size:20px;">#TopicPhrase# </td>
		</tr>
	<cfelse>
		<tr>
		<td valign="top" style="font-size:12px"><cf_tl id="Question"> #per#:</td>
		<td colspan="2" style="font-size:20px;">#TopicPhrase# </td>
		</tr>
	</cfif>
</cfif>

<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	

<cfset row = "0">

<cfoutput>

	<cfset row = row + 1>
	<tr><td style="height:10px;" colspan="2"></td></tr>	
	
	<cfif url.group eq "Candidate">	
	<tr>
		<td valign="top" style="min-width:200px;padding-top:4px;font-size:17px;font-weight:bold"><cfif url.modality eq "interview"><cf_tl id="Topic"><cfelse><cf_tl id="Question"></cfif> #row#.</td>
		<td colspan="2" style="font-size:15px;padding-top:6px;">#TopicPhrase#</td>
	</tr>
	<cfelse>
	<tr>
		<td valign="top" style="width:125px;padding-top:4px;font-size:17px;font-weight:bold">Candidate.</td>
		<td colspan="2" style="font-size:15px;padding-top:6px;">
		<cfif url.modality eq "interview">
		#Candidate.FirstName# #Candidate.LastName#
		<cfelse>
		<cfif url.mode eq "View"><cfif url.filter neq "candidate">#row#</cfif><cfelse>#Candidate.FirstName# #Candidate.LastName#</cfif>
		</cfif>
		</td>
	</tr>
	</cfif>
		
	<tr style="border-top:1px solid silver">	    
		<td align="right" style="font-size:16px;height:10px;padding-right:10px;mon-width:200px"><cfif url.modality eq "interview"><cf_tl id="Interview Minutes"><cfelse>Answer</cfif></td>		
		<td colspan="2" style="height:10px;font-size:14px" align="left"><cf_tl id="Received">:&nbsp;#dateformat(created,client.dateformatshow)# #timeformat(created,"HH:MM")#</td>	
	</tr>
	
	<cfif competencecontent eq "">
	<tr>	
	    <td></td>
		<td colspan="2" align="center" style="border-radius:10px;padding-left:4px;background-color:FFB895;height:30px;padding-right:4px">
		<cf_tl id="Not received"></td>
	</tr>
	<cfelse>
	<tr>	
		<td></td>
		<td colspan="2" style="padding:5px;border:1px solid silver;background-color:f3f3f3">
		#CompetenceContent#</td>
	</tr>
	</cfif>
	
	<cfif url.mode eq "View">
	
	<tr>	    
		<td align="right" style="font-size:16px;height:10px;padding-right:10px"><cf_tl id="Evaluation"></td>
		
		<td colspan="1" style="height:10px;font-size:16px;padding:4px;padding-right:2px">
									
			<cfquery name="get" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateAssessment
			 WHERE  DocumentNo    = '#url.documentno#'
			 AND    PersonNo      = '#PersonNo#'
			 AND    ActionCode    = '#url.actionCode#'
			 AND    Competenceid  = '#CompetenceId#'
			 AND    OfficerUserid = '#session.acc#'  
			</cfquery>
						
			<cfset score = get.AssessmentScore>
			<cfset memo  = get.AssessmentMemo>
						
			<cfif url.modality eq "interview">
									
			<cfset lkt = "seteval('','#url.documentno#','#personno#','#url.actioncode#','#CompetenceId#','#session.acc#','score_#personno#_#competenceid#','score','#url.modality#')">
																							
			<select name="score_#personno#_#competenceid#" id="score_#personno#_#competenceid#" 
				 class="regularxxl" style="font-size:34px;background-color:e5e5e5;width:300px;height:100%" onchange="#lkt#">
				    <option value="0" <cfif Score eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
					<option value="1" <cfif Score eq "1">selected</cfif>><cf_tl id="Excellent"></option>
					<option value="2" <cfif Score eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
					<option value="3" <cfif Score eq "3">selected</cfif>><cf_tl id="Partially"></option>
					<option value="4" <cfif Score eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
			</select>	
			
			<cfelse>
			
			<cfset lkt = "seteval('','#url.documentno#','#personno#','#url.actioncode#','#CompetenceId#','#session.acc#','score_#personno#_#left(competenceid,8)#','score','#url.modality#')">
						
			<select name="score_#personno#_#left(competenceid,8)#" id="score_#personno#_#left(competenceid,8)#" 
				 class="regularxxl" style="font-size:34px;text-align:center;background-color:FFB7FF;width:80px;height:100%" onchange="#lkt#">
				 	<option value="0" selected><cf_tl id="Not applicable"></option>
				    <cfloop index="itm" from="#topicRatingScale#" to="1" step="-1">
					   <option value="#itm#" <cfif Score eq itm>selected</cfif>>#itm#</option>
					</cfloop>	
									
			</select>	
			
			
			</cfif>			
		
		</td>	
		
		<cfset lkt = "seteval('','#url.documentno#','#personno#','#url.actioncode#','#CompetenceId#','#session.acc#','memo_#personno#_#left(competenceid,8)#','memo','#url.modality#')">
	
		<cfparam name="get.AssessmentMemo" default="">				
		
		<td style="padding-top:4px;padding-bottom:4px;width:100%;height:100%">
		<textarea name="memo_#personno#_#left(competenceid,8)#" id="memo_#personno#_#left(competenceid,8)#" onchange="#lkt#" 
		  style="border-radius:3px;background-color:ffffbf;font-size:16px;padding:4px;resize: vertical;width:100%;height:92px">#memo#</textarea>
		</td>		
		
	</tr>
			
	
	<!---
										
	<tr class="labelmedium">	
		<td valign="top"></td>			    		
		<td colspan="2">
		<textarea name="memo_#personno#_#left(competenceid,8)#" id="memo_#personno#_#left(competenceid,8)#" onchange="#lkt#" onmouseout="#lkt#"
		  style="background-color:f1f1f1;font-size:15px;padding:4px;resize: vertical;width:100%;min-height:60px;height:70px">#memo#</textarea>
		</td>										
	</tr>	
	
	--->
	
	</cfif>
	
</cfoutput>
</cfoutput>

<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	

</table>

</form>