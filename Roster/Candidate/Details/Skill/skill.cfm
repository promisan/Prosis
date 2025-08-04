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


<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     S.SubmissionDate, 
           S.ApplicantNo, 
		   B.ExperienceId, 
		   B.ExperienceCategory, 
		   B.ExperienceDescription, 
		   F.ExperienceFieldId, 
		   R.Description, 
		   R.ExperienceClass, 
           C.Description AS ExperienceClassDescription, 
		   R.Status, 
		   F.Officeruserid, 
		   F.OfficerlastName, 
		   F.Created
FROM       ApplicantSubmission AS S INNER JOIN
           ApplicantBackground AS B ON S.ApplicantNo = B.ApplicantNo INNER JOIN
           ApplicantBackgroundField AS F ON B.ApplicantNo = F.ApplicantNo AND B.ExperienceId = F.ExperienceId INNER JOIN
           Ref_Experience AS R ON F.ExperienceFieldId = R.ExperienceFieldId INNER JOIN
           Ref_ExperienceClass AS C ON R.ExperienceClass = C.ExperienceClass
WHERE      S.PersonNo = '#URL.ID#' 
AND        S.Source = '#url.source#'
ORDER BY   S.SubmissionDate, C.ListingOrder, R.Listingorder, ExperienceClassDescription
</cfquery>

<table width="95%">

<cfoutput query="Detail" group="SubmissionDate">

<tr><td colspan="3" style="height:40px;padding-top:5px" class="labellarge">Submission: #dateformat(submissionDate,client.dateformatshow)# [#ApplicantNo#]</td></tr>

<cfoutput group="ExperienceClassDescription">

<tr class="line" ><td colspan="3" style="padding-left:10px" class="labelmedium"><b>#ExperienceClassDescription#</td></tr>

<tr><td colspan="3" style="padding-top:5px;padding-left:20px">
<cf_TopicEntry 
    	ApplicantNo="#ApplicantNo#" 
       	Topic="#ExperienceClass#_memo"
		Type="memo"		
		Class="regularc"
		Attachment="yes"
		Mode="View">
		</td>
</tr>		

<cfoutput>

<tr><td heifght="5"></td></tr>
<tr>
  <td class="labelit" style="padding-left:20px">#Description#</td>
  <td class="labelit"  style="padding-left:20px">#OfficerlastName#</td>
  <td class="labelit"  style="padding-left:10px">#dateformat(Created,client.dateformatshow)#</td>
</tr>

</cfoutput>

</cfoutput>
</cfoutput>
