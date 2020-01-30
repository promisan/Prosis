<!--- verify if Submission record submission exists --->

<cfparam name="Form.applicationMemo" default="">
<cfparam name="URL.Verbose"          default="1">
<cfparam name="Client.AppPersonNo"   default="">
<cfparam name="URL.PersonNo"         default="#Client.AppPersonNo#">
<cfparam name="Client.ApplicantNo"   default="">
<cfparam name="URL.ApplicantNo"      default="#Client.ApplicantNo#">
<cfparam name="URL.Status"           default="0">
	
<cftransaction>
	
	<cfquery name="Bucket" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   FunctionOrganization
	   WHERE  FunctionId = '#URL.ID#' 
	</cfquery>
	
	<cfquery name="PHP" 
		datasource="appsSelection"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Parameter
	</cfquery>	
		
	<cfif url.ApplicantNo neq "">
		
		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    ApplicantSubmission
			WHERE   ApplicantNo = '#url.ApplicantNo#' 
		</cfquery>
		
		<cfset url.personNo = verify.PersonNo>
		
	<cfelse>
	
		<cfquery name="Verify" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  ApplicantNo
			FROM    ApplicantSubmission
			WHERE   PersonNo   = '#url.personno#'
			AND     Source     = '#PHP.PHPEntry#' 
		</cfquery>	
	
	</cfif>
		
	<cfif Verify.recordcount eq "0">
	
	<!--- temp measure --->
	     <cfquery name="Last" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT     MAX(ApplicantNo) AS LastNo
	     FROM       ApplicantSubmission
	     </cfquery>
		 
		 <cfif Last.LastNo neq "">
		    <cfset new = Last.LastNo+1>
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
	     FROM Parameter
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
	      VALUES ('#urlPersonNo#',
			      '#LastNo.ApplicantNo#', 
		          '#DateFormat(Now(),CLIENT.DateSQL)#',
				  '0',
				  '#PHP.PHPEntry#',
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
	<cfif URL.Verbose eq 1>
		<cfparam name="Form.FunctionId" type="any" default="">
	<cfelse>
		<cfparam name="Form.FunctionId" type="any" default="#URL.ID#">
	</cfif>
	<cf_RosterActionNo ActionCode="FUN" ActionRemarks="Application"> 
		
	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT FunctionId
		FROM   ApplicantFunction
		WHERE  ApplicantNo = '#appno#' 
		AND    FunctionId = '#URL.ID#'
	</cfquery>
	
	<CFIF Verify.recordCount is 1 > 
	
		<!--- kherrera (2014-11-10):  Buddy System --->
	
		<cfquery name="VerifyWithDraw" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT FunctionId
			FROM   ApplicantFunction
			WHERE  ApplicantNo = '#appno#' 
			AND    FunctionId  = '#URL.ID#'
			AND	   Status      = '8'
		</cfquery>
	
		<cfif VerifyWithDraw.recordCount eq 1>
		
			<cfquery name="Reactivate" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE 	ApplicantFunction
					SET		Status = '0'
					WHERE  	ApplicantNo = '#appno#' 
					AND    	FunctionId = '#URL.ID#'
			</cfquery>
		
		</cfif>
		
		<!--- --------------------- --->
		
	<cfelse>
	
		<cfquery name="InsertFunction" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ApplicantFunction 
			         (ApplicantNo,
					 FunctionId,
					 FunctionDate,
					 Status,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Created)
			  VALUES ('#appno#', 
			      	  '#URL.ID#',
					  getDate(),
					  '#url.status#',
					  '#PHP.PHPEntry#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
		 </cfquery>
	 
	 
	<cfset bucket = left(url.id,8)>
	
	<cfset vDocumentText = "">
	<cfif isDefined("Form.applicationMemo_#bucket#")>
		<cfset vDocumentText = Evaluate("Form.applicationMemo_#bucket#")>
	</cfif>
	 
	<cfquery name="InsertCandidateText" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  ApplicantFunctionDocument
			   (ApplicantNo,
			   FunctionId, 
			   DocumentType,
			   DocumentText,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
		VALUES 
			   ('#appno#',
			   '#URL.ID#',
			   'Cover',
			   '#vDocumentText#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#')
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
		   '#URL.ID#',
		   '#RosterActionNo#',
		   '#url.status#')
	</cfquery> 
	
	</cfif>
	
</cftransaction>
	
<cfoutput>
	<script language="JavaScript">	    
    	$('.clsToggler#url.id#').hide();	
		_cf_loadingtexthtml='';					
		ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Application/getCandidacy.cfm?functionid=#url.id#','c#url.id#');
		if ($('.shortApplyContainer_#url.id#').length == 1) {
			$('.shortApplyContainer_#url.id#').hide();
		}	
	</script>
</cfoutput>
	

