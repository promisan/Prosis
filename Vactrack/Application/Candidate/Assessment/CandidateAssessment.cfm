
<cfparam name="url.objectid"    default="">
<cfparam name="url.documentNo"  default="6276">
<cfparam name="url.actioncode"  default="">
<cfparam name="attributes.ajax" default="yes">

<cfif url.objectid neq "">

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

<cfquery name="Competencies" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  C.*
	FROM    Applicant.dbo.Ref_Competence C
	WHERE   C.Operational = 1 and CompetenceCategory = 'Core'
	<!--- Means that competencies applicable for this track have been defined at the bucket level --->
	<cfif BucketCompetencies.recordcount gt 0>
		AND C.CompetenceId IN (
			#QuotedValueList(BucketCompetencies.CompetenceId)#
		)
	</cfif>
 	ORDER BY C.ListingOrder	
</cfquery>

<cfoutput>

	<cfset w = 100/competencies.recordcount>

	<table border="0" style="width:100%">
	
	<tr class="fixrow">   
	    <td style="background-color:f1f1f1;padding:4px;border:1px solid silver;min-width:140px"><cf_tl id="Officer"></td>
		<cfloop query="Competencies">
		<td style="text-align:center;background-color:f1f1f1;padding:4px;border:1px solid silver;min-width:299px;">#Description#</td>
		</cfloop>
	</tr>
	
	<tr class="hide"><td id="process"></td></tr>
	
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
		
		<td valign="top" style="border-right:1px solid silver;font-size:13px;min-width:10px;padding:4px;<cfif session.acc neq usr>background-color:eaeaea</cfif>">
		
		<cfquery name="user" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			SELECT *
			FROM   UserNames
			WHERE  Account = '#usr#'	
		</cfquery>
		
		#user.lastname#, #user.firstname#</td>
		
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
		
		<td valign="top" style="border-right:1px solid silver;width:100% min-width:200px;padding:2px;">
		
			<table width="100%">
			
			<tr class="line"><td>
			
			<cfset lkt = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Score#url.Personno#_#competenceid#_#usr#','score')">
			<cfset lkm = "savecandidateeval('#url.Objectid#','#url.personno#','#usr#','#url.actioncode#','#competenceid#','Memo#url.Personno#_#competenceid#_#usr#','memo')">
			
			<select name="Score#url.Personno#_#competenceid#_#usr#" class="regularxl" style="border:0px;width:100%" onchange="#lkt#">
			    <option value="0" <cfif get.AssessmentScore eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
				<option value="1" <cfif get.AssessmentScore eq "1">selected</cfif>><cf_tl id="Outstanding"></option>
				<option value="2" <cfif get.AssessmentScore eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
				<option value="3" <cfif get.AssessmentScore eq "3">selected</cfif>><cf_tl id="Partially satisfactory"></option>
				<option value="4" <cfif get.AssessmentScore eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
			</select>
			
			</td></tr>
			
			<tr><td style="min-width:310px">	
			
							
			<cfif Attributes.ajax eq "No">
							
				 <cf_textarea name="Memo#url.Personno#_#competenceid#_#usr#"	onchange="#lkm#"           		 
					 init="Yes"							
					 color="ffffff"	 
					 resize="false"		
					 border="0" 
					 toolbar="Mini"
					 height="70"
					 width="100%">#get.AssessmentMemo#</cf_textarea>
					 
				<cfelse>
				
				 <cf_textarea name="Memo#url.Personno#_#competenceid#_#usr#"	onchange="#lkm#"           		 						 						
					 color="ffffff"	 
					 init="Yes"
					 resize="false"		
					 border="0" 
					 toolbar="Mini" 
					 height="70"
					 width="100%">#get.AssessmentMemo#</cf_textarea>
					 				
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

<cfset ajaxonload("initTextArea")>

