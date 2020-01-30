
<!--- --------------------------------------------------------------- --->
<!--- -------- Review the content of the table to clean the --------- --->
<!--- --------------------------------------------------------------- --->

<cfquery name="init" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ApplicantSection
		SET    Operational = 0
		FROM   ApplicantSection A INNER JOIN
               Ref_ApplicantSection R ON A.ApplicantSection = R.Code
		WHERE  A.ApplicantNo = '#client.applicantNo#' 
		AND    R.TemplateTopicId = 'Skills'			
</cfquery>

<cfquery name="getApplicableSkills" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  DISTINCT R.Parent
		FROM    FunctionRequirementLineTopic FRT INNER JOIN
		        FunctionRequirement FR ON FRT.RequirementId = FR.RequirementId INNER JOIN
		        FunctionOrganization FO ON FR.FunctionNo = FO.FunctionNo AND FR.GradeDeployment = FO.GradeDeployment  INNER JOIN
		        ApplicantFunction AF ON FO.FunctionId = AF.FunctionId INNER JOIN
								Ref_Topic R ON FRT.Topic = R.Topic
		WHERE   AF.ApplicantNo = '#client.applicantNo#'		
</cfquery>		
	
<cfif getApplicableSkills.recordcount gte "1">	
	
	<cfquery name="enable" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			UPDATE ApplicantSection
			SET    Operational = 1		
			FROM   ApplicantSection A INNER JOIN
	               Ref_ApplicantSection R ON A.ApplicantSection = R.Code
			WHERE  A.ApplicantNo =  '#client.applicantNo#' 
			AND    R.TemplateTopicId = 'Skills'
			AND    TemplateCondition IN (#quotedvalueList(getApplicableSkills.parent)#)
	</cfquery>

</cfif>	

<!--- --------------------------------------------------------------- --->
<!--- --------------------------END --------------------------------- --->
<!--- --------------------------------------------------------------- --->