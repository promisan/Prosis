 
<cfquery name="ResetGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
DELETE From ProgramBeneficiary
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
SELECT Beneficiary
FROM   ProgramBeneficiary
WHERE ProgramCode = '#Form.ProgramCode#' AND Beneficiary = '#Item#'
</cfquery>

<CFIF #VerifyGroup.recordCount# is 1 > 

<cfquery name="UpdateGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE ProgramBeneficiary
SET Status = '1', 
OfficerUserId = '#SESSION.acc#',
OfficerLastName = '#SESSION.last#',
OfficerFirstName = '#SESSION.first#'
WHERE ProgramCode = '#Form.ProgramCode#' AND Beneficiary = '#Item#'
</cfquery>

<cfelse>

<cfquery name="InsertGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO ProgramBeneficiary
         (ProgramCode,
		 Beneficiary,
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

