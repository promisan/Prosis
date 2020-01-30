
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


