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
<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramStatus
		WHERE  ProgramCode    = '#url.ProgramCode#' 
		AND    ProgramStatus  IN (SELECT Code 
		                          FROM   Ref_ProgramStatus 
								  WHERE  StatusClass = '#url.statusclass#')				   			
</cfquery>		

<cfif url.programStatus neq "">			
	 		
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
			 VALUES   ('#url.ProgramCode#',
					   '#url.programstatus#',
					   '#SESSION.acc#',
			  		   '#SESSION.last#',		  
					   '#SESSION.first#')
	    </cfquery>
		
</cfif>	