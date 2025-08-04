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

<!--- show titles for the selected grade deployment to reflect a current assignment --->

<cfquery name="Functions" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    FO.FunctionId,F.FunctionNo, F.FunctionDescription
	FROM      FunctionOrganization FO INNER JOIN
              FunctionTitle F ON FO.FunctionNo = F.FunctionNo
    WHERE     FO.GradeDeployment = '#url.gradedeployment#' 
	AND       FO.SubmissionEdition = '#url.submissionedition#' 
    AND       F.FunctionOperational = 1
	ORDER BY Functiondescription
</cfquery>

 <cfquery name="Selected" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     
   SELECT     * 
           
   FROM       ApplicantFunction
   WHERE      ApplicantNo = '#url.applicantno#'
   AND        Source = 'Assignment'
   <cfif Functions.recordcount gte "1">
   AND        Functionid IN (#quotedvalueList(Functions.FunctionId)#) 
   </cfif>      
  
 </cfquery>

<table class="formpadding">
<cfoutput query="Functions">
	<tr class="labelmedium">
		<td><input type="radio" class="radiol" name="FunctionId" value="#FunctionId#" <cfif selected.functionid eq FunctionId>checked</cfif>></td>
		<td style="padding-left:20px;height:26px;font-size:17px"><font color="808080">#FunctionDescription#</td>
	</tr>
</cfoutput>	
</table>
