
<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramStatus
		WHERE  ProgramCode    = '#url.ProgramCode#' 
		AND    ProgramStatus  IN (SELECT Code 
		                          FROM   Ref_ProgramStatus 
								  WHERE  StatusClass = '#url.statusclass#')				   			
</cfquery>		

<cfif url.programStatus neq "">			
	 		
		 <cfquery name="InsertStatus" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 INSERT INTO ProgramStatus
				      (ProgramCode,
					   ProgramStatus,		
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
			 VALUES   ('#url.ProgramCode#',
					   '#url.programstatus#',
					   '#SESSION.acc#',
			  		   '#SESSION.last#',		  
					   '#SESSION.first#')
	    </cfquery>
		
</cfif>	