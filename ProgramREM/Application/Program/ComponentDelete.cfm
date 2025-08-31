<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

	