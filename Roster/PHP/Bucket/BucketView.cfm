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
<cfparam name="URL.PersonNo" default="50044">
<cfparam name="URL.Owner" default="SysAdmin">

<cfquery name="Bucket" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  FO.*, 
	S.ApplicantNo,
	        AF.FunctionDate AS FunctionDate, 
			AF.Status AS Status, 
			R.Meaning as StatusDescription,
			R.PrerosterStatus,
			AF.StatusDate AS StatusDate, 
			F.FunctionDescription AS FunctionDescription,
			E.EditionDescription
	FROM    ApplicantFunction AF INNER JOIN
	        ApplicantSubmission S ON AF.ApplicantNo = S.ApplicantNo INNER JOIN
	        FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
			Ref_SubmissionEdition E ON FO.SubmissionEdition = E.SubmissionEdition INNER JOIN
	        #Client.LanPrefix#FunctionTitle F ON FO.FunctionNo = F.FunctionNo INNER JOIN
			Ref_StatusCode R ON R.Id = 'FUN' AND R.Owner = '#url.owner#' AND R.Status = AF.Status
	WHERE   S.PersonNo = '#url.personNo#'	
	AND     E.Owner    = '#URL.Owner#'								 
	AND     (R.PreRosterStatus = '1' OR R.Status = '3')								 								
</cfquery>		

<table width="100%" cellspacing="0" cellpadding="0">

<tr>
   <td width="100%">
   
   <table width="100%" class="navigation_table">
   
	   <tr class="labelmedium line">
	      <td></td>
		  <td></td>
		  <td><cf_tl id="JO"></td>
		  <td><cf_tl id="Edition"></td>	
	   	  <td><cf_tl id="Job Title"></td>		 	    
		  <td><cf_tl id="Submission"></td>
		  <td><cf_tl id="Status"></td>
		  <td align="right" style="padding-right:6px"><cf_tl id="Status date"></td>
	   </tr>
	   
	   <cfoutput query="Bucket">
		   <tr class="labelmedium navigation_row">
	    	   <td style="padding-top:2px;padding-left:4px"><cf_img navigation="Yes" icon="open" onclick="loadva('#functionid#')"></td>
			   <td style="padding-left:5px">#currentrow#.</td>
			   <td>#ReferenceNo#</td>
			   <td>#EditionDescription#</td>
			   <td>#GradeDeployment# #FunctionDescription#</td>			  
			   <td>#dateformat(FunctionDate,CLIENT.DateFormatShow)#</td>
			   <td><cfif PreRosterStatus eq "0" and Status neq "3"><cf_tl id="Applied"><cfelse><cf_tl id="#StatusDescription#"></cfif></td>
			   <td align="right" style="padding-right:6px"><cfif PreRosterStatus eq "1" or Status eq "3">#dateformat(StatusDate,CLIENT.DateFormatShow)#</cfif></td>
		   </tr>	 
		</cfoutput>
		
	   </table>
   
   </td>
   
   <!---
   
   <td>
   	 <table width="100%">
     <cfoutput query="Background">
	    <tr bgcolor="F4FBFD">
		<td bgcolor="white" width="30" rowspan="3" align="center">
		<input type="checkbox" name="ccc" value="">
		</td>
		<td>#ExperienceDescription#</td>
		</tr>
		<tr>
		<td>#OrganizationName#</td>
		</tr>
		<tr>
		<td>#Dateformat(ExperienceStart,CLIENT.DateFormatShow)# - #Dateformat(ExperienceEnd,CLIENT.DateFormatShow)#</td>
		</tr>
	</cfoutput>
	</table>   
   </td>
   
   --->
   
</tr>

</table>
