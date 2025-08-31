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
<cfquery name="get" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ProgramPeriod
	WHERE  ProgramId = '#URL.programid#'	
</cfquery>

<cfquery name="qCheck" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ContributionProgram
	WHERE  ContributionId = '#URL.scope#'
	AND    ProgramCode = '#get.ProgramCode#'
</cfquery>

<cfif qCheck.recordcount eq 0>
	
	<cfquery name="qProgram" datasource="AppsProgram">
		INSERT INTO ContributionProgram
	           (ContributionId
	           ,ProgramCode
	           ,OfficerUserId
			   ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#URL.scope#'
	           ,'#get.ProgramCode#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.last#'
	           ,'#SESSION.first#')
	</cfquery>
	
<cfelse>

	<cfoutput>
		<script>
			alert('Contribution is already associated to the program #get.Reference#');
		</script>
	</cfoutput>
	
</cfif>

<cfset url.contributionid = url.scope>

<cfinclude template = "ContributionProgram.cfm">
