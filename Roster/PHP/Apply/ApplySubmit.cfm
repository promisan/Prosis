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
<cfparam name="Form.applicationMemo" default="">
<cfparam name="URL.Verbose"          default="1">
<cfparam name="Client.AppPersonNo"   default="">
<cfparam name="URL.PersonNo"         default="#Client.AppPersonNo#">
<cfparam name="Client.ApplicantNo"   default="">
<cfparam name="URL.ApplicantNo"      default="#Client.ApplicantNo#">
<cfparam name="URL.Status"           default="0">

<cfif Url.Verbose eq "1">
	<TITLE>Submit Interest for a job</TITLE>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</cfif>
	
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
			   '#Form.applicationMemo#',
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

<cfif Url.Verbose eq "1">
	
	<cfoutput>
		<script language="JavaScript">
	    	document.getElementById("a#url.id#").className = "hide"
			document.getElementById("v#url.id#").className = "hide"		
			ColdFusion.navigate('#SESSION.root#/Roster/PHP/Apply/Candidacy.cfm?functionid=#url.id#','c#url.id#')		
		</script>
	</cfoutput>

</cfif>	

