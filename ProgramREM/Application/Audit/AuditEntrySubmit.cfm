<!--
    Copyright © 2025 Promisan

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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.EditCode" default="">


<cfif Len(#Form.AuditNo#) eq 0>
	 <cf_message message = "Your entered an invalid project name"
	  return = "back">
	  <cfabort>
</cfif>

<cfif Len(#Form.AuditObjective#) gt 400>
	 <cf_message message = "Your entered a description that exceeded the allowed size of 400 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfif Len(#Form.AuditDescription#) gt 500>
	 <cf_message message = "Your entered an description that exceeded the allowed size of 400 characters."
	  return = "back">
	  <cfabort>
</cfif>


<!--- verify if Auditrecord exist --->

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ProgramAudit.dbo.Audit
	WHERE  AuditNo = '#Form.AuditNo#'
</cfquery>

<cfparam name="Audit.RecordCount" default="0">

<cfif #Audit.recordCount# neq 0 and #URL.editcode# eq "">			<!--- Audit exists --->

	<cfif Audit.RecordStatus neq 9 >        <!--- not deleted so alert to error --->
		  
       <cf_message message = "A Audit #Form.AuditId# was already registered ."
        return = "back">
        <cfabort>

	</cfif>

<cfelse>			<!--- New Audit --->

  <cfquery name="Check" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	SELECT *
	FROM ProgramAudit.dbo.Audit  
	WHERE AuditId = '#Form.AuditId#'	
	</cfquery>	
	
	<cfif #Check.recordcount# eq 0>
       <cf_message message = "You should define at least one recommendation to proceed"
        return = "back">
        <cfabort>
	
	<cfelse>
	
 

			
	    <cfquery name="UpdateAudit" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ProgramAudit.dbo.Audit
 	        SET 
			 Period         = '#Form.Period#',
			 OrgUnit        = '#Form.OrgUnit#',
			 AuditNo        = '#Form.AuditNo#',
			 Description    = '#Form.AuditDescription#',
	    	 Objective      = '#Form.AuditObjective#',
		     Reference      = '#Form.Reference#',
			 AuditDateStart = '#DateFormat(Form.AuditDateStart,CLIENT.dateSQL)#',
			 AuditDateEnd   = '#DateFormat(Form.AuditDateEnd,CLIENT.dateSQL)#'
		Where
			AuditId='#URL.AuditId#'
        </cfquery>
		
		<script>
			window.close();
			opener.history.go(); 
		</script>	
		</cfif>
</cfif>
	 
