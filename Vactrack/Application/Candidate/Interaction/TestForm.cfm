
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
		WHERE   ReviewId = '#session.EntityReference#'
</cfquery>


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
	SELECT        TopicId,
	              TopicPhrase, 
	              TopicSubject, 
				  TopicOrder					  
	FROM          Applicant.dbo.FunctionOrganizationTopic T INNER JOIN 
	              Applicant.dbo.FunctionOrganization O ON T.Functionid = O.FunctionId
	WHERE         DocumentNo = '#get.documentno#' 		
	AND           Operational = 1
	ORDER BY      TopicOrder			
</cfquery>

<form action="<cfoutput>#SESSION.root#/Vactrack/Application/Candidate/Interaction/TestFormSubmit.cfm?actionsessionid=#url.actionsessionid#</cfoutput>" method="post" name="testform" id="testform">

	<table style="width:90%" align="center">
		
		<tr><td style="height:14px"></td></tr>
				
		<tr><td colspan="3" align="center" style="height:40px;font-size:35px">Consultant / Individual Contractor Test </td></tr>				
		<tr><td colspan="3" align="center" style="height:40px;font-size:15px">Instructions ; you may record in this form, you may prepare answers in word and then paste, if you experience  problems please contact XYZ</td></tr>	
					
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
		
		<cfoutput>
					
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
		
			<cfquery name="Content" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT        *
				FROM          DocumentCandidateReviewCompetence
				WHERE         DocumentNo = '#get.documentno#' 
				AND           ActionCode = '#get.actioncode#'	
				AND           PersonNo   = '#get.personno#'	
				AND           CompetenceId = '#TopicId#'
		   </cfquery>
						
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
					 border="0" 
					 init="Yes"
					 toolbar="Basic"
					 height="200"
					 width="100%">#Content.CompetenceContent#</cf_textarea>
				
				</td>
			</tr>				
			
		</cfoutput>
		
		</table>
		</td></tr>
	
	<tr><td style="height:30px" align="center" colspan="3">	
	<input type="submit" name="Submit" value="Submit" class="button10g" style="width:200px;height:35px;font-size:20px">
	</td></tr>	
		
	</table>

</form>
