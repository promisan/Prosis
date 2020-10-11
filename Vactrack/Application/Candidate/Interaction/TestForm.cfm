

<cfparam name="url.actionsessionid" default="">



<cfquery name="session" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization.dbo.OrganizationObjectActionSession
		WHERE   ActionSessionId = '#url.actionsessionid#'
</cfquery>

<cfquery name="get" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Vacancy.dbo.DocumentCandidateReview
		WHERE   ReviewId = '#session.sessionReferenceId#'
</cfquery>

<cf_screentop label="Candidate Test Form" html="No" jquery="Yes" scroll="Yes">

<cf_textareascript>

<cfquery name="document" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Document 
		WHERE   DocumentNo = '#get.documentno#'
</cfquery>

	
<cfquery name="Topic" 
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
	WHERE         DCRC.DocumentNo = '#get.documentno#' 
	AND           DCRC.ActionCode = '#get.actioncode#'	
	AND           DCRC.PersonNo   = '#get.personno#'	
	ORDER BY      R.TopicOrder			
</cfquery>



<form method="post" name="testform" id="testform">

	<table style="width:90%" align="center">
		
		<tr><td style="height:4px"></td></tr>
		
		<cfoutput>
		
		<tr><td colspan="3" align="center" style="height:40px;font-size:30px">Candidate Test Submission form</td></tr>	
		<tr><td colspan="3" align="center" style="height:40px;font-size:15px">This form will expire after #dateformat(session.sessionplanend,client.dateformatshow)# #timeformat(session.sessionplanend,"HH:MM")#</td></tr>	
		<tr><td colspan="3" align="center" style="height:40px;font-size:15px">Instructions ; you may record in this form, you may prepare answers in word and then paste, if you have problems entering or submitting information please contact XYZ</td></tr>	

					
		<tr><td style="height:10px;border-bottom:1px solid silver" colspan="3"></td></tr>	
		<tr><td style="height:10px"></td></tr>	
		
		<cfquery name="Candidate" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT        *
			FROM          DocumentCandidate
			WHERE         DocumentNo = '#get.documentno#' 
			AND           PersonNo   = '#get.personno#'		
		</cfquery>
					
		<tr>
			<td style="min-width:200px;font-size:20px"><cf_tl id="Candidate">:</td>
			<td colspan="2" style="font-size:20px">#Candidate.FirstName# #Candidate.LastName#</td>
		</tr>
		<tr>
			<td style="min-width:200px;font-size:20px">Job opening:</td>
			<td colspan="2" style="font-size:20px">#document.FunctionalTitle# #document.PostGrade#</td>
		</tr>
		<tr>
			<td style="font-size:20px">Unit:</td>
			<td colspan="2" style="font-size:20px">#document.Mission# / #document.OrganizationUnit#</td>
		</tr>
		
		</cfoutput>
								
		<tr><td style="height:1px;border-bottom:1px solid silver" colspan="3"></td></tr>	
		
				
		<tr><td colspan="3">
		<table style="width:100%">
										
		<cfoutput query="Topic">
						
			<tr><td style="height:10px;" colspan="2"></td></tr>	
					
			<tr>
				<td valign="top" style="min-width:40px;padding-top:4px;font-size:17px;font-weight:bold">#currentrow#.</td>
				<td colspan="2" style="width:90%;font-size:15px;padding-top:6px;">#TopicPhrase#</td>
			</tr>
				
			<tr>	
				<td></td>
				<td colspan="2" style="padding:5px;border:0px solid silver">
				
				 <cf_textarea name="content_#currentrow#"			 					
					 color="ffffff"	 
					 resize="false"	
					 onchange="setcontent('#currentrow#','#get.documentno#','#get.personno#','#competenceid#','#get.actioncode#','#session.acc#')"	
					 border="0" 
					 init="Yes"
					 toolbar="Basic"
					 height="200"
					 width="100%">#CompetenceContent#</cf_textarea>
				
				</td>
			</tr>				
			
		</cfoutput>
		
		</table>
		</td></tr>
	
	<tr><td style="height:30px" align="center" colspan="3">
	
	<input type="button" name="Submit" value="Submit" class="button10g" 
	onclick="alert('Your test has been submitted. You will get an eMail to confirm the by you submitted anwsers. You may continue updating information until the expiration time')" 
	style="width:200px;height:35px;font-size:20px">
	</td></tr>	
		
	</table>

</form>



