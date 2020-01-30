<!--- create event records --->
			
	<cfquery name="clear" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramEvent
			WHERE  ProgramCode = '#ProgramCode#'  
			AND    ProgramEvent IN (SELECT Code FROM Ref_ProgramEvent WHERE ModeEntry = '1')	   			
	</cfquery>		
	
	<cfquery name="Events" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ProgramEvent 
			WHERE   Code IN (SELECT ProgramEvent
			                 FROM   Ref_ProgramEventMission	   
					  	     WHERE  Mission = '#Mission#') 
			AND     ModeEntry = '1'			  		
	</cfquery>					
	
	<cfloop query="Events">
	
		<cfset date = evaluate("Form.DateEvent_#Code#")>
		<CF_DateConvert Value="#date#">
		<cfset dte = dateValue>
	
		 <cfquery name="InsertEvent" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ProgramEvent
		        (ProgramCode,
				 ProgramEvent,
				 DateEvent,				
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	   	 VALUES ('#ProgramCode#',
				 '#code#',
				 #dte#,
				 '#SESSION.acc#',
	  			 '#SESSION.last#',		  
			  	 '#SESSION.first#')
	    </cfquery>
			
	</cfloop>