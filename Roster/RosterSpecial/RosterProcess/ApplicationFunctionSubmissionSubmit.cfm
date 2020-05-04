
<!--- update keywords of the submitted profile by Owner --->


<cfquery name="SubmissionRecords" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT *
		FROM    ApplicantFunctionSubmission
		WHERE   ApplicantNo = '#url.applicantno#'
		AND     Functionid = '#url.functionid#'
</cfquery>

<cfloop query="submissionRecords">
	
	<cfset url.id = submissionid>
	
	<cfquery name="Clear" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE ApplicantFunctionSubmissionField
			SET    Status = '9'
			WHERE  SubmissionId = '#url.id#' 
			AND    Owner = '#url.owner#'
	</cfquery>
		
	<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
	
	<cfset suf = replaceNoCase(url.id,"-","","ALL")>
						
	<cfparam name="form.fieldid_#suf#" default="">	
	<cfset fields = evaluate("form.fieldid_#suf#")>			
							 
	<cfloop index="Item" 
	        list="#fields#" 
	        delimiters="',">
												
				<cfquery name="Check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT   *
					FROM     ApplicantFunctionSubmissionField
					WHERE    SubmissionId      = '#url.id#' 
					AND      ExperienceFieldId = '#Item#'
					AND      Owner             = '#url.owner#'				
				</cfquery>
							
				<cfif Check.recordCount eq "0">
						
					<cfquery name="InsertExperience" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ApplicantFunctionSubmissionField
						         (SubmissionId,							
								 ExperienceFieldId,
								 Owner,
								 Status,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
						  VALUES ('#url.id#', 
						          '#Item#',
								  '#url.owner#',
								  '1',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
					</cfquery>
						  
				<cfelse>
				
					<cfquery name="Clear" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						UPDATE  ApplicantFunctionSubmissionField
						SET     Status = '1'
						WHERE   SubmissionId      = '#url.id#' 
						AND     ExperienceFieldId = '#Item#'
						AND     Owner             = '#url.owner#'			
					</cfquery>
				
				</cfif>
										
	</cfloop>	
			
</cfloop>		

<script>
	Prosis.busy('no')
</script>	

<cfset AjaxOnLoad("function(){refreshkeywords('#url.applicantno#','#URL.functionId#','#url.owner#');}")>

<cfinclude template="ApplicationFunctionSubmission.cfm">