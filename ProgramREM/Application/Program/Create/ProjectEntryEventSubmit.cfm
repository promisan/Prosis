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
			DELETE FROM ProgramEvent
			WHERE  ProgramCode = '#ProgramCode#'  
			AND    ProgramEvent IN (SELECT Code FROM Ref_ProgramEvent WHERE ModeEntry = '1')	   			
	</cfquery>		
	
	<cfquery name="Events" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ProgramEvent 
			WHERE   Code IN (SELECT ProgramEvent
			                 FROM   Ref_ProgramEventMission	   
					  	     WHERE  Mission = '#Mission#') 
			AND     ModeEntry = '1'			  		
	</cfquery>					
	
	<cfloop query="Events">
	
		<cfset date = evaluate("Form.DateEvent_#Code#")>
		<CF_DateConvert Value="#date#">
		<cfset dte = dateValue>
	
		 <cfquery name="InsertEvent" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ProgramEvent
		        (ProgramCode,
				 ProgramEvent,
				 DateEvent,				
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	   	 VALUES ('#ProgramCode#',
				 '#code#',
				 #dte#,
				 '#SESSION.acc#',
	  			 '#SESSION.last#',		  
			  	 '#SESSION.first#')
	    </cfquery>
			
	</cfloop>