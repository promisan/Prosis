
<cf_screentop label="Question and Answer Evaluation Form" html="No" jquery="Yes" scroll="Yes">

<cfinclude template="AssessmentViewScript.cfm">

<cfparam name="url.group" default="Candidate">
<cfparam name="url.filter" default="Candidate">

<cfoutput>
<script>

function reload(grp,fil) {
  ptoken.location('#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&group='+grp+'&filter='+fil)
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


<cfquery name="Question" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        R.TopicPhrase, 
	              R.TopicSubject, 
				  R.TopicOrder,
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

<form method="post" name="textevaluation" id="textevaluation">

<table style="width:90%" align="center">
	
<tr><td style="height:4px"></td></tr>

<tr>
	<td colspan="3" align="center" style="height:40px;font-size:30px">Question and Answer Evaluation form</td>
</tr>	

<cfoutput>
	
<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	
<tr><td style="height:10px"></td></tr>	
<tr>
	<td style="font-size:20px">Function:</td>
	<td colspan="2" style="font-size:20px">#get.FunctionalTitle# #get.PostGrade#</td>
</tr>
<tr>
	<td style="font-size:20px">Unit:</td>
	<td colspan="2" style="font-size:20px">#get.Mission# / #get.OrganizationUnit#</td>
</tr>
</cfoutput>
<tr><td style="height:1px;border-bottom:1px solid silver" colspan="3"></td></tr>	
<tr>
	<td style="height:35px;font-size:12px;padding-bottom:10px">Presentation:</td>
	<td colspan="2" style="font-size:20px">
	
	<table><tr>
				
				<td>
				<select class="regularxxl" id="group" name="group" onchange="reload(this.value,document.getElementById('filter').value)">
	                 <option value="Candidate" <cfif url.group eq "Candidate">selected</cfif>><cf_tl id="Candidate"></option>
					 <option value="Question" <cfif url.group eq "Question">selected</cfif>><cf_tl id="Question"></option>
				   </select>
				 </td>  
				   
				 <td style="padding-left:3px"><select class="regularxxl" id="filter" name="group" onchange="reload(document.getElementById('group').value,this.value)">
	                 <option value="Candidate" <cfif url.filter eq "Candidate">selected</cfif>><cf_tl id="Selected"></option>
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
	
<cfoutput query="Question" group="#grp#">

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
	<td colspan="2" style="font-size:24px;font-weight:bold"><cfif url.mode eq "View">Candidate #per#<cfelse>#Candidate.FirstName# #Candidate.LastName#</cfif></td>
</tr>
<cfelse>
<tr>
	<td valign="top" style="font-size:12px">Question #per#:</td>
	<td colspan="2" style="font-size:20px;">#TopicPhrase# </td>
</tr>
</cfif>

<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	

<cfset row = "0">

<cfoutput>

	<cfset row = row + 1>
	<tr><td style="height:10px;" colspan="2"></td></tr>	
	
	<cfif url.group eq "Candidate">	
	<tr>
		<td valign="top" style="width:125px;padding-top:4px;font-size:17px;font-weight:bold">Question #row#.</td>
		<td colspan="2" style="font-size:15px;padding-top:6px;">#TopicPhrase#</td>
	</tr>
	<cfelse>
	<tr>
		<td valign="top" style="width:125px;padding-top:4px;font-size:17px;font-weight:bold">Candidate.</td>
		<td colspan="2" style="font-size:15px;padding-top:6px;"><cfif url.mode eq "View">#row#<cfelse>#Candidate.FirstName# #Candidate.LastName#</cfif></td>
	</tr>
	</cfif>
		
	<tr>	    
		<td align="right" style="font-size:16px;height:10px;padding-right:10px">Answer</td>
		<td style="font-size:16px"></td>
		<td style="height:10px;font-size:16px" align="right"><cf_tl id="Received">:&nbsp;#dateformat(created,client.dateformatshow)# #timeformat(created,"HH:MM")#</td>	
	</tr>
	
	<cfif competencecontent eq "">
	<tr>	
	    <td></td>
		<td colspan="2" align="center" style="padding-left:4px;border:1px solid silver;background-color:ffffaf;padding-right:4px">
		<cf_tl id="Not received"></td>
	</tr>
	<cfelse>
	<tr>	
		<td></td>
		<td colspan="2" style="padding-left:4px;border:1px solid silver;background-color:f3f3f3;padding-right:4px">
		#CompetenceContent#</td>
	</tr>
	</cfif>
	
	<cfif url.mode eq "View">
	
	<tr>	    
		<td align="right" style="font-size:16px;height:10px;padding-right:10px">Evaluation</td>
		
		<td colspan="2" style="height:10px;font-size:16px" align="right">
									
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
															
			<cfset lkt = "seteval('','#url.documentno#','#personno#','#url.actioncode#','#CompetenceId#','#session.acc#','score_#personno#_#left(competenceid,8)#','score')">
																				
			<select name="score_#personno#_#left(competenceid,8)#" id="score_#personno#_#left(competenceid,8)#" 
				 class="regularxxl" style="background-color:ffffcf;border-top:0px;width:100%" onchange="#lkt#" onmouseout="#lkt#">
				    <option value="0" <cfif Score eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
					<option value="1" <cfif Score eq "1">selected</cfif>><cf_tl id="Out-standing"></option>
					<option value="2" <cfif Score eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
					<option value="3" <cfif Score eq "3">selected</cfif>><cf_tl id="Partially satisfactory"></option>
					<option value="4" <cfif Score eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
			</select>				
		
		</td>	
	</tr>
			
	<cfset lkt = "seteval('','#url.documentno#','#personno#','#url.actioncode#','#CompetenceId#','#session.acc#','memo_#personno#_#left(competenceid,8)#','memo')">
	
	<cfparam name="get.AssessmentMemo" default="">				
										
	<tr class="labelmedium">	
		<td valign="top"></td>			    		
		<td colspan="2">
		<textarea name="memo_#personno#_#left(competenceid,8)#" id="memo_#personno#_#left(competenceid,8)#" onchange="#lkt#" onmouseout="#lkt#"
		  style="border-top:0px solid silver;background-color:ffffdf;font-size:15px;padding:4px;resize: vertical;width:100%;min-height:60px;height:70px">#memo#</textarea>
		</td>										
	</tr>	
	
	</cfif>
	
</cfoutput>
</cfoutput>

<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	

</table>

</form>