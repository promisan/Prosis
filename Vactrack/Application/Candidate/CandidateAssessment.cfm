
<!--- assessment 

show competencies
show people with access to the step

--->

<cf_screentop layout="webapp" html="No">

<cfparam name="url.documentNo" default="6276">
<cfparam name="attributes.ajax" default="no">

<!--- Are there competencies defined for the bucket linked to this document --->

<cfquery name="Access" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   OrganizationObjectActionAccess
	WHERE  ObjectId = '#Object.ObjectId#'
	AND    ActionCode = '#action.ActionCode#'	
</cfquery>

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

<table style="width:100%" class="formspacing">

<tr class="fixrow">
   
	<cfloop query="Competencies">
	<td style="background-color:f1f1f1;padding:4px;border:1px solid silver;width:#w#%">#Description#</td>
	</cfloop>
</tr>

<cfloop index="usr" list="fodnyhv1,jmukui,administrator">
	
	<tr class="labelmedium">
	<td valign="top" colspan="#competencies.recordcount#" style="font-size:20px;min-width:10px;padding:4px;"><cf_tl id="Assessment">#usr#</b></td>
	</tr>
	
	<tr><td id="process"></td></tr>
	<tr>
	<cfloop query="Competencies">
	
	<cfquery name="get" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT  *
			FROM    DocumentCandidateAssessment
			WHERE   DocumentNo      = '#url.documentno#'
			AND     PersonNo        = '#per#'
		    AND     ActionCode      = '#Action.actioncode#'
			AND     Competenceid    = '#competenceid#'
			AND     OfficerUserid   = '#usr#' 	
			
		</cfquery>
					
	<cfif session.acc eq usr>
	
	<td valign="top" style="width:100% min-width:200px;padding:2px;border:1px solid silver;">
	
	<table width="100%">
	
	<tr class="line"><td>
	
	<cfset lkt = "savecandidateeval('#object.Objectid#','#Per#','#Action.actioncode#','#competenceid#','Score#Per#_#competenceid#_#usr#','score')">
	<cfset lkm = "savecandidateeval('#object.Objectid#','#Per#','#Action.actioncode#','#competenceid#','Memo#Per#_#competenceid#_#usr#','memo')">
	
	<select name="Score#Per#_#competenceid#_#usr#" class="regularxl" style="border:0px;width:100%" onchange="#lkt#">
	    <option value="0" <cfif get.AssessmentScore eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
		<option value="1" <cfif get.AssessmentScore eq "1">selected</cfif>><cf_tl id="Outstanding"></option>
		<option value="2" <cfif get.AssessmentScore eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
		<option value="3" <cfif get.AssessmentScore eq "3">selected</cfif>><cf_tl id="Partially satisfactory"></option>
		<option value="4" <cfif get.AssessmentScore eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
	</select>
	
	</td></tr>
	<tr><td>
		
	<cfif Attributes.ajax eq "No">
					
		 <cf_textarea name="Memo#Per#_#competenceid#_#usr#"	onchange="#lkm#"           		 
			 init="Yes"							
			 color="ffffff"	 
			 resize="false"		
			 border="0" 
			 toolbar="Mini"
			 height="90"
			 width="100%">#get.AssessmentMemo#</cf_textarea>
			 
		<cfelse>
		
		 <cf_textarea name="Body#Per#_#competenceid#_#usr#"	onchange="#lkm#"           		 						 						
			 color="ffffff"	 
			 resize="false"		
			 border="0" 
			 toolbar="Mini" 
			 height="90"
			 width="100%">#get.AssessmentMemo#</cf_textarea>
			 				
		</cfif>	 
	
	</td></tr>	
	 </table>	
		
	 <cfelse>
	
	 <td valign="top" style="width:100% min-width:200px;padding:0px;border:1px solid silver;">
	 <table width="100%">	
	 <tr class="line" style="background-color:<cfif get.AssessmentScore eq "1">ffffaf<cfelse>green</cfif>">
	 <td>
	 <cfswitch expression="#get.AssessmentScore#">
		 <cfcase value="0"><cf_tl id="undefined"></cfcase>
		 <cfcase value="1"><cf_tl id="Outstanding"></cfcase>
		 <cfcase value="2"><cf_tl id="Satisfactory"></cfcase>
		 <cfcase value="3"><cf_tl id="Partially satisfactory"></cfcase>
		 <cfcase value="4"><cf_tl id="Unsatisfactory"></cfcase>
	 </cfswitch>
	 
	 </td></tr>
	 <tr style="background-color:ffffff"><td style="padding:3px">#get.AssessmentMemo#</td></tr>	 
	 </table>
	 
	 
	 </cfif>	
	
	  	
	</td>
	</cfloop>
	</tr>	

</cfloop>

</cfoutput>

</table>

