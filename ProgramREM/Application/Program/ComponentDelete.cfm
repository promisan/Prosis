
<!---
20/11/03	-	created: krw
21/11/03	- 	added register actions to record delete: krw
--->

<cfquery name="Select" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Program 
	WHERE  ProgramCode = '#URL.ProgramCode#'		
</cfquery>		

<cfquery name="DeleteComponent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE  ProgramPeriod 
	
	SET     RecordStatus = 9,
	        RecordStatusDate = getDate(),
			RecordStatusOfficer = '#session.acc#'
			
	WHERE   ProgramCode IN (SELECT ProgramCode 
	                        FROM   Program 
							WHERE  HierarchyCode LIKE '#SELECT.HierarchyCode#%'
	AND     Period = '#URL.Period#'  
	
</cfquery>		

	