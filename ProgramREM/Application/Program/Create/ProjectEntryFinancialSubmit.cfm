
<cfquery name="Financial" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT   *		       
		FROM     Ref_ProgramFinancial F
		WHERE    Code IN (SELECT Code 
		                  FROM   Ref_ProgramFinancialCategory
						  WHERE  ProgramCategory IN (SELECT S.Code
						                             FROM   ProgramCategory P, 
													        Ref_ProgramCategory R,
															Ref_ProgramCategory S
													 WHERE  P.ProgramCategory = R.Code
													 AND    R.Area = S.Area
													 AND    P.ProgramCode = '#programcode#'													 )
					     )		                      
	    ORDER BY ListingOrder
		
</cfquery>


<cfloop query="financial">
  
  <cfset code     = Evaluate("FORM.Metric_#currentrow#")>
  <cfset plan     = Evaluate("FORM.MetricsPlanned_#currentrow#")>
  <cfset ref      = Evaluate("FORM.MetricsReference_#currentrow#")>
  
  <cfset plan = replace(plan,',','',"ALL")>
  
  <cfif LSIsNumeric(plan)>
	  	
	  <cfquery name="Last" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM ProgramFinancial
			WHERE ProgramCode  = '#ProgramCode#'
			AND Code = '#Code#'
			ORDER BY DateEffective DESC
	  </cfquery>	
		
	  <cfset lastamt = Last.AmountPlanned>
						
		<cfif lastamt neq plan>
		
			<cfquery name="Insert" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO ProgramFinancial  
				         (ProgramCode, 
						  Code, 
						  DateEffective,
						  AmountPlanned, 
						  Reference, 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
			     VALUES ('#url.ProgramCode#', 
				      	'#Code#', 
						getDate(),
						'#plan#',
				        '#ref#',
			    	 	'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		     </cfquery>		
			 
		 <cfelse>	 
			
		     <cfquery name="Update" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      UPDATE  ProgramFinancial
				  SET     Reference    = '#ref#'			   
				  WHERE   ProgramCode  = '#ProgramCode#' 
				  AND     Code         = '#Code#'
				  AND     DateEffective = '#last.dateeffective#'
		     </cfquery>	 
		
	     </cfif>
		 
	 </cfif>	 
	
</cfloop>

