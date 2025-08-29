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
<cfquery name="qTextArea"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT T.Code, 
			<cfif language.code neq "ENG">
				L.Description
			<cfelse>
				T.Description 	
			</cfif>	
	FROM Ref_TextArea T 
		<cfif language.code neq "ENG">
			INNER JOIN Ref_TextArea_Language L ON L.Code = T.Code
				AND L.LanguageCode = '#language.code#'
		</cfif>
	WHERE TextAreaDomain = 'Position'
	ORDER BY ListingOrder
</cfquery>


<cfloop query="qJOs">	
	
	<cfset Session.status = Session.Status + step>
	<cfset Session.message = "Processing #qJOs.Reference# in #Language.LanguageName#">
	
	<cfquery name="qParentPosts"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT PositionParentId, 
				(
					SELECT SUM(1)
					FROM Employee.dbo.PositionParentProfile 
					WHERE PositionParentId = P.PositionParentId			
					AND LanguageCode = '#language.languagecode#'
					AND JobNotes IS NOT NULL
					AND Datalength(JobNotes)>0				
				) as Total
			FROM Employee.dbo.Position P
			WHERE 
				EXISTS
				(
					 SELECT 'X'
						FROM  Ref_SubmissionEditionPosition REP
						WHERE SubmissionEdition = '#url.submissionedition#'
						AND   Reference         = '#qJOs.Reference#'
						AND   PositionNo        = P.PositionNo
				)	
			AND EXISTS 
				(
					SELECT 'X'
					FROM Employee.dbo.PositionParentProfile 
					WHERE PositionParentId = P.PositionParentId			
					AND JobNotes IS NOT NULL
					AND LanguageCode = '#language.languagecode#'					
					AND Datalength(JobNotes)>0					
				)
		</cfquery>				
	
		<cfquery name="Parent" dbtype="query">
			SELECT PositionParentId
			FROM   qParentPosts
			ORDER BY Total Desc
		</cfquery>
		
		<cfif Parent.PositionParentId neq "">
		
			<cfif qJOs.Reference neq "">
				<cfinclude template="JobPositionText.cfm">
			</cfif>	
			
		</cfif>	
		
</cfloop>