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

<cfquery name="Rules" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_EntityDocument R
	 WHERE  R.EntityCode = '#Object.EntityCode#'
	 AND    R.Operational = 1
	 AND    R.DocumentType = 'rule'
	 AND    (

	        DocumentId IN (SELECT DocumentId 
	                       FROM   Ref_EntityDocumentMission 
						   WHERE  Mission = '#Object.Mission#')
			OR 
			
			DocumentId NOT IN (SELECT DocumentId 
			                   FROM   Ref_EntityDocumentMission 
							   WHERE  DocumentId = R.DocumentId)			   
			
			)
</cfquery>

<cfset ruleresult     = "1">
<cfset ruleresultmemo = "">

<cfoutput query="Rules">

	<!--- perform the validation --->
	
	<!--- logging --->
	
	<cfquery name="Last" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT TOP 1 *
		 FROM   OrganizationObjectValidation
		 WHERE  ObjectId = '#Object.ObjectId#'
		 ORDER BY ValidationSerialNo DESC		
	</cfquery>
			
	<cfif Last.recordcount eq "0">
	    <cfset ser = "1">
	<cfelse>
	    <cfset ser = last.ValidationSerialNo+1>  
	</cfif>
			
	<cfquery name="Logging" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO OrganizationObjectValidation
			 (ObjectId,
			  ValidationSerialNo,
			  DocumentId,
			  EntityValidationResult,
			  EntityValidationMemo,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		 VALUES
			 ('#Object.EntityCode#,
			  '#ser#',
			  '#documentid#',
			  '#ruleresult#',
			  '#ruleresultmemo#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
		  '#SESSION.first#')		
	</cfquery>
	
	<cfif ruleresult eq "0">
		
		  <cf_message message = "#MessageProcessor#">
		  <cfabort>
	
	</cfif>
	
</cfoutput>
		