
 
<!--- verify if Submission record submission exists --->

<cfquery name="Bucket" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionOrganization
	WHERE  FunctionId = '#URL.IDFunction#'
</cfquery>

<cfquery name="Person" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Applicant
	WHERE  PersonNo = '#URL.PersonNo#'
</cfquery>

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ApplicantNo
	FROM   ApplicantSubmission
	WHERE  PersonNo = '#URL.PersonNo#'
	<!--- limit creation
	AND SubmissionEdition = '#Bucket.SubmissionEdition#' 
	--->
</cfquery>

<cfif Person.recordcount eq "1">
	
	<cfif Verify.recordcount eq "0">
	
	<!--- temp measure --->
	     <cfquery name="Last" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	SELECT   MAX(ApplicantNo) AS LastNo
		    FROM     ApplicantSubmission
	     </cfquery>
		 
		 <cfif Last.LastNo neq "">
		    <cfset new = #Last.LastNo#+1>
		 <cfelse>	
		    <cfset new = "1">
		 </cfif> 
	
	   <cfquery name="AssignNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     UPDATE Parameter SET ApplicantNo = #new#
	     </cfquery>
	
	     <cfquery name="LastNo" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     	 SELECT *
		     FROM   Parameter
		 </cfquery>
	 
	      <!--- Submit submission --->
	
	     <cfquery name="InsertApplicant" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ApplicantSubmission
	         (PersonNo,
			 ApplicantNo,
	  		 SubmissionDate,
			 ActionStatus,
			 Source,
			 SubmissionEdition,
			 eMailAddress,
			 LanguageId,
		 	 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.PersonNo#',
		       '#LastNo.ApplicantNo#', 
	           '#DateFormat(Now(),CLIENT.DateSQL)#',
			  '0',
			  'Manual',
			  '#Bucket.SubmissionEdition#',
			  '',
			  '001',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	     </cfquery>
		 
		 <cfset appno = LastNo.ApplicantNo>
	
	<cfelse> 
	     <cfset appno = Verify.ApplicantNo>
	</cfif>
	   
	<!--- Update Function --->   
	
	<cfparam name="Form.FunctionId" type="any" default="">
	
	<cf_RosterActionNo ActionCode="FUN" ActionRemarks="Manual Entry"> 
		
	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT FunctionId
	FROM   ApplicantFunction
	WHERE  ApplicantNo = '#AppNo#' 
	AND    FunctionId = '#URL.IDFunction#'
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
		  VALUES ('#AppNo#', 
		      	  '#URL.IDFunction#',
				  '0',
				  'Manual',
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
		   ('#AppNo#',
		   '#URL.IDFunction#',
		   '#RosterActionNo#',
		   '0')
	</cfquery> 
	
	<cf_tl id="Candidate recorded" var="1">
		
	<cfoutput>	
		<script>
			alert("#lt_text#")
		</script>
	</cfoutput>
	
	</cfif>

</cfif>
	
<cfset url.box     = "manual">
<cfset url.source  = "manual">
<cfset url.filter  = "0">
<cfset url.total   = "0">
<cfinclude template="FunctionViewListing.cfm">



