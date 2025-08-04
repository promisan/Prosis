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

<!--- validations for Candidates --->

<cfcomponent>

	<cffunction name    = "getValidationStruct" 
		    access      = "private" 
		    returntype  = "struct">
			
			<cfparam name="ValidationCode"  type="string"  default="">
			<cfparam name="PassCode"     	type="string"  default="No">
			
			<cfquery name="getValidationDefinition"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Validation
					WHERE  ValidationCode = '#ValidationCode#'
			</cfquery>
			
			<cf_tl id="#getValidationDefinition.ValidationTitle#" var="lblVLabel">	
			<cf_tl id="#getValidationDefinition.ValidationInstructions#" var="lblVMemo">	
			
			<cfset vResult.label        = lblVLabel>
			<cfset vResult.passmemo     = lblVMemo>
			<cfset vResult.name         = getValidationDefinition.ValidationName>
			<cfset vResult.pass         = PassCode>
	
			<cfreturn vResult>
			
	</cffunction>
	
	<cffunction name    = "Document" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="PersonNo">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="get"
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT       DocumentType, Description, EnableRemove, EnableEdit, VerifyDocumentNo, DocumentUsage, ListingOrder, OfficerUserId, OfficerLastName, OfficerFirstName, Created
		             FROM         Ref_DocumentType
		             WHERE        (VerifyDocumentNo = '2') AND DocumentType NOT IN
		                             (SELECT        DocumentType
		                               FROM         PersonDocument
		                               WHERE        PersonNo = '#ObjectKeyValue1#' 
									   AND          DependentId IS NULL 
									   AND          ActionStatus <> '9' 
									   AND          DateExpiration IS NULL OR DateExpiration >= GETDATE())
	     	 </cfquery>
			 
			 <cfif get.recordcount gte "1">
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
				
			  </cfif>
			
			  <cfreturn result>		   
			 
	</cffunction>		 
	
	<cffunction name    = "epas" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="ProgramId">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <!---
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			
			<cfquery name="Activity"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ProgramCode	
					FROM   ProgramActivity PA
					WHERE  ProgramCode   = '#get.ProgramCode#' 
					AND	   ActivityPeriod = '#get.Period#'						
					AND    RecordStatus != 9
					AND    EXISTS
						(
							SELECT	'X'
							FROM	ProgramActivityOutput Ox
							WHERE	Ox.ActivityId = PA.ActivityId
							AND		Ox.RecordStatus <> '9'
						)
			</cfquery>
							
			<cfif getProgram.programClass neq "Program" AND Activity.recordcount eq 0>
				
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif>
			
			
			--->
			
			<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			<cfreturn result>
			 	   						 				
	</cffunction>	 	
				
		
</cfcomponent>	
