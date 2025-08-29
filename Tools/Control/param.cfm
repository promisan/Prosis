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
<cfparam name="Attributes.Name"          default="">
<cfparam name="Attributes.Default"       default="">
<cfparam name="Attributes.Validation"    default="0">
<cfparam name="Attributes.Type"          default="String">
<cfparam name="Attributes.MaxLength"     default="">
<cfparam name="Attributes.Notification"  default="message">

<cfif attributes.type neq "UUID">

	<cftry>
		<cfparam name="#Attributes.Name#"     default="#attributes.default#" type="#attributes.type#">
	<cfcatch>
	
			<cf_ErrorInsert	 ErrorSource      = "URL"
				 ErrorReferer     = ""
				 ErrorDiagnostics = "URL parameter #Attributes.Name# value #attributes.default# does not meet type #attributes.type#. #CGI.QUERY_STRING#"
				 Email = "1">
	
			<cf_message status = "#attributes.notification#"
				message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
				
			<cfabort>		
	</cfcatch>
	</cftry>
	
	<cfset VAL=evaluate(attributes.name)>
	
<cfelse>

    <!--- UUID is differente from GUID, need the following conversion  --->
  
    <cfparam name="#Attributes.Name#"     default="#attributes.default#">
  
	<cfset VAL= evaluate(attributes.name)>
	
	<cfif VAL neq "">
		<cfset VAL = Replace(VAL,"-","","ALL")>
		<cfset VAL = Insert("-",VAL,8)>
		<cfset VAL = Insert("-",VAL,13)>
		<cfset VAL = Insert("-",VAL,18)>
	</cfif>
	
</cfif>

		<cfif attributes.type neq "" and VAL neq "">

			<cfif isSimpleValue(VAL)>
			
	           <cfswitch expression="#attributes.type#">
			   
			   <cfcase value="String,Numeric,Float,UUID">					
			   
			   		<cfif FindNoCase("'",VAL)>
					
						<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = " Single quote character found in #VAL#. #CGI.QUERY_STRING#"
								 Email = "1">
					
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>						
					
					</cfif>
			   		<cfif FindNoCase('"',VAL)>
					
						<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = " Double quote character found in #VAL#. #CGI.QUERY_STRING#"
								 Email = "1">
					
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>						
					
					</cfif>
					
			   		<cfif FindNoCase("&##x27;",VAL)>					
										
						<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = " Single quote character found in #VAL#. #CGI.QUERY_STRING#"
								 Email = "1">
					
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>						
					
					</cfif>	
					
			   		<cfif FindNoCase("&quot;",VAL)>
					
						<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = " Double quote character found in #VAL#. #CGI.QUERY_STRING#"
								 Email = "1">
					
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>						
					
					</cfif>															   
			   </cfcase>

			   <cfcase value="date">
			   	
					<cfif NOT isDate(VAL)>
						
						<cf_ErrorInsert	 ErrorSource      = "URL"
							 ErrorReferer     = ""
							 ErrorDiagnostics = "URL parameter #Attributes.Name# value #VAL# does not meet type date. #CGI.QUERY_STRING#"
							 Email = "1">
												 								   			
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>		
				
					</cfif>
				
			   </cfcase>
			   
			   </cfswitch>		
			
			
				<cfif NOT isValid("#Attributes.type#",VAL)>
						
						<cf_ErrorInsert	 ErrorSource      = "URL"
							 ErrorReferer     = ""
							 ErrorDiagnostics = "URL parameter #Attributes.Name# value #VAL# does not meet type #attributes.type#. #CGI.QUERY_STRING#"
							 Email = "1">
												 								   			
						<cf_message status = "#attributes.notification#"
							message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
							
						<cfabort>		
				
				</cfif>
			</cfif>
		</cfif>

<cfif attributes.validation eq "1" or left(attributes.name,4) eq "url.">

		<cfquery name="Check" 
		datasource="AppsSystem">
			SELECT *
			FROM   SyntaxVerification
			WHERE  SecurityClass = 'URL' 
		</cfquery>		
				
		<cfloop query="Check">
																		
			<cfif FindNoCase("#VerificationString#", VAL)>			
								 
				<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = "Syntax Pattern: #VerificationString# is met by: #VAL#"
								 Email = "1">
													 								   			
				<cf_message status = "#attributes.notification#"
					message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
					
				<cfabort>
			
			</cfif>
	
		</cfloop>

</cfif>

