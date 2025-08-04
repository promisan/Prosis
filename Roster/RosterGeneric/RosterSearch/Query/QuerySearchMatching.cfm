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

<CFSET FileNo  = Attributes.FileNo>
<!--- loop through each requirement aspect : minimum, optional currently only minimum --->

<!--- loop through variation function/grade for the bucket that were selected --->

<!--- A. determine the No of requirement lines to be met per a functional bucket --->

<cfquery name="functions" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT     DISTINCT 
		           FR.FunctionNo, 
		           FR.GradeDeployment, 
				   COUNT(DISTINCT FRL.RequirementLineNo) AS Lines
				   
		FROM       RosterSearchLine S,
		           FunctionOrganization FO,
		           FunctionRequirement FR,
		           FunctionRequirementLine FRL
				   
		WHERE      S.SearchClass         = 'Function'
		AND        S.SearchId            = '#Attributes.SearchId#'
		AND        S.SelectId            = FO.FunctionId
		AND        FO.FunctionNo         = FR.FunctionNo 
		AND        FO.GradeDeployment    = FR.GradeDeployment
		AND        FR.RequirementId      = FRL.RequirementId 
		
		AND        ( 
						EXISTS  (SELECT 'X' 
		                    FROM   FunctionRequirementLineField 
		                    WHERE  RequirementId = FRL.RequirementId
						    AND    RequirementLineNo = FRL.RequirementLineNo)
							
							OR 
							
						EXISTS  (SELECT 'X' 
		                    FROM   FunctionRequirementLineTopic 
		                    WHERE  RequirementId = FRL.RequirementId
						    AND    RequirementLineNo = FRL.RequirementLineNo)	
				   )
			   			  
		
		AND        FR.RequirementClass   = 'Minimum'
		AND        FRL.Operational = 1
		
		GROUP BY   FR.FunctionNo, FR.GradeDeployment, FR.RequirementClass
				
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_MinimumSelect">

<!--- now we run a query that matches the requirements lines to the candidate recorded backgound and we let only 
people survice that have the SAME number of the minimum requirements set for that function/grade --->

<cfsavecontent variable="qry">
	
	<cfoutput query="Functions">
		
		<cfif currentRow gt "1">
		UNION
		</cfif>
		
		SELECT     '#Attributes.SearchId#' as SearchId, 
		           PersonNo, 
				   COUNT(DISTINCT RequirementLineNo) AS RequirementLineNo
				   
		<cfif currentRow eq "1">
		INTO       userQuery.dbo.tmp#SESSION.acc#_#fileNo#_MinimumSelect
		</cfif>		   
				   
		FROM       (
		               SELECT     S.PersonNo, FRL.RequirementId, FRL.RequirementLineNo
                       FROM          FunctionRequirement FR INNER JOIN
                                              FunctionRequirementLine FRL ON FR.RequirementId = FRL.RequirementId INNER JOIN
                                              FunctionRequirementLineField KW ON FRL.RequirementId = KW.RequirementId AND FRL.RequirementLineNo = KW.RequirementLineNo INNER JOIN
                                              ApplicantBackgroundField B ON KW.ExperienceFieldId = B.ExperienceFieldId INNER JOIN
                                              ApplicantSubmission S ON B.ApplicantNo = S.ApplicantNo
                    
					WHERE      FR.FunctionNo      = '#FunctionNo#' 
					AND        FR.GradeDeployment = '#GradeDeployment#' 
					AND        B.Status = '1' 
					AND        FR.RequirementClass = 'Minimum'
					AND        FRL.Operational = 1
		
                    GROUP BY S.PersonNo, FRL.RequirementId, FRL.RequirementLineNo
            
			        UNION
            
			        SELECT     S.PersonNo, FRL.RequirementId, FRL.RequirementLineNo
                    FROM         FunctionRequirement FR INNER JOIN
                                 FunctionRequirementLine FRL ON FR.RequirementId = FRL.RequirementId INNER JOIN
                                 FunctionRequirementLineTopic KW ON FRL.RequirementId = KW.RequirementId AND FRL.RequirementLineNo = KW.RequirementLineNo INNER JOIN
                                 ApplicantSubmissionTopic B ON KW.Topic = B.Topic AND KW.ListCode = B.ListCode INNER JOIN
                                 ApplicantSubmission S ON B.ApplicantNo = S.ApplicantNo
                      
					WHERE      FR.FunctionNo      = '#FunctionNo#' 
					AND        FR.GradeDeployment = '#GradeDeployment#' 
					AND        B.ActionStatus = '1' 
					AND        FR.RequirementClass = 'Minimum'
					AND        FRL.Operational = 1
					
                   GROUP BY S.PersonNo, FRL.RequirementId, FRL.RequirementLineNo) k

		GROUP BY   PersonNo
		HAVING     COUNT(RequirementLineNo) = '#lines#'
						
	</cfoutput>

</cfsavecontent>

<cfif functions.recordcount neq "0">

<cfquery name="select" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	#preservesingleQuotes(qry)#
</cfquery>

<cfelse>

	<cfset caller.go = "0">

</cfif>
