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


<cfquery name="Check3" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	SELECT *
	FROM ProgramAudit.dbo.AuditObservationRecommendation  
	WHERE AuditId = '#Form.AuditId#'	
	and ObservationId='#Form.ObservationId#'	
	and RecommendationId='#Form.RecommendationId#'	
</cfquery>	
	
<cfif #Check3.recordcount# eq 0>

	    <cfquery name="InsertAuditRecommendation" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ProgramAudit.dbo.AuditObservationRecommendation
 	        (AuditId,ObservationId,RecommendationId,
			 Description,
		     Reference,
			 TargetDate,
 			 ImplementationDate,
			 status,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Created)
	   	 VALUES ('#Form.AuditId#',
			  '#Form.ObservationId#',
			  '#Form.RecommendationId#',
			  '#Form.Description#',
			  '#Form.reference#',
  			  '#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
  			  '#DateFormat(Form.ImplementationDate,CLIENT.dateSQL)#',
			  '#Form.status#',
			  '#SESSION.acc#',
   		 	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
        </cfquery>
<cfelse>
		<cfquery name="Update" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	UPDATE ProgramAudit.dbo.AuditObservationRecommendation
         SET 
		  Description='#Form.Description#',
		  Reference='#Form.Reference#',
		  TargetDate='#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
		  ImplementationDate='#DateFormat(Form.TargetDate,CLIENT.dateSQL)#',
  		  status='#form.status#'
	Where AuditId='#Form.AuditId#'
	and ObservationId='#Form.ObservationId#'
	and RecommendationId='#Form.RecommendationId#'
	</cfquery>		
		
</cfif>

<script>
window.opener.location.reload();

</script>
<cflocation url="RecommendationEntry.cfm?AuditId=#Form.AuditId#&ObservationId=#Form.ObservationId#&crow=#Form.crow#" addtoken="No">		  


