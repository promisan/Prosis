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

<!--- verify if a submission record exists --->

<cfparam name="FORM.FieldId" default="">

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
SELECT  * 
FROM    ApplicantAssessment
WHERE   PersonNo = '#Form.Personno#'
AND     Owner      = '#URL.Owner#'
</cfquery>

<cfquery name="Clear" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	DELETE FROM ApplicantAssessmentDetail
	WHERE   AssessmentId = '#Check.AssessmentId#'
	AND     Source = '#URL.Source#'
</cfquery>

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
 
<cfloop index="Item" 
        list="#Form.FieldId#" 
        delimiters="' ,">
		
<cfquery name="Insert" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    INSERT INTO dbo.[ApplicantAssessmentDetail] 
           (AssessmentId,
		   Owner,
		   Source,
		   SkillCode,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
   VALUES ('#Check.AssessmentId#', 
          '#URL.Owner#',
		   '#URL.Source#',
		  '#Item#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
 </cfquery>
		  
</cfloop>	

<cfset url.id2 = "read">
<cfinclude template="AssessmentDetail.cfm">
	

