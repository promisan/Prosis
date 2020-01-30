 
<cfquery name="ResetGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ProgramLocation
	WHERE  ProgramCode = '#Form.ProgramCode#'
</cfquery>

<cfparam name="Form.Location" type="any" default="">

<cfloop index="Item" 
        list="#Form.Location#" 
        delimiters="' ,">
	
	<cfquery name="VerifyGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT LocationCode
		FROM   ProgramLocation
		WHERE  ProgramCode  = '#Form.ProgramCode#' 
		AND    LocationCode = '#Item#'
	</cfquery>
	
	<CFIF VerifyGroup.recordCount is 1> 
		
		<cfquery name="UpdateGroup" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	ProgramLocation
			SET 	Status = '1', 
					OfficerUserId = '#SESSION.acc#',
					OfficerLastName = '#SESSION.last#',
					OfficerFirstName = '#SESSION.first#'
			WHERE 	ProgramCode = '#Form.ProgramCode#' 
			AND     LocationCode = '#Item#'
		</cfquery>
	
	<cfelse>
		
		<cfquery name="InsertGroup" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ProgramLocation
			         (ProgramCode,
					 LocationCode,
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
