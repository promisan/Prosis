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
<cfquery name="Doc" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  D.*,
	        Org.OrgUnitNameShort, 
			
			( SELECT TOP 1 Fund
			  FROM   Employee.dbo.PositionParentFunding
			  WHERE  PositionParentId = P.PositionParentId 
			  ORDER BY DateEffective DESC ) as Fund,		
			 
			( SELECT EntityClassNameShort
			  FROM   Organization.dbo.Ref_EntityClass as R 
			  WHERE  R.EntityClass = D.EntityClass AND R.EntityCode ='VacDocument' ) as EntityClassNameShort,
			
									
	        F.FunctionId     as VAId, 
			F.ReferenceNo    as VAReferenceNo,
			F.DateEffective  as VAEffective,
			F.DateExpiration as VAExpiration,
			P.SourcePostNumber,
			P.OrgUnitOperational,
			P.FunctionDescription
			
    FROM  	Document D 
	        INNER JOIN Applicant.dbo.FunctionOrganization F  ON D.FunctionId = F.FunctionId
    		INNER JOIN Employee.dbo.Position as P            ON P.PositionNo = D.PositionNo   <!--- Hanno : we should use documentposition so be on the alert --->
			INNER JOIN Organization.dbo.Organization as Org  ON Org.OrgUnit  = P.OrgUnitOperational						
			
    WHERE 	D.DocumentNo = '#url.documentNo#' 
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
		AND     S.Class = 'Candidate' 	 
</cfquery>

<!--- we show all candidates here now for easy comparison --->

<cfquery name="getCandidates" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   A.*, DC.Status			   
		FROM     DocumentCandidate DC INNER JOIN
                 Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                 Ref_Status S ON DC.Status = S.Status    				   	   
		WHERE    DC.DocumentNo = '#url.documentNo#'		
		AND      S.Class = 'Candidate' 
		AND      DC.Status IN ('#url.wfinal-1#','#url.wfinal#')	 
		ORDER BY CandidateOrder
</cfquery>

<cfif getCandidates.recordcount eq "0">

	<cfquery name="getCandidates" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   A.*, DC.Status			   
		FROM     DocumentCandidate DC INNER JOIN
                 Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
                 Ref_Status S ON DC.Status = S.Status    				   	   
		WHERE    DC.DocumentNo = '#url.documentNo#'		
		AND      S.Class = 'Candidate' 
		AND      DC.Status IN ('#url.wfinal-2#','#url.wfinal#')	 
		ORDER BY CandidateOrder
</cfquery>


</cfif>

<cfoutput>

<form name="recommendation" id="recommendation" style="height:98%">
	
	<table width="96%" height="100%" align="center" border="0">
	
	<tr><td valign="top">
	
	<cf_divscroll>
	
		<table width="98%" border="0">
		
		
		
		 <tr class="fixlengthlist">
		 <td style="font-weight:bold;padding-top:4px;height:35px;font-size:18px;padding-right:10px"><cf_tl id="Reason for recommendation"></td>
		 
		 <td style="font-size:15px;min-width:300px" align="right">	
			Position : #Doc.SourcePostNumber# #Doc.PostGrade# #Doc.FunctionDescription# of #DOC.Mission#/#Doc.OrgUnitNameShort# for fund #doc.Fund#
		</td></tr>
		
		<!--- make listing for this person by excluding existing selections if not '9' --->
		
		<tr class="labelmedium">
		<td colspan="2" style="min-width:260px;padding-top:4px;height:40px;font-size:18px;padding-right:10px">
		<span style="font-size:12px;color:gray">Please briefly explain the selection process and why the candidate is considered to be the most suitable
		for the position based on <cfif get.Gender eq "F">her<cfelse>his</cfif> acquired experience versus the requirements of the job <b>(don't type out the PHP
		but provide a brief assessment on what the candidate brings to the job)</b>. Please describe efforts made to attract a wide pool of female candidates with
		the qualifications and experience for the job.</span>
	    </td>
		</tr>
		
		<tr class="labelmedium">
		<td colspan="2" valign="top" align="center" style="padding-left:5px;padding-top:5px;padding-bottom:8px;padding-right:20px">
		
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
		 
		 <textarea style="padding:5px;border:1px solid silver;background-color:ffffcf;height:68px;width:100%;font-size:13px;" class="regular"  name="ReviewMemo">#Check.ReviewMemo#</textarea>
		
		</td>
		</tr>
		
		<tr class="labelmedium">
		
		<td style="width:80%;font-size:18px" colspan="2">
		   
			<table style="width:100%">
			
			    <tr class="line">
				<td style="font-size:14px;padding-left:4px;width:30px"></td>
				<td style="font-size:14px;padding-left:4px"><cf_tl id="Candidate"></td>
				<td style="font-size:14px;padding-left:4px"><cf_tl id="Select"></td>
				<td style="font-size:14px;padding-left:4px"><cf_tl id="Priority"></td>
			
			    <cfloop query="getCandidates">				
									
					<cfquery name="get" 
						datasource="appsVacancy" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT  A.*, DC.Status, DC.CandidateOrder			   
							FROM    DocumentCandidate DC INNER JOIN
					                Applicant.dbo.Applicant A ON DC.PersonNo = A.PersonNo INNER JOIN
					                Ref_Status S ON DC.Status = S.Status    				   	   
							WHERE   DC.DocumentNo = '#url.documentNo#'		 
							AND     DC.PersonNo   = '#personno#'	
							AND     S.Class = 'Candidate' 	 
					</cfquery>
					
				    <tr class="labelmedium2 line" style="height:30px">
					<td style="padding-left:5px;padding-bottom:3px">
					<input type="radio" class="radiol" <cfif url.personno eq personno>checked</cfif> name="Inspect" value="Inspect" onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateInspection.cfm?documentno=#url.documentno#&PersonNo=#PersonNo#&actioncode=#url.actioncode#','inspectionbox')">
					</td>
					<td style="padding-top:2px;padding-left:14px;font-size:17px">
					#FirstName# #LastName# (#gender#)
					
					<!---
					<select name="candidateselect" class="regularxxl" onchange="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateRecommendation.cfm?wparam=#url.wparam#&DocumentNo=#url.documentNo#&PersonNo='+this.value+'&ActionCode=#url.actioncode#&wfinal=#url.wfinal#&status=#url.status#','decisionbox')">	>
						
							<option value="#PersonNo#" <cfif personNo eq url.personno>selected</cfif>>#FirstName# #LastName#</option>
						
					</select>				
					--->
					</td>
					
					<td style="padding-left:4px;padding-bottom:2px">
					
					<input class = "Radiol" 
					       style = "height:18px;width:18px" 
						   type  = "checkbox" 
						   name  = "ReviewStatus#personno#" id="ReviewStatus#personno#" 
						   onclick="if (this.checked == true) { document.getElementById('person#personno#').className='hide' } else { document.getElementById('person#personno#').className='regular' }" 
						   value = "#url.wFinal#" <cfif get.Status gte url.wFinal>checked</cfif> style="cursor:pointer">					
		    		</td>
					
					<td>
						<table>
						<tr>
						<td id="person#personno#" class="<cfif get.Status gte url.wFinal>hidden</cfif>">
						<select name="priority#personno#" name="priority#personno#" class="regularxxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
						<cfloop index="itm" from="1" to="#recordcount-1#" step="1">
							<option value="#itm#" <cfif get.CandidateOrder eq itm>selected</cfif>>#itm#</option>
						</cfloop>
						</select>
						</td></tr>
						</table>
														
					</td>
					
				    </tr>
				</cfloop>
			</table>
					
		</tr>
		
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
			
				<tr class="labelmedium">				
				<td style="width:80%" colspan="2">				 
				
				 <cfinclude template = "CandidateRecommendationBucket.cfm">			
				
				</td>
				</tr>
			
			</cfif>
		
		</cfif>
		
		<tr><td style="height:2px"></td></tr>		
		
		<tr><td id="inspectionbox" colspan="2">
		
		   <cfinclude template="CandidateInspection.cfm">
			
			</td></tr>
				
		</table>
	
	</cf_divscroll>
	
	</td></tr>
	
	<tr style="height:40px">
	<td colspan="2" align="center" style="padding-top:5px">
		<table class="formspacing">
		<tr>
		<td><input type="button" value="Close" name="Close"   class="button10g" style="font-size:15px;height:28px;width:200px" 
		     onclick="ProsisUI.closeWindow('decisionbox')"></td>
		<td><input type="button" value="Submit" name="Submit" class="button10g" style="font-size:15px;height:28px;width:200px" 
		     onclick="updateTextArea();ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/Recommendation/CandidateRecommendationSubmit.cfm?wparam=#url.wparam#&documentno=#url.documentNo#&personno=#url.personno#&actioncode=#url.actioncode#&wfinal=#url.wfinal#','myprocess','','','POST','recommendation')"></td>
		</tr>
		</table>
	</td></tr>
	
	<tr style="height:10px"><td colspan="2" id="myprocess"></td></tr>
	
	</table>

</form>

</cfoutput>

<script>
	Prosis.busy('no')
</script>

