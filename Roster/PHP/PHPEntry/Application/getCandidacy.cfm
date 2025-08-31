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
 <cfquery name="Submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission
	WHERE    ApplicantNo = '#client.ApplicantNo#' 
</cfquery>

<cfquery name="getCandidacy" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  AF.*, R.Meaning AS StatusDescription
			FROM    ApplicantFunction AF INNER JOIN
		            FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
		            Ref_StatusCode R ON AF.Status = R.Status INNER JOIN
		            Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition AND R.Owner = S.Owner
			WHERE   R.Id = 'FUN'
			AND     AF.ApplicantNo = '#client.applicantNo#' 
			AND     AF.FunctionId  = '#url.FunctionId#' 
</cfquery>	
	
	   
<cfoutput query="getCandidacy">   

	<table width="100%"><tr><td style="padding-bottom:5px">

	    <cfif Status eq "3" or Source eq "assignment">
			<cfset cl = "##BCFA98">
		<cfelse>
			<cfset cl = "##F2FA9D">	
		</cfif>
	   <table width="80%" style="border:0px solid d1d1d1" cellspacing="0" cellpadding="0" bgcolor="#cl#">
	   <tr class="labelit navigation_row_child">
	   		<td bgcolor="white" align="left" width="25"></td>
	   		<td width="120" bgcolor="white" width="190"><!--- <cf_tl id="Received">: ---></td>
	   		<td width="100" style="padding-left:14px">#DateFormat(FunctionDate)#</b></td>
	   		<td>
				<cfif Source eq "assignment">
					<cf_tl id="Your current assignment">
				<cfelse>
					<cf_tl id="Added to your career path">
					<!--- #StatusDescription# / #Source# --->
				</cfif>
			</td>
	   		<td width="150" align="left" style="padding-left:4px" bgcolor="white" style="font-size:13px;border-left:0px solid gray;padding-left:15px;padding-right:15px">
				<cfif Submission.actionStatus eq 0>
		   	   		<cfif Status eq "0" and Source neq "assignment">
			   			<a title="Remove" href="javascript:withdraw('#FunctionId#','#FunctionId#')"><font color="red"><cf_tl id="Remove"></font></a>
			   		</cfif>
				</cfif>
	   		</td>
	   </tr>
	   </table>
	   
	 </td></tr></table>	  
	   	   
</cfoutput>		
