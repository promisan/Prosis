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
	FROM Contribution
	WHERE 
	ContributionId IN
	(
		SELECT ContributionId
		FROM ContributionLine
		WHERE ContributionLineId = '#URL.lineid#'
	)	
</cfquery>		

<cfquery name = "qPeriod" 
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT Period
	FROM Ref_MissionPeriod
	WHERE Mission = '#qMission.Mission#'
	AND DefaultPeriod=1
</cfquery>

<cfquery name="qPrograms" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT P.*, PP.Reference
	FROM Program P INNER JOIN ProgramPeriod PP ON P.ProgramCode = PP.ProgramCode
	AND PP.Period = '#qPeriod.Period#'
	WHERE Mission = '#qMission.Mission#'	
	AND EXISTS
	(
		SELECT 'x'
		FROM ContributionLineProgram
		WHERE ContributionLineId = '#URL.lineid#'
		AND   ProgramCode = P.ProgramCode
	)
</cfquery>

<cfquery name="qLog" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM ContributionLineLog
	WHERE ContributionLineId = '#URL.lineid#'
</cfquery>		

<cfoutput>

	<cfif qPeriod.recordcount eq 0>
	<script>
		alert('You must set a default period for #qMission.Mission#. Contact your administrator.');
	</script>	
	<cfabort>
	</cfif>

	<cfsavecontent variable = "vscript">
		javascript:selectprogramme('#qMission.Mission#','#qPeriod.Period#','programdescription_#URL.lineId#','programcode_#URL.lineId#','#URL.lineid#' )
	</cfsavecontent>                                                                                                                                
	
</cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<cfoutput>

	<tr>
		<td colspan="5" align="center" <cfif qPrograms.recordcount neq 0>height="40"</cfif>>
			<cfif qPrograms.recordcount neq 0>	
				<button onclick="#vscript#" id="btnAddProgram" name="btnAddProgram" style="width:120" class="button10g"><cf_tl id="Add earmark"></button>
			</cfif>	
			<input type="hidden" id="programdescription_#URL.lineId#" name="programdescription_#URL.lineId#" value="" class="regularH" readonly>
            <input type="hidden" id="programcode_#URL.lineId#"        name="programcode_#URL.lineId#"        value="" readonly>
		</td>
	</tr>
	
	<cfif qPrograms.recordcount neq 0>	
		<cfloop query="qPrograms">
		<tr id="pl_#ProgramCode#_#URL.lineId#" height="30">
			<td width="10%"></td>
			<td>#ProgramCode#</td>
			<td>#Reference#</td>
			<td width="5px"></td>
			<td>#ProgramDescription#</td>
			<td><cf_img icon="delete" onclick="removeprogram('#ProgramCode#','#URL.lineId#')"></td>
			<td width="10%"></td>		
		</tr>
		<tr id="pld_#ProgramCode#_#URL.lineId#"><td></td>
			<td colspan="5" class="linedotted"></td>
			<td></td>		
		</tr>	
		</cfloop>
	<cfelse>
		<tr><td colspan="2" width="20"></td>
			<td colspan="7" class="label">No Ear-marked programs/projects recorded&nbsp;&nbsp;&nbsp;[<a href="##" onclick="#vscript#"><u>Press here to record</a>]</td>
		</tr>
	</cfif>
	
</cfoutput>

</table>

