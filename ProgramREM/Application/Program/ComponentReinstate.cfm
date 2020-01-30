
<cfquery name="Reinstate" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE dbo.ProgramPeriod
		 SET    RecordStatus = '1',  
		        RecordStatusDate = getDate(),
			    RecordStatusOfficer = '#session.acc#'
         WHERE  ProgramCode = '#URL.prg#'
		 AND    Period = '#URL.Period#'
</cfquery>

<cflocation url="ProgramViewTop.cfm?Layout=#URL.Layout#&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#" addtoken="No">		  

