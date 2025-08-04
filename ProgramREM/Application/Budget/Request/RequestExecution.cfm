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

<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  ProgramAllotmentRequest
		SET     ExecutionStatus = '#url.status#'
		FROM    ProgramAllotmentRequest		
</cfquery>

<cfoutput>

<cfif url.status eq "0">

	 <cf_img icon="log" onclick="alldetexecution('#requirementid#','3')"
						   tooltip="Pending Execution">
<!---
    <img src="#SESSION.root#/images/pending.png" 
	   style="cursor:pointer" 
	   height="14" 
	   width="14" 
	   onclick="alldetexecution('#url.requirementid#','3')"
	   alt="Pending Execution" 
	   border="0" 
	   align="absmiddle">
	   
	   --->
		   
<cfelse>

	<img src="#SESSION.root#/images/Validate.gif" 
		  onclick="alldetexecution('#url.requirementid#','0')"
		  style="cursor:pointer" alt="Executed" border="0" align="absmiddle">
		  
</cfif>

</cfoutput>