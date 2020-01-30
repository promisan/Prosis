

<!--- add / update the bucket --->
 
<!--- verify if Submission record submission exists --->

<cfparam name="Form.FunctionId" default="">

<cfif form.FunctionId neq "">

<cfquery name="Bucket" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionOrganization
	WHERE  FunctionId = '#form.FunctionId#'
</cfquery>
	
<cf_RosterActionNo ActionCode="FUN" ActionRemarks="Portal Entry"> 
		
<cfquery name="RemovePrevious" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE 	ApplicantFunction
	WHERE  	ApplicantNo = '#url.applicantno#' 
	AND		Source = 'Assignment'
</cfquery>
		
<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT FunctionId
	FROM   ApplicantFunction
	WHERE  ApplicantNo = '#url.applicantno#' 
	AND    FunctionId  = '#form.FunctionId#'
</cfquery>
	
	<CFIF Verify.recordCount is 1 > 
		
		<!--- 
		do nothing, already registered
		--->
		
	<cfelse>
		
		<cfquery name="InsertFunction" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO dbo.[ApplicantFunction] 
			         (ApplicantNo,
					 FunctionId,
					 Status,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Created)
			  VALUES ('#url.applicantno#', 
			      	  '#form.FunctionId#',
					  '3',
					  'Assignment',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
		 </cfquery>
		 
		<cfquery name="UpdateFunctionStatusAction" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO  ApplicantFunctionAction
				   (ApplicantNo,
				   FunctionId, 
				   RosterActionNo, 
				   Status)
			VALUES 
				   ('#url.applicantno#',
				   '#form.FunctionId#',
				   '#RosterActionNo#',
				   '0')
		</cfquery> 
		
	</cfif>

</cfif>

<cf_Navigation
	 Alias         = "AppsSelection"
	 TableName     = "ApplicantSubmission"
	 Object        = "Applicant"
	 ObjectId      = "No"
	 Group         = "PHP"
	 Section       = "#URL.Section#"
	 SectionTable  = "Ref_ApplicantSection"
	 Id            = "#URL.ApplicantNo#"
	 Owner         = "#URL.Owner#"
	 BackEnable    = "1"
	 HomeEnable    = "1"
	 ResetEnable   = "1"
	 ResetDelete   = "0"	
	 ProcessEnable = "0"
	 NextEnable    = "1"
	 NextSubmit    = "1"
	 Reload        = "1"
	 OpenDirect    = "1"
	 SetNext       = "1"
	 NextMode      = "1"
	 IconWidth 	  = "32"
	 IconHeight	  = "32">
	