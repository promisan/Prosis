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
	WHERE  ContributionId IN (
			SELECT ContributionId
			FROM ContributionLine
			WHERE ContributionLineId = '#URL.lineid#'
		)	
</cfquery>		

<cfquery name = "qPeriod" 
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  Period
	FROM    Ref_MissionPeriod
	WHERE   Mission = '#qMission.Mission#'
	AND     DefaultPeriod = 1
</cfquery>

<cfoutput>
<cfif qPeriod.recordcount eq 0>
	<script>
		alert('You must define a default period for #qMission.Mission#. Contact your administrator.');
	</script>	
	<cfabort>
</cfif>
</cfoutput>

<cfquery name="qPrograms" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	
	SELECT P.*, 
			(SELECT TOP 1 Reference
			 FROM   ProgramPeriod
			 WHERE  ProgramCode = P.ProgramCode
			 ORDER BY Period DESC
			) as Reference    
	FROM   Program P INNER JOIN ContributionLineProgram CLP ON P.ProgramCode = CLP.ProgramCode
	WHERE  ContributionLineId = '#URL.lineid#'
	
</cfquery>

<cfquery name="qLog" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ContributionLineLog
	WHERE  ContributionLineId = '#URL.lineid#'
</cfquery>		


<cfoutput>
	<cfsavecontent variable = "vscript">
		javascript:selectprogramme('#qMission.Mission#','#qPeriod.Period#','programdescription_#URL.lineId#','programcode_#URL.lineId#','#URL.lineid#','processprogram','#URL.lineId#' )
	</cfsavecontent>                                                                                                                                
</cfoutput>

<table width="600" cellspacing="0" cellpadding="0" class="navigation_table">

<cfoutput>

    <cfif qPrograms.recordcount neq 0>	
	<tr>		
		<td class="labelit" style="padding-left:20px" colspan="6">
			
				<a href="##" onclick="#vscript#">&nbsp;<font color="0080C0">Add project/program to be earmarked for this tranche</a>
			
			<!---
			<input type="hidden" id="programdescription_#URL.lineId#" name="programdescription_#URL.lineId#" value="" class="regularH" readonly>
            <input type="hidden" id="programcode_#URL.lineId#"        name="programcode_#URL.lineId#"        value="" readonly>
			--->
		</td>
	</tr>
	</cfif>	
	
	<cfif qPrograms.recordcount neq 0>	
		<cfloop query="qPrograms">
		<tr id="pl_#ProgramCode#_#URL.lineId#" class="labelit navigation_row linedotted">			
			<td width="10%" style="width:70;padding-left:20px">#ProgramCode#</td>
			<td>#Reference#</td>
			<td width="5px"></td>
			<td>#ProgramName#</td>
			<td><cf_img icon="delete" onclick="removeprogram('#ProgramCode#','#URL.lineId#')"></td>
			<td width="10%"></td>		
		</tr>		
		</cfloop>
	<cfelse>
		<tr>
			<td colspan="6" style="padding-left:20px" class="labelit"><cf_tl id="No Earmarked programs/projects recorded"> [<a href="##" onclick="#vscript#">&nbsp;<font color="0080C0"><u>Press here to record</a>]</td>
		</tr>
	</cfif>
	
</cfoutput>

<cfquery name="qLocations" 
	datasource="AppsEmployee"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT LocationCode, LocationName 
	FROM   Location L
	WHERE  Mission = '#qMission.Mission#'	
	AND EXISTS
	(
		SELECT 'x'
		FROM Program.dbo.ContributionLineLocation
		WHERE ContributionLineId = '#URL.lineid#'
		AND   LocationCode  = L.LocationCode
	)
</cfquery>

<cfoutput>

	<cfsavecontent variable = "vscript">
		javascript:selectlocation('lookup','locationcode_#URL.lineId#','locationname_#URL.lineId#','#qMission.Mission#','#URL.lineId#')
	</cfsavecontent>                                                                                                                                

    <cfif qLocations.recordcount neq 0>	
	<tr>		
		<td colspan="6" class="labelit" style="padding-left:20px">			
			<a href="##" onclick="#vscript#"><font color="0080C0"><cf_tl id="Add Location"></a>		
		</td>
	</tr>
	</cfif>	
	
	<input type="hidden" id="locationname_#URL.lineId#" name="locationname_#URL.lineId#" value="" readonly>
    <input type="hidden" id="locationcode_#URL.lineId#" name="locationcode_#URL.lineId#" value="" readonly>
	
	<cfif qLocations.recordcount neq 0>	
	
		<cfloop query="qLocations">
		<tr id="pl_#LocationCode#_#URL.lineId#" height="20" class="navigation_row linedotted">			
			<td class="labelit" style="width:70;padding-left:20px">#LocationCode#</td>
			<td class="labelit" colspan="3">#LocationName#</td>			
			<td><cf_img icon="delete" onclick="removelocation('#LocationCode#','#URL.lineId#')"></td>
			<td width="10%"></td>		
		</tr>		
		</cfloop>
		
	<cfelse>
	
		<tr>
			<td colspan="6" style="padding-left:20px" class="labelit"><cf_tl id="No Earmarked Locations recorded">[<a href="##" onclick="#vscript#"><font color="0080C0">&nbsp;<u>Press here to record</a>]</td>
		</tr>
		
	</cfif>
	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>


