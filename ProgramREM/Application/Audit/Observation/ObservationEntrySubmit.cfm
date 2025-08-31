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
<cfif Len(#Form.Description#) gt 400>
  <cfset Description = left(#Form.Description#,400)>
<cfelse>
  <cfset Description = #Form.Description#>
</cfif>  

  <cfquery name="Check" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	SELECT *
	FROM ProgramAudit.dbo.Audit  
	WHERE AuditId = '#Form.AuditId#'	
</cfquery>	

  <cfquery name="Check2" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	SELECT *
	FROM ProgramAudit.dbo.AuditObservation  
	WHERE AuditId = '#Form.AuditId#'	
	and ObservationId='#Form.ObservationId#'	
</cfquery>	
	
<cfif #Check.recordcount# eq 0>

	    <cfquery name="InsertAudit" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ProgramAudit.dbo.Audit
 	        (AuditId,
			 Period,
			 OrgUnit,
			 AuditNo,
			 Description,
	    	 Objective,
		     Reference,
			 AuditDateStart,
			 AuditDateEnd,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Created)
	   	 VALUES ('#Form.AuditId#',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '',
			  '#SESSION.acc#',
   		 	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
        </cfquery>

</cfif>


<cfif #Check2.recordcount# eq 0>

<cfquery name="Insert" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
INSERT INTO ProgramAudit.dbo.AuditObservation
         (AuditId,
		  ObservationId,
		  Description,
		  Reference,
		  Area,
		  TargetDate,
		  ImplementationDate,
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
  VALUES ( '#Form.AuditId#',
		  '#Form.ObservationId#',
		  '#Form.Description#',
  		  '#Form.Reference#',
		  '#Form.Area#',
		  '#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
		  '#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#',
		  getDate())
</cfquery>		

<cfset action="#Form.ObservationId#">

<cfelse>

<cfquery name="Update" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
UPDATE ProgramAudit.dbo.AuditObservation
         SET 
		  Description='#Form.Description#',
		  Reference='#Form.Reference#',
		  Area='#Form.Area#',
		  TargetDate='#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
		  ImplementationDate='#DateFormat(Form.TargetDate,CLIENT.dateSQL)#'
Where AuditId='#Form.AuditId#'
and ObservationId='#Form.ObservationId#'
</cfquery>		


<cfset action="">

</cfif>

<cfif #action# eq "">
	<cflocation url="ObservationEntry.cfm?AuditId=#Form.AuditId#" addtoken="No">		  
<cfelse>
	<cflocation url="ObservationEntry.cfm?AuditId=#Form.AuditId#&action=#action#" addtoken="No">		  
</cfif>


