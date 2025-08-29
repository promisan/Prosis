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
<cfparam name="url.owner" default="">
<cfparam name="url.currentStatus" default="">
<cfparam name="url.status" default="">

<!--- parameters to be used by the validation template ---->
<cfparam name="url.ApplicantNo" default="">
<cfparam name="url.FunctionId"  default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="UserAccess" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT MAX(AccessLevel) AS AccessLevel
			FROM   RosterAccessAuthorization
			WHERE  FunctionId    = '#url.FunctionId#'
			AND    UserAccount   = '#SESSION.Acc#'
			
</cfquery>

<cfquery name="Ref_Rule" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT R.*
			FROM   Ref_StatusCodeProcess P
				   INNER JOIN Ref_Rule R ON P.RuleCode = R.Code
			WHERE  P.Owner     = '#url.owner#'
			AND    P.Status    = '#url.currentStatus#'
			AND    P.StatusTo  = '#url.status#'
			AND    AccessLevel = '#UserAccess.AccessLevel#'
		 
</cfquery>

<cfoutput>


<cfif Ref_Rule.recordcount eq 1>

	<cfset ApplicantNo = url.ApplicantNo>
	<cfset FunctionId  = url.FunctionId>
	<!--- validation template should take care of result: Result = 1 - allow to process, 2 - allow to process but show message, 9 - do not allow to process--->
	<cfset Result 	   = 9> 
	
	<cfset template = "../../../#Ref_Rule.ValidationPath##Ref_Rule.ValidationTemplate#">
	<cfset template = replace(template,"\","/","ALL")>
	
	<!--- Standard variables passed to the validation template --->
	<cfset ApplicantNo = url.ApplicantNo>
	<cfset FunctionId  = url.FunctionId>
	<cfset Rule		   = Ref_Rule.Code>
	
	<cfinclude template="#template#">

	<cfif Result eq 9 or Result eq 2>
	
		<!--- customMessage should be declared in the custom rule--->
		<cfparam name="customMessage" default="">
		
		<cfif customMessage neq "">
			<cfset message = Ref_Rule.MessagePerson & "<br>" & customMessage>
		<cfelse>
			<cfset message = Ref_Rule.MessagePerson>
		</cfif>
	
		<cf_message message="#message#" return="No">
	
	</cfif>
	
	<cfif Result eq 9>
		
		<script>
			savePanel('hide');
		</script>
		
	<cfelse>
		
		<!--- if everything ok, display reason form ---->
		<cfset status = url.status>
		<cfset owner  = url.owner>
		<cfinclude template="ApplicationFunctionEditReason.cfm">
		
		<script>
			savePanel('show');
		</script>
		
	</cfif>

<cfelse> <!--- No rule was found --->

	<!--- display reason form ---->
	<cfset status = url.status>
	<cfset owner  = url.owner>
	<cfinclude template="ApplicationFunctionEditReason.cfm">

	<script>
		savePanel('show');
	</script>

</cfif>

</cfoutput>