
<TITLE>Sector</TITLE>
 
<!--- Insert Function --->   

<cfquery name="ResetSector" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE From ProgramSector
	WHERE ProgramCode = '#Form.ProgramCode#'
</cfquery>

<cfparam name="Form.ProgramSector" type="any" default="">

<cfloop index="Item" 
        list="#Form.ProgramSector#" 
        delimiters="' ,">

<cfquery name="VerifyGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ProgramSector
	FROM   ProgramSector
	WHERE ProgramCode = '#Form.ProgramCode#' AND ProgramSector = '#Item#'
</cfquery>

<CFIF VerifyGroup.recordCount is 1 > 

<cfquery name="UpdateGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  ProgramSector
	SET     Status = '1'
	WHERE   ProgramCode = '#Form.ProgramCode#' 
	AND     ProgramSector = '#Item#'
</cfquery>

<cfelse>

<cfquery name="InsertGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO ProgramSector 
	         (ProgramCode,
			 ProgramSector,
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
</cfif>

</cfloop>		


