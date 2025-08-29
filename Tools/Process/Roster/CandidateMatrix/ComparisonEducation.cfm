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
<cfset url.id2 = "University">
<cfparam name="CLIENT.Submission" default="Manual"> 

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>

<cfparam name="comparisonApplicantNo" default="">

<cfquery name="qCheck" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 
    SELECT TOP 1 *
	FROM   ApplicantSubmission S

	 <cfif attributes.IDFunction neq "">
	 
	 		INNER JOIN ApplicantFunction AF
				ON S.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = '#Attributes.IDFunction#'
			INNER JOIN ApplicantFunctionSubmission AFS
				ON AF.ApplicantNo = AF.ApplicantNo AND AF.FunctionId = AFS.FunctionId
			WHERE S.PersonNo ='#URL.PersonNo#'
	 <cfelse>
		WHERE 	1=0
	 </cfif>	
	  
</cfquery>

<cfif attributes.IDFunction neq "" and qCheck.recordcount neq 0>

	<cfquery name="Detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    A.*, 
		          A.SubmissionId as EXperienceId,
		          F.ExperienceFieldId,
			      F.Status as StatusDomain,
		          R.Description,
			      R.Status as TopicStatus,
			      R.ExperienceClass,
			      A.Source
		    FROM  ApplicantFunctionSubmission S INNER JOIN
		          ApplicantSubmission A ON S.SubmissionId = A.SubmissionId LEFT OUTER JOIN
		          Ref_Experience R INNER JOIN
		          ApplicantFunctionSubmissionField F ON R.ExperienceFieldId = F.ExperienceFieldId ON A.SubmissionId = F.SubmissionId 
				  <cfif comparisonApplicantNo neq "">
					AND 	 S.ApplicantNo = '#comparisonApplicantNo#'
				  </cfif>
		    WHERE A.PersonNo = '#URL.PersonNo#'
			AND   A.Source   = '#SSource#'
			AND   A.Status   != '9'
			AND   F.Status   != '9'
			AND   S.ExperienceCategory = '#URL.ID2#'
			AND   S.FunctionId = '#Attributes.IDFunction#'
			ORDER BY ExperienceCategory, ExperienceStart DESC
	</cfquery>
	
<cfelse>

	<cfquery name="Detail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    DISTINCT A.*, 
		          F.ExperienceFieldId,
				   <!---
				   F.ReviewLastName, 
				   F.ReviewFirstName,
				   F.ReviewDate,
				   --->
			      F.Status as StatusDomain,
		          R.Description,
			      R.Status as TopicStatus,
			      R.ExperienceClass,
			      S.Source
		    FROM  ApplicantSubmission S INNER JOIN
		          ApplicantBackground A ON S.ApplicantNo = A.ApplicantNo LEFT OUTER JOIN
		          Ref_Experience R INNER JOIN
		          ApplicantBackgroundField F ON R.ExperienceFieldId = F.ExperienceFieldId ON A.ExperienceId = F.ExperienceId AND 
		          A.ApplicantNo = F.ApplicantNo
				  <cfif comparisonApplicantNo neq "">
					AND 	 S.ApplicantNo = #comparisonApplicantNo#
				  </cfif>
		    WHERE S.PersonNo = '#URL.PersonNo#'
			AND   S.Source   = '#SSource#'
			AND   A.Status != '9'
			AND   A.ExperienceCategory = '#URL.ID2#'
			ORDER BY ExperienceCategory, ExperienceStart DESC
	</cfquery>

</cfif>
  
<table width="99%" align="center">
	
	<cfif detail.recordcount eq "0">
		<tr>	
		<td colspan="8" align="center" class="labelit"><cf_tl id="No records found"></td>
		</TR>
	</cfif>
	  
	<cfoutput query="Detail" group="ExperienceId">
		
	<tr class="labelmedium2 navigation_row fixlengthlist" style="height:20px">
	<td width="5%">#currentrow#.</td>	
	<td colspan="7"><b>#OrganizationName#</b></td>		
	</tr>

	<cfif OrganizationCity neq "">
		
		<tr class="navigation_row_child" style="height:15px">
		<td></td>				
						
		<cfquery name="Nation" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Nation
			WHERE Code = '#OrganizationCountry#'
		</cfquery>
		
		<td colspan="7" style="height:15px">
		<table style="width:100%">
		<tr class="labelit" style="height:15px">
		<td style="padding-left:3px">#OrganizationCity# #Nation.Name#</td>
		<td align="right">#DateFormat(ExperienceStart,"MM/YYYY")#
		- <cfif ExperienceEnd lt "01/01/40" or ExperienceEnd gt "01/01/2030"><cf_tl id="Todate"><cfelse>#DateFormat(ExperienceEnd,"MM/YYYY")#</cfif>
		</td>
		</tr></table>
		
		</td>
		</tr>
		
	</cfif>
		
	<cfif Remarks neq "" and ExperienceDescription neq remarks>
		<tr class="labelit navigation_row_child" style="height:20px">
		<td></td>
		<td style="padding-left:3px" colspan="7">#Remarks#</td>
		</tr>
	</cfif>
	
	<cfif OrganizationAddress neq "">
		<tr class="labelit navigation_row)_child" style="height:20px">
		<td></td>
		<td style="padding-left:3px" colspan="7">#OrganizationAddress#</td>
		</tr>
	</cfif>
	
	<cfif OrganizationTelephone neq "">
		<tr class="labelit navigation_row_child" style="height:20px">
		<td></td>
		<td style="padding-left:3px" colspan="7"><cf_tl id="Tel">:#OrganizationTelephone#</td>
		</tr>
	</cfif>
	
	<cfif Status neq "9">
	
	    <tr class="navigation_row_child" style="height:20px">
		
	<cfelse>	
	
	    <tr bgcolor="red" style="height:20px">	
		
	</cfif>
		
		<td></td>
		<td colspan="7" style="padding-left:3px">
		
			<table>
			 <tr class="labelit" style="height:20px">		 
			 <cfif OrganizationClass neq ""><td>#OrganizationClass#</b></td></cfif>
			 <cfif ExperienceDescription neq ""><td>#ExperienceDescription#</b></td></cfif>
			 </tr>
			</table>	
			
		</td>
	
	</tr>
	
	<cfoutput>
	
	    <cfif TopicStatus eq "1">
	
			<tr bgcolor="ffffaf" class="labelit" style="height:10px">
			<td bgcolor="white"></td>			  
			<td colspan="6" style="padding-left:3px">#Description#</td>			
			<TD width="10%" align="right" style="padding-right:4px">
			
				<cfif CLIENT.submission neq "Skill">
					<cfif StatusDomain is "0"><cf_tl id="Pending"></cfif>
					<cfif StatusDomain is "1"><cf_tl id="Cleared"></cfif>
					<cfif StatusDomain is "9"><cf_tl id="Cancelled"></cfif>
				</cfif>
			
			</TD>					
			</TR>
		
		</cfif>
		
	</cfoutput>
	
	<cfif currentrow neq recordcount>		
		<tr><td colspan="8" class="linedotted"></td></tr>
	</cfif>
	
	</cfoutput>
	
</table>
