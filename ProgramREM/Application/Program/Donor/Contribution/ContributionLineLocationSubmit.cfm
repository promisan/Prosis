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
<cfquery name="qCheck" 
    datasource="AppsProgram">
	SELECT * 
	FROM   ContributionLineLocation
	WHERE  ContributionLineId = '#URL.LineId#'
	AND    LocationCode       = '#URL.LocationCode#'
</cfquery>

<cfif qCheck.recordcount eq 0>
	
	<cfquery name="qProgram" datasource="AppsProgram">
		INSERT INTO ContributionLineLocation
	           (ContributionLineId
	           ,LocationCode
	           ,OfficerUserId
			   ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#URL.LineId#'
	           ,'#URL.LocationCode#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.last#'
	           ,'#SESSION.first#')
	</cfquery>

<cfelse>

	<cfoutput>
		<script>
			alert('Line is already associated to the Location #URL.LocationCode#');
		</script>
	</cfoutput>
	
</cfif>

<cfinclude template = "ContributionLineEarmark.cfm">
