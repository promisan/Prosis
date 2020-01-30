<!--- -------------------- --->
<!--- create status record --->
<!--- -------------------- --->
	
<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramStatus
		WHERE  ProgramCode = '#ProgramCode#'  				   			
</cfquery>		

<cfquery name="StatusClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DISTINCT StatusClass
	FROM    Ref_ProgramStatus 
	WHERE   Code IN (SELECT ProgramStatus
	                 FROM   Ref_ProgramStatusMission	   
			  	     WHERE  Mission = '#Mission#') 				  		
</cfquery>					

<cfloop query="StatusClass">

	 <cfset fld = replaceNoCase(StatusClass," ","","ALL")>

	 <cfparam name="Form.Status#fld#" default="">
	 <cfset val = evaluate("Form.Status#fld#")>
	 
	 <cfif val neq  "">		 	 
		
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
		   	 VALUES ('#ProgramCode#',
					 '#val#',
					 '#SESSION.acc#',
		  			 '#SESSION.last#',		  
				  	 '#SESSION.first#')
	    </cfquery>
	
	</cfif>
	
</cfloop>		