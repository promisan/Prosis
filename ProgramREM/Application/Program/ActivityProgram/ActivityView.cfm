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
<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes" blockevent = "rightclick">

<Script language="JavaScript">

function AddActivity(ComponentCode, Period, ActivityID) {
    window.location = "../ActivityProgram/ActivityEntry.cfm?ProgramCode=" + ComponentCode + "&Period=" + Period + "&ActivityID=" + ActivityID;
}

function AddOutputs(ComponentCode, Period, ActivityID, SubPeriod) {
    window.location = "../ActivityProgramOutput/ActivityOutputEntry.cfm?ProgramCode=" + ComponentCode + "&Period=" + Period + "&ActivityID=" + ActivityID + "&SubPeriod=" + SubPeriod;
}

function EditOutput(ComponentCode, Period, ActivityID, OutputId){
    window.location = "../ActivityProgramOutput/ActivityOutputEdit.cfm?ProgramCode=" + ComponentCode + "&Period=" + Period + "&ActivityID=" + ActivityID + "&OutputId=" + OutputId;
}

function reloadForm(programcode, period, sorting) {
    window.location = "../ActivityProgram/ActivityView.cfm?ProgramCode=" + programcode + "&Period=" + period + "&Sorting=" + sorting;
}

function DeleteActivity(ProgramCode, Period, ActivityID, UserAccess) {
if (confirm("Do you want to remove this Activity ?")) {
   window.location="../ActivityProgram/ActivityDelete.cfm?ProgramCode=" + ProgramCode + "&Period=" + Period + "&ActivityID=" + ActivityID + "&UserAccess=" + UserAccess;
}
}

function DeleteOutput(ProgramCode, Period, OutputID, UserAccess) {
if (confirm("Do you want to remove this Output ?")) {
   window.location="../ActivityProgramOutput/OutputDelete.cfm?ProgramCode=" + ProgramCode + "&Period=" + Period + "&OutputID=" + OutputID + "&UserAccess=" + UserAccess;
}
}

function DeleteProgress(ProgramCode, Period, ProgressID) {
if (confirm("Do you want to remove this Progress Report ?")) {
   window.location="../ActivityProgramOutput/OutputProgressDelete.cfm?ProgramCode=" + ProgramCode + "&Period=" + Period + "&ProgressID=" + ProgressID;
}
}

</Script>

<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_dialogREMProgram>
<cf_dropdown>

<cfparam name="URL.ExpandOutput" default="">
<cfparam name="URL.ExpandSubPeriod" default="">

<!--- Query returning program parameters --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>

<cfparam name="URL.Sorting" default="Reference">

<table width="100%" border="0"><tr><td>  

<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<tr><td>

<!--- if we are expanding one activity subperiod, only select that activity to display --->

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>
		
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

  <cfoutput>
   
    <tr><td height="34" align="center">
	<table width="100%"><tr><td class="labelmedium">
	<cfoutput>&nbsp;#Program.ProgramClass#</cfoutput> <cf_tl id="activities">				
	<input type="radio" name="Sorting" value="ActivityDateStart" <cfif URL.Sorting eq "period">checked</cfif>
	onClick="javascript:reloadForm('#URL.ProgramCode#','#URL.Period#','period')"> <cf_tl id="Period">
	<input type="radio" name="Sorting" value="Reference" <cfif URL.Sorting eq "reference">checked</cfif>
	onClick="javascript:reloadForm('#URL.ProgramCode#','#URL.Period#','reference')"> <cf_tl id="Reference">&nbsp;
	</td><td align="right">
	
	<cfif ProgramAccess eq "ALL">  <!--- access invoked by ComponentViewHeader --->
		<cf_tl id="New Activity" var="vNewActivity">
		<input type="button" value="#vNewActivity#" class="button10g" onClick="javascript:AddActivity('#URL.ProgramCode#','#URL.Period#','')">
	</cfif>
	</tr></table>	
    </td>
	</cfoutput>
   </tr>
<tr><td colspan="6" class="line" height="1"></td></tr> 
<tr>
<td width="100%" colspan="1">
  
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
	
<TR class="labelmedium line">
    <td width="6%" height="18" align="center"></td>
	<TD width="24%" align="left"><cf_tl id="Description"></TD>
	<td width="10%" align="left"><cf_tl id="Start Date"></td>
	<td width="10%" align="left"><cf_tl id="Target Date"></td>
	<td width="56%" colspan="2"><cf_tl id="Progress report"></td>
</TR>

<cfif URL.Sorting eq "period">

	<cfquery name="SubPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	From Ref_SubPeriod
	</cfquery>	
	
	<cfloop query="SubPeriod">
	
		<cfset sub = SubPeriod>
	
		<cfquery name="SearchResult" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT A.*,	O.OrgUnitName as OrganizationName 
		    From  #CLIENT.LanPrefix#ProgramActivity A, 
			      Organization.dbo.#CLIENT.LanPrefix#Organization O
			WHERE A.OrgUnit        = O.OrgUnit
			AND   A.ProgramCode    = '#URL.ProgramCode#' 
			AND   A.ActivityPeriod = '#URL.Period#'
			AND	  (A.RecordStatus <> 9 OR A.RecordStatus is NULL)
			AND   ActivityId IN (
			              SELECT ActivityId 
						  FROM ProgramActivityOutput 
						  WHERE ProgramCode = '#URL.ProgramCode#'
						  AND ActivityPeriod = '#URL.Period#')
		    ORDER BY Reference, ListingOrder
		</cfquery>	
		
		<cfinclude template="ActivityViewDetails.cfm">
	
	</cfloop>
	
<cfelse>
	
		<cfquery name="SearchResult" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT A.*,	O.OrgUnitName as OrganizationName 
		    From  #CLIENT.LanPrefix#ProgramActivity A, 
			      Organization.dbo.#CLIENT.LanPrefix#Organization O
			WHERE A.OrgUnit = O.OrgUnit
			AND   A.ProgramCode = '#URL.ProgramCode#' 
			AND   A.ActivityPeriod = '#URL.Period#'
			AND	  (A.RecordStatus <> 9 OR A.RecordStatus is NULL)
			ORDER BY Reference, ListingOrder
		</cfquery>	
		
		<cfinclude template="ActivityViewDetails.cfm">

</cfif>

	</table>
	</td></tr>

	</table>
	</td></tr>
	
</table>
	
