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
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfparam name="URL.Mode" default="generic">
<cfparam name="URL.Owner" default="">
<cfparam name="URL.IDTemplate" default="reload">
<cfparam name="URL.ID1" default="">

<cfoutput>
	
	<script language="JavaScript">
	
	function edit() {
	   window.location = "ApplicantMission.cfm?id=#url.id#&mode=edit"
	   }
	   
	function add(app,mis) {
	   window.location = "ApplicantMissionSubmit.cfm?id=#url.id#&mode=edit&app="+app+"&mis="+mis+"&act=add"
	   }   
	   
	function del(app,mis) {
	   window.location = "ApplicantMissionSubmit.cfm?id=#url.id#&mode=edit&app="+app+"&mis="+mis+"&act=del"
	   }      
	
	</script>

</cfoutput>

<cfquery name="Preference" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     AM.ApplicantNo, 
           AM.Mission, 
		   AM.Source, 
		   R.MissionType, 
		   R.MissionName, 
		   AM.Status, 
		   AM.DateUpdated
FROM       ApplicantMission AM INNER JOIN
           Organization.dbo.Ref_Mission R ON AM.Mission = R.Mission INNER JOIN
           ApplicantSubmission S ON AM.ApplicantNo = S.ApplicantNo
WHERE     (R.MissionStatus = '0')
AND       PersonNo = '#URL.ID#'
ORDER BY AM.Mission
</cfquery>

<cfset deny = "0">

<cf_DialogStaffing>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td colspan="2"><cfinclude template="../Applicant/Applicant.cfm"></td></tr>

<tr>
  <td style="padding-left:20px;height:40" class="labellarge"><b><cf_tl id="Preferences"></b></td>
  <td align="right" style="padding-right:10px">
  <input type="button" name="Edit" value="Edit" class="button10g" align="right" onclick="edit()">
  </td>
</tr> 	

<tr><td colspan="2" class="linedotted"></td></tr> 

<tr>
  <td width="97%" colspan="2" align="center">

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
	
	<TR class="linedotted">
	    <TD height="16" width="30"></TD>
	    <TD class="labelit"><cf_tl id="Mission"></TD>
		<TD class="labelit"><cf_tl id="Type"></TD>
		<TD class="labelit"><cf_tl id="Source"></TD>
		<TD class="labelit"><cf_tl id="Updated"></TD>	
		<TD class="labelit"><cf_tl id="Status"></TD>	
		<TD></TD>	
	</TR>
	
	<cfif Preference.recordcount eq "0" and url.mode neq "Edit">
		
	<TR>
	    <td height="26" colspan="7" class="labelmedium" align="center"><b><font color="red"><cf_tl id="No preferences submitted"></b></td>
	</TR>
	
	</cfif>
	
	<cfoutput query="Preference">
	
	<TR class="navigation_row">
	    <td align="right"></td>
		<TD class="labelmedium">#Mission#</TD>
		<td class="labelmedium" height="18">#MissionType#</TD>
		<TD class="labelmedium">#Source#</td>
		<td class="labelmedium">#DateFormat(DateUpdated,CLIENT.DateFormatShow)#</td>
		<td class="labelmedium">#Status#</td>
		<td>
		<cfif url.mode eq "edit" and source is "Manual">
		 <cf_img icon="delete" onClick="del('#applicantno#','#mission#')">
		</cfif>
		</td>
	</TR>
	</cfoutput>
	
	<cfif url.mode eq "edit">
	
	<tr class="navigation_row"><td></td>
		<td height="30">
		
		<cfquery name="Mission" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization.dbo.Ref_Mission
		WHERE   MissionStatus = '0'
		AND     Mission NOT IN (SELECT AM.Mission 
		                   		 FROM  ApplicantMission AM INNER JOIN
								       Organization.dbo.Ref_Mission R ON AM.Mission = R.Mission INNER JOIN
								       ApplicantSubmission S ON AM.ApplicantNo = S.ApplicantNo
								WHERE  PersonNo = '#URL.ID#')
		</cfquery>
		
		<select class="regularxl" name="mission">
			<cfoutput query="Mission">
				 <option value="#Mission#">#Mission#</option>
			</cfoutput>
		</select>
					
		</td>
		
		<td colspan="5" align="right" style="padding-right:10px">
		
			<cfquery name="Candidate" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM  ApplicantSubmission
			WHERE  PersonNo = '#URL.ID#'
			ORDER BY Created DESC
			</cfquery>
						
			<cfoutput>	
				 <input type="button" name="Edit" value="Save" class="button10g" onclick="add('#candidate.applicantno#',mission.value)">
			</cfoutput> 
		
		</td>
	</tr>
	
	</cfif>
	
	</table>
</td>
</tr>
</table>

<cfset ajaxonload("doHighlight")>
