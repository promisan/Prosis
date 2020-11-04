
<cfparam name="url.code" default="">

<cfparam name="item" default="#url.code#">		
		
<cfquery name="VerifyGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ProgramCategory
	WHERE  ProgramCode     = '#Form.ProgramCode#' 
	AND    ProgramCategory = '#Item#'
</cfquery>

<cfquery name="qCategory" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ProgramCategory
	WHERE  Code = '#Item#'
</cfquery>

<cfquery name="qProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Program
	WHERE  ProgramCode = '#Form.ProgramCode#'
</cfquery>

<cfquery name="qCategoryMission" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 M.*
	FROM     Ref_ParameterMissionCategory M INNER JOIN Ref_ProgramCategory C ON M.Category = C.Code
	WHERE    M.Mission     = '#qProgram.Mission#'	
	AND 	 C.HierarchyCode LIKE ((SELECT LEFT(Cx.HierarchyCode, 2) FROM Ref_ProgramCategory Cx WHERE Code = '#Item#')) + '%'
	ORDER BY C.HierarchyCode DESC
</cfquery>

<cfquery name="qValidCategory" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	SELECT	PC.*
	FROM	ProgramCategory PC INNER JOIN Ref_ProgramCategory RPC ON PC.ProgramCategory = RPC.Code
	WHERE	PC.ProgramCode = '#form.programcode#'	
	AND		PC.Status != '9'	
	AND		RPC.HierarchyCode LIKE 
					(
						SELECT 	PCx.HierarchyCode
						FROM 	Ref_ParameterMissionCategory Cx INNER JOIN Ref_ProgramCategory PCx ON Cx.Category = PCx.Code
						WHERE 	Cx.Mission = '#qProgram.Mission#' 
						<!---
						AND 	(Cx.Period IS NULL OR LTRIM(RTRIM(Cx.Period)) = '' OR Cx.Period = '#url.Period#')
						--->
						AND 	PCx.HierarchyCode LIKE ((SELECT LEFT(Cxx.HierarchyCode, 2) FROM Ref_ProgramCategory Cxx WHERE Cxx.Code = '#Item#')) + '%'
					) + '%'
</cfquery>

<cfset vAllowChange = 1>

<cfif qCategoryMission.recordCount gt 0 AND qCategoryMission.AreaMaximum neq 0>
	<cfif qValidCategory.recordCount gte qCategoryMission.AreaMaximum>
		<cfif VerifyGroup.Status neq url.status>
			<cfset vAllowChange = 0>
		</cfif>
	</cfif>
</cfif>

<cfif vAllowChange eq 0 AND url.status eq 1>

	<cfoutput>
		<cf_tl id="Operation not allowed.\nYou have reached the max number of selections" var="1">
		<script>
			alert('#lt_text# : #qCategoryMission.AreaMaximum#.');
			//Refresh screen
			doRefresh();
		</script>
	</cfoutput>

<cfelse>

	<CFIF VerifyGroup.recordCount is 1> 
	    
		<!---
		<cfif VerifyGroup.status eq "9">
		--->
			
			<cfquery name="UpdateGroup" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE ProgramCategory
				SET    Status           = '#url.status#', 
				       OfficerUserId    = '#SESSION.acc#',
				       OfficerLastName  = '#SESSION.last#',
				       OfficerFirstName = '#SESSION.first#'
				WHERE  ProgramCode      = '#Form.ProgramCode#' 
				AND    ProgramCategory  = '#Item#' 
			</cfquery>
			
			<cfif url.status eq "9">
			
				<cfquery name="UpdateGroup" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramCategoryPeriod			
					WHERE  ProgramCode      = '#Form.ProgramCode#' 
					AND    Period           = '#URL.Period#'
					AND    ProgramCategory  = '#Item#' 
				</cfquery>
				
			<cfelse>	
			
				<cfquery name="UpdateGroup" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ProgramCategoryPeriod			
					WHERE  ProgramCode      = '#Form.ProgramCode#' 
					AND    Period           = '#URL.Period#'
					AND    ProgramCategory  = '#Item#' 
				</cfquery>
				
				<cftry>
					
				<cfquery name="InsertGroup" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ProgramCategoryPeriod 
				         ( ProgramCode,
						   ProgramCategory,
						   Period,			 
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName)
				  VALUES ('#Form.ProgramCode#', 
				      	  '#Item#',
					      '#URL.Period#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>
				
				<cfcatch></cfcatch>
				
				</cftry>
					
			</cfif>
					
			<cfif url.status eq "1">			
									
				<cfquery name="StatusClassLIst" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  DISTINCT StatusClass
					FROM    Ref_ProgramStatus 
					WHERE   Code IN (SELECT ProgramStatus
					                 FROM   Ref_ProgramCategoryStatus	   
							  	     WHERE  Code = '#Item#') 				  		
				</cfquery>		
								
				<cfquery name="clear" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE FROM ProgramCategoryStatus
						WHERE  ProgramCode     = '#Form.ProgramCode#'  				   			
						AND    ProgramCategory = '#item#'					
				</cfquery>		
	
				<cfloop query="StatusClassList">
				    				
					<cfparam name="Form.Status#item#_#StatusClass#" default="">
					<cfset val = evaluate("Form.Status#item#_#StatusClass#")>					
					 
					<cfif val neq  "">		 	 
						
						 <cfquery name="InsertStatus" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO ProgramCategoryStatus
							        (ProgramCode,
									 ProgramCategory,
									 ProgramStatus,		
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
						   	 VALUES ('#ProgramCode#',
							         '#item#',
									 '#val#',
									 '#SESSION.acc#',
						  			 '#SESSION.last#',		  
								  	 '#SESSION.first#')
					    </cfquery>
					
					</cfif>
					
				</cfloop>		
							
				<!--- profile area --->					
							
				<cfquery name="getCodes" 
			    datasource="AppsProgram" 
		  		username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
		  			SELECT *
				    FROM   Ref_ProgramCategoryProfile
				    WHERE  Code = '#item#'			  
			    </cfquery>	
												
				<cfif getCodes.recordcount gte "1">		
																		
					<cf_ProgramTextArea
						Table           = "ProgramCategoryProfile" 
						Domain          = "Category"
						TextAreaCode    = "#quotedvalueList(getCodes.TextAreaCode)#"
						Field           = "#Item#"
						FieldOutput     = "ProfileNotes"
						Join            = "RIGHT OUTER JOIN"
						Mode            = "SAVE"
						Log             = "Yes"
						Key01           = "ProgramCode"
						Key01Value      = "#Form.ProgramCode#"
						Key02           = "ProgramCategory"
						Key02Value      = "#Item#">
					
				</cfif>		
			
			</cfif>			
		
		<!---	
		</cfif>
		--->
		
	<cfelse>
	
		<cfquery name="InsertGroup" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramCategory 
		         ( ProgramCode,
				   ProgramCategory,
				   Status,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
		  VALUES ('#Form.ProgramCode#', 
		      	  '#Item#',
			      '1',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
		</cfquery>
		
		<cftry>
		
			<cfquery name="InsertGroup" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ProgramCategoryPeriod 
			         ( ProgramCode,
					   ProgramCategory,
					   Period,			 
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
			  VALUES ('#Form.ProgramCode#', 
			      	  '#Item#',
				      '#URL.Period#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
		<cfquery name="getCodes" 
		    datasource="AppsProgram" 
	  		username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
	  			SELECT *
			    FROM   Ref_ProgramCategoryProfile
			    WHERE  Code = '#item#'			  
		    </cfquery>	
											
			<cfif getCodes.recordcount gte "1">
																	
				<cf_ProgramTextArea
					Table           = "ProgramCategoryProfile" 
					Domain          = "Category"
					TextAreaCode    = "#quotedvalueList(getCodes.TextAreaCode)#"
					Field           = "#Item#"
					FieldOutput     = "ProfileNotes"
					Join            = "RIGHT OUTER JOIN"
					Mode            = "SAVE"
					Log             = "Yes"
					Key01           = "ProgramCode"
					Key01Value      = "#Form.ProgramCode#"
					Key02           = "ProgramCategory"
					Key02Value      = "#Item#"
					Officer         = "Y">
				
			</cfif>	
		
	</cfif>
	
	<cfquery name="qValidCategory" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT	PC.*
		FROM	ProgramCategory PC
				INNER JOIN Ref_ProgramCategory RPC
					ON PC.ProgramCategory = RPC.Code
		WHERE	PC.ProgramCode = '#form.programcode#'	
		AND		PC.Status != '9'	
		AND		RPC.HierarchyCode LIKE 
						(
							SELECT 	PCx.HierarchyCode
							FROM 	Ref_ParameterMissionCategory Cx INNER JOIN Ref_ProgramCategory PCx ON Cx.Category = PCx.Code
							WHERE 	Cx.Mission = '#qProgram.Mission#' 
							<!--- AND 	(Cx.Period IS NULL OR LTRIM(RTRIM(Cx.Period)) = '' OR Cx.Period = '#url.Period#') --->
							AND 	PCx.HierarchyCode LIKE ((SELECT LEFT(Cxx.HierarchyCode, 2) FROM Ref_ProgramCategory Cxx WHERE Cxx.Code = '#Item#')) + '%'
						) + '%'
	</cfquery>
	
	<cfif qValidCategory.recordCount eq 0>
		<script>
			//Refresh screen
			doRefresh();
		</script>
	</cfif>

</cfif>




