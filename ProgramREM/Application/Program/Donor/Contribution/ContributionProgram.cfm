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
<cfquery name="qMission" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT Mission
		FROM   Contribution
		WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>		

<cfquery name = "qPeriod" 
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT Period
	FROM   Ref_MissionPeriod
	WHERE  Mission = '#qMission.Mission#'
	AND    DefaultPeriod = 1
</cfquery>

<cfquery name="qPrograms" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT P.*, PP.Reference, PP.PeriodDescription as ProgramDescription
		FROM   Program P INNER JOIN ProgramPeriod PP ON P.ProgramCode = PP.ProgramCode
		AND    PP.Period = '#qPeriod.Period#'
		WHERE  Mission   = '#qMission.Mission#'	
		AND    EXISTS (
					SELECT 'x'
					FROM    ContributionProgram
					WHERE   ContributionId = '#URL.ContributionId#'
					AND     ProgramCode    = P.ProgramCode
				)
</cfquery>

<cfoutput>

	<cfif qPeriod.recordcount eq 0>
		<script>
			alert('You must set a default period for #qMission.Mission#. Contact your administrator.');
		</script>	
		<cfabort>
	</cfif>

	<cfsavecontent variable = "vscript">
		javascript:selectprogramme('#qMission.Mission#','#qPeriod.Period#','programdescription_#URL.contributionId#','programcode_#URL.contributionId#','#URL.contributionId#','earmarkpledge','#URL.contributionid#' )
	</cfsavecontent>  
	
<table width="100%" cellspacing="0" cellpadding="0">

	<tr>
		<td colspan="7" class="labelmedium"><a href="##" onclick="#vscript#"><font color="0080C0"><cf_tl id="Select a program/project"></a></td>
	</tr>
	
	<cfif qPrograms.recordcount neq 0>	
	
		<cfloop query="qPrograms">
		
			<tr class="labelmedium" id="pl_#ProgramCode#_#URL.contributionId#" height="30">				
				<td>#ProgramCode#</td>
				<td>#Reference#</td>
				<td width="5px"></td>
				<td>#ProgramName#</td>
				<td><cf_img icon="delete" onclick="removepledgeprogram('#ProgramCode#','#URL.contributionId#')"></td>
				<td width="10%"></td>		
			</tr>
			<tr id="pld_#ProgramCode#_#URL.contributionId#">
				<td colspan="5" class="linedotted"></td>
				<td></td>		
			</tr>	
			
		</cfloop>
				
	</cfif>
	
</cfoutput>

</table>

