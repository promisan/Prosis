
<!--- candidate recommendation --->

<cfquery name="doc" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *	   
		FROM    Document				   	   
		WHERE   DocumentNo = '#url.documentNo#'		 		 	 
</cfquery>

<cfquery name="fun" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *	   
		FROM    FunctionOrganization				   	   
		WHERE   DocumentNo = '#doc.documentNo#'		 		 	 
</cfquery>

<cfquery name="get" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  A.*, DC.Status			   
		FROM    DocumentCandidate DC INNER JOIN
                Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                Ref_Status S ON DC.Status = S.Status    				   	   
		WHERE   DC.DocumentNo = '#url.documentNo#'		 
		AND     DC.PersonNo   = '#url.personno#'		 
</cfquery>

<cfoutput>

<form name="recommendation" id="recommendation" style="height:98%">
	
	<table width="96%" height="100%" align="center">
	
	<tr><td id="myprocess"></td></tr>
	
	<tr class="labelmedium line">
	<td style="height:40px;font-size:18px"><cf_tl id="Candidate">:</td>
	<td style="width:80%;;font-size:18px"><cfoutput>#get.LastName#, #get.FirstName#</cfoutput></td>
	</tr>
	
	<cfquery name="subAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT       D.DocumentId, D.DocumentCode, D.DocumentDescription, D.DocumentOrder, D.DocumentTemplate
		FROM         Ref_EntityActionDocument AS A INNER JOIN
		             Ref_EntityDocument AS D ON A.DocumentId = D.DocumentId
		WHERE        A.ActionCode = '#url.actioncode#'
		AND          DocumentType = 'activity'
		AND          DocumentMode = 'notify'
		ORDER BY     D.DocumentOrder		
	</cfquery>
	
	<cfloop query="subaction">
	
	<tr class="labelmedium"><td colspan="2">
	<cfinclude template="../../../../#DocumentTemplate#">
	</td></tr>
	
	</cfloop>
	
	<tr class="labelmedium line">
	<td style="height:40px;font-size:18px"><cf_tl id="Select for Job">:</td>
	<td style="width:80%">
		<input class = "Radiol" 
		       style = "height:21px;width:21px" 
			   type  = "checkbox" 
			   name  = "ReviewStatus" id="ReviewStatus" 
			   value = "#url.wFinal#" <cfif get.Status gte url.wFinal>checked</cfif> style="cursor:pointer">					
	</td>
	</tr>
	
	<!--- make listing for this person by excluding existing selections if not '9' --->
	
	
	<cfif fun.recordcount eq "1">
	
		 <cfset url.id       = get.PersonNo>
	 	 <cfset url.id1      = fun.submissionedition>		
	
		<cfquery name="Edition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_SubmissionEdition
			WHERE  SubmissionEdition = '#fun.submissionedition#' 
		</cfquery>
	
		<cfquery name="Parameter" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ParameterOwner
			WHERE   Owner = '#Edition.Owner#' 
		</cfquery>
	
		<cfquery name="FunctionAll" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT V.*, 
			
			        <!--- we check the highest status in any submission for this person to be shown --->
					
				   (SELECT MAX(R.Status)							
					FROM   ApplicantFunction M,
					       ApplicantSubmission S,				   
						   Ref_StatusCode R
						   
					WHERE  S.PersonNo          = '#get.PersonNo#'
					AND    S.ApplicantNo       = M.ApplicantNo				
					AND    R.Id                = 'FUN'
					AND    R.Status            = M.Status
					AND    M.FunctionId        = V.FunctionId
					AND    R.ShowRosterSearch = 1  <!--- was AND    M.Status NOT IN ('5','9') out of roster or cancelled --->
		 			) as ApplicantFunctionStatus
					
			FROM   vwFunctionOrganization V 
			
			<!--- same edition as this track is associated to --->
			WHERE  V.SubmissionEdition = '#fun.submissionedition#' 
			<!--- filter by occupational group of the track to keep the list limited to relevant --->
			AND    V.OccupationalGroup = '#doc.occupationalgroup#' 	
			AND    V.GradeDeployment = '#doc.GradeDeployment#'
			
			<!--- we show only titles that are enabled as rostered --->
			<cfif Parameter.DefaultRoster eq fun.submissionedition>
				AND   (V.FunctionRoster = '1' OR V.ReferenceNo IN ('Direct','direct'))		
			</cfif>	
												 
			ORDER BY OccupationGroupDescription, 
			         OrganizationDescription, 
					 HierarchyOrder, 
					 ListingOrder, 
					 FunctionDescription						 
						
		</cfquery>

		<cfif FunctionAll.recordcount gte "1">
		
			<tr class="labelmedium line">
			<td style="height:40px;font-size:18px"><cf_tl id="Roster candidate"></td>
			<td style="width:80%">
			 
			
			 <cfinclude template = "CandidateRecommendationBucket.cfm">			
			
			</td>
			</tr>
		
		</cfif>
	
	</cfif>
		
	<tr><td style="height:2px"></td></tr>
	
	<tr class="labelmedium">
	<td colspan="2" style="min-width:260px;padding-top:4px;height:40px;font-size:18px;padding-right:10px" colspan="1"><cf_tl id="Reason for recommendation">:
	<span style="font-size:12px;color:gray">Please explain why the recommended candidate is considered to be the most suitable for the position based on her/his acquired experience versus the requirements of the job (don’t type out the PHP but provide a brief assessment on what the candidate brings to the job)</span>
    </td>
	</tr>
	
	<tr class="labelmedium">
	<td colspan="2" valign="top" align="center" style="padding-top:4px;height:80%">
	
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
	 
	 <textarea style="border:0px;background-color:f1f1f1;height:150px;width:100%;font-size:13px;padding:4px" class="regular"  name="ReviewMemo">#Check.ReviewMemo#</textarea>
	
	</td>
	</tr>
	
	<tr><td colspan="2" align="center" style="padding-top:5px">
		<table class="formspacing">
		<tr>
		<td><input type="button" value="Close" name="Close"   class="button10g" style="font-size:15px;height:28px;width:200px" 
		     onclick="ProsisUI.closeWindow('decisionbox')"></td>
		<td><input type="button" value="Submit" name="Submit" class="button10g" style="font-size:15px;height:28px;width:200px" 
		     onclick="updateTextArea();ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateRecommendationSubmit.cfm?wparam=#url.wparam#&documentno=#url.documentNo#&personno=#url.personno#&actioncode=#url.actioncode#&wfinal=#url.wfinal#','myprocess','','','POST','recommendation')"></td>
		</tr>
		</table>
	</td></tr>
	
	</table>

</form>

</cfoutput>

