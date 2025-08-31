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
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'	
</cfquery>

<cfloop index="Rec" from="1" to="#form.line#">

    <cfparam name="FORM.progressstatus_#Rec#" default="0">
	
	<cfset progressstatus      = Evaluate("FORM.progressstatus_" & #Rec#)>
	<cfset progressmemo        = Evaluate("FORM.progressmemo_" & #Rec#)>
	<cfset progressstatusdate  = Evaluate("FORM.progressstatusdate_" & #Rec#)>
    <cfset revisedoutputdate   = Evaluate("FORM.revisedoutputdate_" & #Rec#)>
	 <cfset percentage         = Evaluate("FORM.percentage_" & #Rec#)>
	
	<cfset dateValue = "">
	  <CF_DateConvert Value="#progressstatusdate#">
	  <cfset DTE = dateValue>
	  
	 <cfif not isDate(DTE)>
	     <cf_alert message = "You entered an invalid date : #progressstatusdate#"
		  return = "back">
		  <cfabort>
	 </cfif>
	 
	  <cfif not isNumeric(percentage)>
	     <cf_alert message = "You entered an invalid percentage : #percentage#"
		  return = "back">
		  <cfabort>
	 </cfif>
  
	 <cfset dateValue = "">
	 <cfif revisedoutputdate neq "">
	    	 
			 <CF_DateConvert Value="#revisedoutputdate#">
		     <cfset RDTE = #dateValue#>
			 
			 <cfif not isDate(RDTE)>
		      <cf_alert message = "Your entered an invalid date : #revisedoutputdate#"
			  return = "back">
			  <cfabort>
	  		 </cfif>
	 </cfif>	 
		
	<cfif Len(progressmemo) gt 450>
    	 <cf_alert message = "Your entered a memo that exceeded the allowed size of 450 characters."
		  return = "back">
		  <cfabort>
	</cfif>
			
	<cfif Parameter.ProgressMemoEnforce eq "1">
				
		<cfif ProgressStatus neq "0">
			
	    	<cfif Progressmemo eq "">
			       
	           <cf_alert message = "You have submitted one or more progress reports without providing additional clarification [Memo]. <p></p>Please update."
	            return = "back">
	
	           <cfabort>
			 		   
	     	</cfif>
				
		</cfif>
		
	</cfif>
		
</cfloop>


<cftransaction action="BEGIN">
 
<cfloop index="Rec" from="1" to="#form.line#">

  <cfset programcode         = Evaluate("FORM.programcode_" & #Rec#)>
  <cfset activityperiod      = Evaluate("FORM.activityperiod_" & #Rec#)>
  <cfset outputid            = Evaluate("FORM.outputid_" & #Rec#)>
  <cfset attach              = Evaluate("FORM.attach_" & #Rec#)>
  <cfset progressstatusdate  = Evaluate("FORM.progressstatusdate_" & #Rec#)>
  <cfset revisedoutputdate   = Evaluate("FORM.revisedoutputdate_" & #Rec#)>
  <cfset percentage          = Evaluate("FORM.percentage_" & #Rec#)>
        
  <cfset dateValue = "">
  <CF_DateConvert Value="#progressstatusdate#">
  <cfset DTE = #dateValue#>
  
  <cfset dateValue = "">
  <cfif revisedoutputdate neq "">
     <CF_DateConvert Value="#revisedoutputdate#">
     <cfset RDTE = #dateValue#>
  <cfelse>
     <cfset RDTE = 'NULL'>
  </cfif>	 
        
  <cfset progressstatus      = Evaluate("FORM.progressstatus_" & #Rec#)>
  
  <cfif progressstatus lt "2">
     <cfset RDTE = 'NULL'>
  </cfif>
  
  <cfset progressmemo        = Evaluate("FORM.progressmemo_" & #Rec#)>
    
  		<cfquery name="Status" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM    Ref_Status
			WHERE   ClassStatus = 'Progress'
			AND     Status = '#ProgressStatus#'
		</cfquery>
				
		<cfif Parameter.ProgressCompleted eq Status.PointerDate>
		  <cfset perc = 100>
		<cfelseif progressstatus eq "0">
		  <cfset perc = 0>
		<cfelse>
		  <cfset perc = percentage>  
		</cfif>   	

		<!--- check if record already exists in order to update and not to add --->
		
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
			SELECT  *
			FROM    ProgramActivityProgress 
			WHERE   OutputId = '#OutputId#'
			AND     ActivityPeriod = '#ActivityPeriod#'
			AND     ProgressStatus = '#progressstatus#'
			AND     ProgressStatusDate = #dte#
			AND     RecordStatus <> '9'
			ORDER BY Created DESC
		</cfquery>
		
		<cfif Check.recordcount gt 0 and ProgressStatus eq "0">
		
		<cfelse>
		
				<cfif Check.progressstatus eq ProgressStatus and Parameter.ProgressTransactional eq "0">
				
					<cfquery name="Update" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE ProgramActivityProgress  
						SET   ProgressStatusDate = #dte#,
						      RevisedOutputDate  = #rdte#,
						      ProgressStatus     = '#ProgressStatus#',
							  ProgressMemo       = '#ProgressMemo#', 
							  OutputCompletion   = '#perc#',
							  AttachmentId       = '#attach#',
							  OfficerUserId      = '#SESSION.acc#',
							  OfficerLastName    = '#SESSION.last#', 
							  OfficerFirstName   = '#SESSION.first#',
							  Created            = getDate()
						WHERE ProgressId = '#Check.ProgressId#'	
						AND   OutputId   = '#check.OutputId#'	  
					</cfquery>	
							
				<cfelse>			
				 
					<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramActivityProgress  
					         (ProgramCode, 
							  ActivityPeriod,
							  OutputId, 					
							  ProgressStatusDate,
							  RevisedOutputDate,
							  OutputCompletion,
							  ProgressStatus,
							  ProgressMemo,		
							  AttachmentId,			 
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					  VALUES ('#programcode#', 
					          '#activityperiod#',
					          '#outputid#',					
					          #dte#,  
							  #rdte#,
							  '#perc#',
							  '#progressstatus#',
							  '#progressmemo#',		
							  '#attach#',			 
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					</cfquery>	
					
				</cfif>
				
		</cfif>		
  
</cfloop>

</cftransaction>

<cfoutput>

<cfif url.mode eq "Edit">

	<script>
	    opener.progressreportrefresh('#activityid#')		
		window.close()
	</script>

<cfelse>
		
	<script>
		ColdFusion.navigate('#SESSION.root#/programrem/application/activity/progress/ActivityProgressOutput.cfm?mode=#url.mode#&mission=#url.mission#&activityid=#activityId#','box#activityid#')
	</script>
	
</cfif>

</cfoutput>
