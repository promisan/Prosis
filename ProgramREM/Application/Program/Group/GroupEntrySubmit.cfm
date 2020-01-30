

<cfquery name="ResetGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE From ProgramGroup
	WHERE ProgramCode = '#Form.ProgramCode#'
</cfquery>

<cfparam name="Form.ProgramGroup" type="any" default="">

<cfloop index="Item" 
        list="#Form.ProgramGroup#" 
        delimiters="' ,">

<cfquery name="VerifyGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ProgramGroup
	FROM   ProgramGroup
	WHERE  ProgramCode = '#Form.ProgramCode#' 
	AND    ProgramGroup = '#Item#'
</cfquery>

<cfif VerifyGroup.recordCount is 1 > 
	
	<cfquery name="UpdateGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  ProgramGroup
		SET 	Status = '1', 
				OfficerUserId    = '#SESSION.acc#',
				OfficerLastName  = '#SESSION.last#',
				OfficerFirstName = '#SESSION.first#'
		WHERE   ProgramCode      = '#Form.ProgramCode#' 
		AND     ProgramGroup     = '#Item#'
	</cfquery>

<cfelse>
	
	<cfquery name="InsertGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ProgramGroup 
	    	     (ProgramCode,
				 ProgramGroup,
				 Status,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
				 Created)
		VALUES ('#Form.ProgramCode#', 
	    	  	  '#Item#',
			      '1',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#',
				  '#DateFormat(Now(),CLIENT.dateSQL)#')
	</cfquery>

</cfif>

</cfloop>		


