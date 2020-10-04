
<!--- About this presentation
this evaluation screen is based on either competencies enabled for the bucket or works on the topics set for the bucket --->

<cfparam name="url.objectid"    default="">
<cfparam name="url.documentNo"  default="6276">

<!--- About this presentation
this evaluation screen is based on either competencies enabled for the bucket or works on the topics set for the bucket --->

<cfparam name="url.actioncode"  default="">

<!--- About this presentation
this evaluation screen is based on either competencies enabled for the bucket or works on the topics set for the bucket --->
<cfparam name="url.modality"    default="Interview">  <!--- interview | test (phrases) --->

<cfparam name="attributes.ajax" default="yes">

<cfif url.objectid neq "">

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
		
		<!--- only relevant competencies --->
		
		<cfquery name="Competencies" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  C.*
			FROM    Applicant.dbo.Ref_Competence C
			WHERE   C.Operational = 1 
			<!--- Means that competencies applicable for this track have been defined at the bucket level --->
			<cfif BucketCompetencies.recordcount gt 0>
				AND C.CompetenceId IN (
					#QuotedValueList(BucketCompetencies.CompetenceId)#
				)
			<cfelse>
			AND    CompetenceCategory = 'Core'	
			</cfif>
		 	ORDER BY C.ListingOrder	
		</cfquery>
		
<cfelse>
	
	<cfquery name="Competencies" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     TopicId as CompetenceId, TopicSubject as Description, TopicRatingScale, TopicRatingPass
		FROM       FunctionOrganizationTopic
		WHERE 	   FunctionId IN (SELECT FunctionId 
		                          FROM   Functionorganization 
								  WHERE   Documentno = '#url.documentno#')           
		AND        Operational = 1 
		ORDER BY   TopicOrder
	</cfquery>
	
	<!--- continue --->

</cfif>		

<cfif Competencies.recordcount eq "0">

	<table border="0" style="width:100%" align="center">
	<tr class="labelmedium"><td><font color="FF0000">No evaluation topics have been set. Please contract your administrator</td></tr>
	</table>

<cfelse>

<cfoutput>

	<cfset w = 100/competencies.recordcount>
	
	<table border="0" style="width:100%">
	
	<tr class="fixrow">   
	    <td style="background-color:f1f1f1;padding:4px;border:1px solid silver;min-width:140px"><cf_tl id="Evaluation by"></td>
		<cfloop query="Competencies">
		<td style="text-align:center;background-color:f1f1f1;padding:4px;border:1px solid silver;min-width:140px">#Description#</td>
		</cfloop>
	</tr>
	
	<tr class="xhide"><td id="process"></td></tr>
	
	<cfquery name="Access" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT U.Account
		FROM   OrganizationObjectActionAccess OOA INNER JOIN System.dbo.UserNames U ON OOA.UserAccount = U.Account
		WHERE  ObjectId   = '#url.ObjectId#'
		AND    ActionCode = '#url.ActionCode#'	
		UNION 
		SELECT DISTINCT U.Account 
		FROM   Vacancy.dbo.DocumentCandidateAssessment OOA INNER JOIN System.dbo.UserNames U ON OOA.OfficerUserId = U.Account
		WHERE  DocumentNo  = '#url.documentno#'
		AND    ActionCode  = '#url.ActionCode#'	
	</cfquery>
	
	<cfif access.recordcount eq "0">
		<cfset teamlist = client.acc>
	<cfelse>
		<cfset teamlist = ValueList(Access.Account)>
	</cfif>
	
	<cfloop index="usr" list="#teamlist#">
	
		<tr class="labelmedium line">	
		
		<td valign="top" style="width:200px;max-width:200px;border-right:1px solid silver;font-size:13px;min-width:10px;padding:4px;<cfif session.acc neq usr>background-color:eaeaea</cfif>">
		
		<cfquery name="user" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT *
			FROM   UserNames
			WHERE  Account = '#usr#'	
		</cfquery>
		
		<table style="width:100%"><tr><td>
		#user.lastname#, #user.firstname#</td>
		</tr>
		
		<cfif session.acc eq usr>
			<tr><td style="padding-top:7px" align="center">
		   <button type="button" class="button10g" style="height:62px;width:100px" onclick="testevaluation('#url.documentno#','#url.personno#','#url.actioncode#','view','#url.modality#')">
			<img src="#session.root#/images/logos/system/test.png" style="height:50px;width:50px" alt="" border="0">
			</button>
			</td>
			</tr>
		</cfif>		
		
		</td></tr></table>
		
		</td>
		
		<cfloop query="Competencies">
		
		<cfquery name="get" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT  *
				FROM    DocumentCandidateAssessment
				WHERE   DocumentNo      = '#url.documentno#'
				AND     PersonNo        = '#url.personno#'
			    AND     ActionCode      = '#url.actioncode#'
				AND     Competenceid    = '#competenceid#'
				AND     OfficerUserid   = '#usr#' 	
				
			</cfquery>
						
		<cfif session.acc eq usr>
		
		<td valign="top" style="border-right:1px solid silver;min-width:100px">
		
			<table width="100%">
			
			<tr class="line"><td>
						
			<cfif url.modality eq "Interview">
			
			<cfset lkt = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Score#url.Personno#_#left(competenceid,8)#_#usr#','score','#url.modality#')">
						
			<!--- test score --->
			<select id="Score#url.Personno#_#competenceid#_#usr#" name="Score#url.Personno#_#competenceid#_#usr#" class="regularxl" 
			  style="border:0px;width:100%" onchange="#lkt#">
			    <option value="0" <cfif get.AssessmentScore eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
				<option value="1" <cfif get.AssessmentScore eq "1">selected</cfif>><cf_tl id="Outstanding"></option>
				<option value="2" <cfif get.AssessmentScore eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
				<option value="3" <cfif get.AssessmentScore eq "3">selected</cfif>><cf_tl id="Partially satisfactory"></option>
				<option value="4" <cfif get.AssessmentScore eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
			</select>
			
			<cfelse>
			
			<cfset lkt = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Score#url.Personno#_#left(competenceid,8)#_#usr#','score','#url.modality#')">
						
			<select id="Score#url.Personno#_#left(competenceid,8)#_#usr#" name="Score#url.Personno#_#left(competenceid,8)#_#usr#" class="regularxl" style="height:36px;font-size:25px;border:0px;width:100%" onchange="#lkt#">
					<option value="0" selected><cf_tl id="Not applicable"></option>
				    <cfloop index="itm" from="#topicRatingScale#" to="1" step="-1">
					   <option value="#itm#" <cfif get.AssessmentScore eq itm>selected</cfif>>#itm#</option>
					</cfloop>					
			</select>						
			
			</cfif>
			
			</td></tr>
									
			<tr><td style="min-width:210px">
								
			<cfif url.modality eq "Interview">
			
				<cfset lkm = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Memo#url.Personno#_#competenceid#_#usr#','memo','#url.modality#')">
												
				<textarea id="Memo#url.Personno#_#competenceid#_#usr#" 
				   name="Memo#url.Personno#_#competenceid#_#usr#"	
				   onchange="#lkm#"
				   style="border:0px;background-color:ffffef;font-size:13px;padding:3px;resize: none;width:100%;height:70px">#get.AssessmentMemo#</textarea>
				   
			<cfelse>
			
				<cfset lkm = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Memo#url.Personno#_#left(competenceid,8)#_#usr#','memo','#url.modality#')">
						
				<textarea id="Memo#url.Personno#_#left(competenceid,8)#_#usr#" 
				   name="Memo#url.Personno#_#left(competenceid,8)#_#usr#"	
				   onchange="#lkm#"
				   style="border:0px;background-color:ffffef;font-size:13px;padding:3px;resize: none;width:100%;height:70px">#get.AssessmentMemo#</textarea>
			
			
			</cfif>	   
			
				</td></tr>	
			 </table>	
				 
		 </td>		 
			
		 <cfelse>
		
		 <td valign="top" style="border-right:1px solid silver;padding:0px;<cfif session.acc neq usr>background-color:eaeaea</cfif>">
		 
			 <table width="100%">			 
			 <tr style="height:27px;background-color:<cfif get.AssessmentScore neq "1">ffffaf<cfelse>lime</cfif>">
			 <td style="padding-left:4px">
			 <cfswitch expression="#get.AssessmentScore#">
				 <cfcase value="0"><cf_tl id="undefined"></cfcase>
				 <cfcase value="1"><cf_tl id="Outstanding"></cfcase>
				 <cfcase value="2"><cf_tl id="Satisfactory"></cfcase>
				 <cfcase value="3"><cf_tl id="Partially satisfactory"></cfcase>
				 <cfcase value="4"><cf_tl id="Unsatisfactory"></cfcase>
			 </cfswitch>
			 
			 </td></tr>
			 
			 <cfif len(get.AssessmentMemo) gte "5">			 
				 <tr><td style="padding:3px">#get.AssessmentMemo#</td></tr>	 			 
			 </cfif>
			 
			 </table>
		 
		 </td>
		 	 
		 </cfif>	 	
		
		</cfloop>
		
		</tr>	
	
	</cfloop>
	
	</table>
	
		
	</cfoutput>
	
	</cfif>

</cfif>

<!---
<cfset ajaxonload("initTextArea")>
--->

