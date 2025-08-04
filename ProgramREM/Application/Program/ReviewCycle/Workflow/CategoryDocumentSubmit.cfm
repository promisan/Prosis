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

<!--- categoryreview --->


<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ProgramPeriodReview S 
		WHERE  S.ReviewId = '#Object.ObjectKeyValue4#'		
</cfquery>

<cfquery name="CategoryAll" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	F.AreaCode,
				F.Area, 
				F.Code, 
				F.DescriptionMemo, 
				F.Description, 
				ISNULL((SELECT ListingOrder FROM Ref_ProgramCategory WHERE Code = F.AreaCode),0) as ParentListingOrder,
				S.*
		FROM   	ProgramCategory S, 
		       	Ref_ProgramCategory F 
		WHERE  	S.ProgramCode = '#get.ProgramCode#'
		AND  	S.ProgramCategory = F.Code
		AND  	S.Status != '9'
		<!--- hardcoded --->
		AND  	Area != 'Risk'
		ORDER BY ParentListingOrder ASC, F.AreaCode ASC, F.ListingOrder ASC
</cfquery>

<cfloop query="CategoryAll">
	
	
	<cfquery name="check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   	ProgramPeriodReviewCategory S
			WHERE  	S.ReviewId = '#Object.ObjectKeyValue4#'	
			AND  	S.ProgramCategory = '#code#'
	</cfquery>
	
	<cfparam name="Form.f#Code#" default="">	
	<cfset val = evaluate("Form.f#Code#")>
	
	<cfif val neq "">

		<cfif check.recordcount eq "1">
		
			<cfif val neq check.AssessmentMemo>
			
				<cfquery name="insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE 	ProgramPeriodReviewCategory 
						SET     AssessmentMemo   = '#val#',
						        OfficerUserId    = '#session.acc#',
							    OfficerLastName  = '#session.last#',
							    OfficerFirstName = '#session.first#'
						FROM   	ProgramPeriodReviewCategory	S
						WHERE  	S.ReviewId = '#Object.ObjectKeyValue4#'	
						AND  	S.ProgramCategory = '#code#'
						
				</cfquery>
			
			</cfif>
	
		
		<cfelse>
		
				<cfquery name="insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ProgramPeriodReviewCategory 
					(ReviewId,ProgramCategory,AssessmentMemo,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES
					('#Object.ObjectKeyValue4#','#code#','#val#','#session.acc#','#session.last#','#session.first#')									
				</cfquery>		
			
		</cfif>
	
	</cfif>

</cfloop>
