
<cfquery name="DeleteIndicator" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ProgramIndicator
		 SET RecordStatus = '9'
		 WHERE TargetId = '#URL.ID#'
</cfquery>

<cflocation url="TargetView.cfm?ProgramCode=#URLEncodedFormat(URL.ProgramCode)#&Period=#URLEncodedFormat(URL.Period)#" addtoken="No">		  

