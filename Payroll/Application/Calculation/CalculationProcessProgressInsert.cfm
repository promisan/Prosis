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
<cfoutput>
	
	<cfparam name="Attributes.ProcessNo"      default="">
	<cfparam name="Attributes.ProcessBatchId" default="">
	<cfparam name="Attributes.StepStatus"     default="0">
	<cfparam name="Attributes.StepException"  default="">
	
	<cfif attributes.ProcessBatchId neq "">
		
		<cfquery name="Last" 
			datasource="appsPayroll" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   CalculationLogDetail
			WHERE  ProcessNo = '#Attributes.ProcessNo#'
			AND    ProcessBatchId = '#Attributes.ProcessBatchId#'
			ORDER BY StepSerialNo DESC
		</cfquery>
		
		<cfif last.StepSerialNo eq "">
			<cfset l = 1>
		<cfelse>	
			<cfset l = Last.StepSerialNo + 1>
		</cfif>	
				
		<cfquery name="LogStep" 
			datasource="appsPayroll"			 
 			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO CalculationLogDetail   
			       	   (ProcessNo,
					    ProcessBatchId, 
					    StepSerialNo,
					    StepTimeStamp,				
						StepDescription,
						StepStatus,
						StepException) 
			VALUES ('#attributes.ProcessNo#',
			        '#Attributes.ProcessBatchId#',
			        '#l#',
			        getDate(),			
					'#attributes.Description#',
					'#Attributes.StepStatus#',
					'#Attributes.StepException#')
		</cfquery>
		
	</cfif>

</cfoutput>