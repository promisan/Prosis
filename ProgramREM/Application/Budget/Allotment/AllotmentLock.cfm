
<cfif url.lock eq "false">

	<cfquery name="Details" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE  ProgramAllotment
		 SET     LockEntry = 0, 
		         LockEntryOfficer = '#session.acc#', 
				 LockEntryDate = getDate()
	     WHERE   EditionId   = '#URL.EditionId#'
		 AND     ProgramCode = '#URL.ProgramCode#'
		 AND     Period      = '#URL.Period#'		
	 </cfquery>
	 
<cfelse>
	
	<cfquery name="Details" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE   ProgramAllotment
		 SET      LockEntry = 1,
				  LockEntryOfficer = '#session.acc#', 
				  LockEntryDate = getDate()
	     WHERE    EditionId   = '#URL.EditionId#'
		 AND      ProgramCode = '#URL.ProgramCode#'
		 AND      Period      = '#URL.Period#'		
	 </cfquery>	 

</cfif>