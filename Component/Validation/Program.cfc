
<!--- validations for Candidates --->

<cfcomponent>

	<cffunction name    = "getValidationStruct" 
		    access      = "private" 
		    returntype  = "struct">
			
			<cfparam name="ValidationCode"  type="string"  default="">
			<cfparam name="PassCode"     	type="string"  default="No">
			
			<cfquery name="getValidationDefinition"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Validation
					WHERE  ValidationCode = '#ValidationCode#'
			</cfquery>
			
			<cf_tl id="#getValidationDefinition.ValidationTitle#" var="lblVLabel">	
			<cf_tl id="#getValidationDefinition.ValidationInstructions#" var="lblVMemo">	
			
			<cfset vResult.label        = lblVLabel>
			<cfset vResult.passmemo     = lblVMemo>
			<cfset vResult.name         = getValidationDefinition.ValidationName>
			<cfset vResult.pass         = PassCode>
	
			<cfreturn vResult>
			
	</cffunction>
	
	<cffunction name    = "ProgramActivity" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="ProgramId">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			
			<cfquery name="Activity"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ProgramCode	
					FROM   ProgramActivity PA
					WHERE  ProgramCode   = '#get.ProgramCode#' 
					AND	   ActivityPeriod = '#get.Period#'						
					AND    RecordStatus != 9
					AND    EXISTS
						(
							SELECT	'X'
							FROM	ProgramActivityOutput Ox
							WHERE	Ox.ActivityId = PA.ActivityId
							AND		Ox.RecordStatus <> '9'
						)
			</cfquery>
							
			<cfif getProgram.programClass neq "Program" AND Activity.recordcount eq 0>
				
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif>
			
			<cfreturn result>
			 	   						 				
	</cffunction>	 	
	
	<cffunction name    = "ProgramRequirement" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one budget requirement done" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			 
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			 
			<cfquery name="Resource"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ProgramCode
				    FROM ProgramAllotmentRequest
				    WHERE ProgramCode = '#get.ProgramCode#'
					AND Period        = '#get.Period#'	
					AND ActionStatus != '9'
					UNION
					SELECT ProgramCode
				    FROM ProgramAllotmentDetail
				    WHERE ProgramCode = '#get.ProgramCode#'
					AND Period        = '#get.Period#'	
					AND Status != '9'
			</cfquery>

			<cfquery name="ResourcePositive"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT SUM(Amount) as Total
				    FROM ProgramAllotmentDetail
				    WHERE ProgramCode = '#get.ProgramCode#'
					AND Period        = '#get.Period#'	
					AND Status != '9'
			</cfquery>
			
			<cfif getProgram.programClass neq "Program" AND (Resource.recordcount eq 0 OR ResourcePositive.recordcount eq 0 OR ResourcePositive.Total eq 0)>
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
										
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>
	
	<cffunction name    = "Risks" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one risk selected with full text" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			 
			<cfquery name="Risk"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT	CASE 
							WHEN TotalRisks <= 0 THEN 0
							WHEN TotalRisks > 0 AND TotalRisks <> TotalRisksWithText THEN 0
							ELSE 1
						END as RiskValidation
				FROM
					(
						SELECT	ISNULL(COUNT(*), 0) AS TotalRisks,
								ISNULL(SUM(CountWithText), 0) AS TotalRisksWithText
						FROM
							(
								SELECT	PC.*,
										CASE 
											WHEN PCPr.ProfileNotes IS NULL OR LTRIM(RTRIM(CONVERT(VARCHAR(5000), PCPr.ProfileNotes))) = '' THEN 0
											ELSE 1
										END AS CountWithText
								FROM	ProgramCategory PC
										INNER JOIN ProgramCategoryPeriod PCP
											ON PC.ProgramCode = PCP.ProgramCode
											AND PC.ProgramCategory = PCP.ProgramCategory
										INNER JOIN ProgramPeriod PP
											ON PCP.Period = PP.Period 
											AND PCP.ProgramCode = PP.ProgramCode
										INNER JOIN Ref_ProgramCategory RPC
											ON PCP.ProgramCategory = RPC.Code
										INNER JOIN ProgramCategoryProfile PCPr
											ON PCP.ProgramCode = PCPr.ProgramCode
											AND PCP.ProgramCategory = PCPr.ProgramCategory
								WHERE   RPC.Area = 'Risk'
								AND		PC.Status <> '9'
								AND		PP.ProgramId = '#ObjectKeyValue1#'
							) as D
					) as T
					
			</cfquery>
			
			<cfif getProgram.programClass neq "Program" AND Risk.RiskValidation eq 0>
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
										
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>	
	
	<cffunction name    = "GenderMarker" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one gender marker is selected with full text" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfif get.Period lt "F20">
			
				<cfquery name="getProgram"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
					    FROM   Program
					    WHERE  ProgramCode ='#get.ProgramCode#'				
				</cfquery>
				 
				<cfquery name="GenderMarker"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT	COUNT(*) AS GenderValidation
					FROM	ProgramCategory PC
							INNER JOIN ProgramCategoryPeriod PCP
								ON PC.ProgramCode = PCP.ProgramCode
								AND PC.ProgramCategory = PCP.ProgramCategory
							INNER JOIN ProgramPeriod PP 
								ON PCP.Period = PP.Period 
								AND PCP.ProgramCode = PP.ProgramCode
							INNER JOIN Ref_ProgramCategory RPC
								ON PCP.ProgramCategory = RPC.Code
							INNER JOIN ProgramCategoryProfile PCPr
								ON PCP.ProgramCode = PCPr.ProgramCode
								AND PCP.ProgramCategory = PCPr.ProgramCategory
					WHERE   RPC.Area = 'Gender Marker'   
					AND		PC.Status <> '9'
					AND		PP.ProgramId = '#ObjectKeyValue1#'
					AND		PCPr.ProfileNotes IS NOT NULL
					AND		LTRIM(RTRIM(CONVERT(VARCHAR(5000), PCPr.ProfileNotes))) <> ''
										
				</cfquery>
				
				<cfif getProgram.programClass neq "Program" AND GenderMarker.GenderValidation eq 0>
							
					<cfinvoke method    = "getValidationStruct" 					   
					   ValidationCode   = "#ValidationCode#"
					   PassCode			= "No"
					   returnvariable   = "result">	
											
				</cfif>
			
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>	
	
	<cffunction name    = "ExpectedResults" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates that the expected results text is selected with full text" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			
			<cfquery name="getProgramUnit"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  O.*
				    FROM   ProgramPeriod PP
							INNER JOIN Organization.dbo.Organization O
								ON PP.OrgUnit = O.OrgUnit
				    WHERE  PP.ProgramId ='#ObjectKeyValue1#'					
			</cfquery>
			 
			<cfquery name="ExpectedResults"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">

				SELECT	CASE 
							WHEN TotalResults <= 0 THEN 0
							WHEN TotalResults > 0 AND (TotalResults != CountSelected OR TotalResults != CountHasText) THEN 0
							ELSE 1
						END as ExpectedResultsValidation
				FROM
					(
					SELECT	ISNULL(COUNT(Code), 0) as TotalResults,
							ISNULL(COUNT(isSelected), 0) as CountSelected,
							ISNULL(SUM(hasText), 0) as CountHasText
					FROM
						(
							SELECT	RPC.Code, 
									(
										SELECT	PPx.ProgramId
										FROM	ProgramCategory PCx
												INNER JOIN ProgramCategoryPeriod PCPx
													ON PCx.ProgramCode = PCPx.ProgramCode
													AND PCx.ProgramCategory = PCPx.ProgramCategory
												INNER JOIN ProgramPeriod PPx
													ON PCPx.Period = PPx.Period 
													AND PCPx.ProgramCode = PPx.ProgramCode	
										WHERE	PCx.ProgramCategory = RPC.Code
										AND		PPx.Period = PossibleCategories.Period
										AND		PPx.ProgramId = '#ObjectKeyValue1#'
										AND		PCx.Status <> '9'
									) as isSelected,
									(
										SELECT	CASE
													WHEN LTRIM(RTRIM(CONVERT(VARCHAR(5000), PCPrx.ProfileNotes))) = '' THEN 0
													ELSE 1
												END as CountNotes
										FROM	ProgramCategory PCx
												INNER JOIN ProgramCategoryPeriod PCPx
													ON PCx.ProgramCode = PCPx.ProgramCode
													AND PCx.ProgramCategory = PCPx.ProgramCategory
												INNER JOIN ProgramPeriod PPx
													ON PCPx.Period = PPx.Period 
													AND PCPx.ProgramCode = PPx.ProgramCode
												INNER JOIN ProgramCategoryProfile PCPrx
													ON PCPx.ProgramCode = PCPrx.ProgramCode
													AND PCPx.ProgramCategory = PCPrx.ProgramCategory	
										WHERE	PCx.ProgramCategory = RPC.Code
										AND		PPx.Period = PossibleCategories.Period
										AND		PPx.ProgramId = '#ObjectKeyValue1#'
										AND		PCx.Status <> '9'
									) as hasText
							FROM	(
										SELECT	RPCx.*, 
												MCx.Period
										FROM	Ref_ProgramCategory RPCx
												INNER JOIN Ref_ParameterMissionCategory MCx
													ON RPCx.Code = MCx.Category
										WHERE   RPCx.Area = 'Expected Results'
										AND		MCx.Mission = '#getProgramUnit.Mission#'
										AND		(MCx.OrgUnit = '#get.OrgUnit#' OR MCx.OrgUnit = '0')
										AND		(MCx.Period = '#get.Period#' OR MCx.Period IS NULL)
									) AS PossibleCategories
									INNER JOIN Ref_ProgramCategory RPC
										ON PossibleCategories.Code = RPC.Code
										OR (PossibleCategories.Code = RPC.Parent AND RPC.HierarchyCode LIKE PossibleCategories.HierarchyCode + '%')
							WHERE	RPC.Parent IS NOT NULL 
							AND		LTRIM(RTRIM(RPC.Parent)) != ''
							AND		RPC.Operational = '1'
						) AS ValidationData
					) AS T
									
			</cfquery>
			
			<cfif getProgram.programClass neq "Program" AND ExpectedResults.ExpectedResultsValidation eq 0>
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
										
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>
	
	<cffunction name    = "GenderMarker2" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates that all gender marker questions are selected and with text" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfif get.Period gte "F20">
			
				<cfquery name="getProgram"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
					    FROM   Program
					    WHERE  ProgramCode ='#get.ProgramCode#'				
				</cfquery>
				
				<cfquery name="getProgramUnit"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  O.*
					    FROM   ProgramPeriod PP
								INNER JOIN Organization.dbo.Organization O
									ON PP.OrgUnit = O.OrgUnit
					    WHERE  PP.ProgramId ='#ObjectKeyValue1#'					
				</cfquery>
				 
				<cfquery name="GenderMarker"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
	
					SELECT	CASE 
								WHEN TotalMarkers <= 0 THEN 0
								WHEN TotalMarkers > 0 AND (TotalMarkers != CountSelected OR TotalMarkers != CountHasText) THEN 0
								ELSE 1
							END as GenderMarkerValidation
					FROM
						(
						SELECT	ISNULL(COUNT(Code), 0) as TotalMarkers,
								ISNULL(COUNT(isSelected), 0) as CountSelected,
								ISNULL(SUM(hasText), 0) as CountHasText
						FROM
							(
								SELECT	RPC.Code, 
										(
											SELECT	PPx.ProgramId
											FROM	ProgramCategory PCx
													INNER JOIN ProgramCategoryPeriod PCPx
														ON PCx.ProgramCode = PCPx.ProgramCode
														AND PCx.ProgramCategory = PCPx.ProgramCategory
													INNER JOIN ProgramPeriod PPx
														ON PCPx.Period = PPx.Period 
														AND PCPx.ProgramCode = PPx.ProgramCode	
											WHERE	PCx.ProgramCategory = RPC.Code
											AND		PPx.Period = PossibleCategories.Period
											AND		PPx.ProgramId = '#ObjectKeyValue1#'
											AND		PCx.Status <> '9'
										) as isSelected,
										(
											SELECT	CASE
														WHEN LTRIM(RTRIM(CONVERT(VARCHAR(5000), PCPrx.ProfileNotes))) = '' THEN 0
														ELSE 1
													END as CountNotes
											FROM	ProgramCategory PCx
													INNER JOIN ProgramCategoryPeriod PCPx
														ON PCx.ProgramCode = PCPx.ProgramCode
														AND PCx.ProgramCategory = PCPx.ProgramCategory
													INNER JOIN ProgramPeriod PPx
														ON PCPx.Period = PPx.Period 
														AND PCPx.ProgramCode = PPx.ProgramCode
													INNER JOIN ProgramCategoryProfile PCPrx
														ON PCPx.ProgramCode = PCPrx.ProgramCode
														AND PCPx.ProgramCategory = PCPrx.ProgramCategory	
											WHERE	PCx.ProgramCategory = RPC.Code
											AND		PPx.Period = PossibleCategories.Period
											AND		PPx.ProgramId = '#ObjectKeyValue1#'
											AND		PCx.Status <> '9'
										) as hasText
								FROM	(
											SELECT	RPCx.*, 
													MCx.Period
											FROM	Ref_ProgramCategory RPCx
													INNER JOIN Ref_ParameterMissionCategory MCx
														ON RPCx.Code = MCx.Category
											WHERE   RPCx.Area = 'Gender Marker'
											AND		MCx.Mission = '#getProgramUnit.Mission#'
											AND		(MCx.OrgUnit = '#get.OrgUnit#' OR MCx.OrgUnit = '0')
											AND		(MCx.Period = '#get.Period#' OR MCx.Period IS NULL)
										) AS PossibleCategories
										INNER JOIN Ref_ProgramCategory RPC
											ON PossibleCategories.Code = RPC.Code
											OR (PossibleCategories.Code = RPC.Parent AND RPC.HierarchyCode LIKE PossibleCategories.HierarchyCode + '%')
								WHERE	RPC.Parent IS NOT NULL 
								AND		LTRIM(RTRIM(RPC.Parent)) != ''
								AND		RPC.Operational = '1'
							) AS ValidationData
						) AS T
										
				</cfquery>
				
				<cfif getProgram.programClass neq "Program" AND GenderMarker.GenderMarkerValidation eq 0>
							
					<cfinvoke method    = "getValidationStruct" 					   
					   ValidationCode   = "#ValidationCode#"
					   PassCode			= "No"
					   returnvariable   = "result">	
											
				</cfif>
			
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>
	
	<cffunction name    = "WorkflowInfo" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates all workflow textareas" 
		    output      = "true">	
					
			<cfparam name="SystemFunctionId"   type="string"  default="">				
			<cfparam name="Object"             type="string"  default="ProgramId">	
			<cfparam name="ObjectKeyValue1"    type="string"  default="">	
			<cfparam name="ValidationCode"     type="string"  default="">	
			
			<cfset result.pass = "OK">
			
			<cfquery name="get"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ProgramPeriod
				    WHERE  ProgramId ='#ObjectKeyValue1#'				
			</cfquery>
			
			<cfquery name="getProgram"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Program
				    WHERE  ProgramCode ='#get.ProgramCode#'				
			</cfquery>
			 
			<cfquery name="WorkflowInfo"
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">

				SELECT	Prg.ReviewId
				FROM	Ref_ReviewCycleProfile P
						INNER JOIN
						(
							SELECT	R.ReviewId,
									R.ReviewCycleId,
									RP.TextAreaCode,
									RP.ProfileNotes
							FROM	ProgramPeriod PP
									INNER JOIN ProgramGroup G
										ON PP.ProgramCode = G.ProgramCode
									INNER JOIN ProgramPeriodReview R
										ON PP.ProgramCode = R.ProgramCode
										AND PP.Period = R.Period
										AND R.EntityClass = (CASE WHEN G.ProgramGroup = 'D03' THEN 'MYAXB' WHEN G.ProgramGroup = 'D02' THEN 'Rapid' ELSE '' END)
									INNER JOIN ProgramPeriodReviewProfile RP
										ON R.ReviewId = RP.ReviewId
							WHERE	PP.ProgramId = '#ObjectKeyValue1#'
						) AS Prg
						ON P.CycleId = Prg.ReviewCycleId
						AND P.TextAreaCode = Prg.TextAreaCode
				WHERE	P.Operational = 1
				AND		LEN(LTRIM(RTRIM(CONVERT(VARCHAR(MAX), ISNULL(Prg.ProfileNotes, ''))))) = 0
									
			</cfquery>
			
			<cfif getProgram.programClass neq "Program" AND WorkflowInfo.recordCount gt 0>
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
										
			</cfif>
			
			<cfreturn result>	 
			 	   						 				
	</cffunction>
		
</cfcomponent>	
