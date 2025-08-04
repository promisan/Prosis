<!--
    Copyright © 2025 Promisan

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
<!--- -------------------- --->
<!--- create status record --->
<!--- -------------------- --->
	
<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramStatus
		WHERE  ProgramCode = '#ProgramCode#'  				   			
</cfquery>		

<cfquery name="StatusClass" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DISTINCT StatusClass
	FROM    Ref_ProgramStatus 
	WHERE   Code IN (SELECT ProgramStatus
	                 FROM   Ref_ProgramStatusMission	   
			  	     WHERE  Mission = '#Mission#') 				  		
</cfquery>					

<cfloop query="StatusClass">

	 <cfset fld = replaceNoCase(StatusClass," ","","ALL")>

	 <cfparam name="Form.Status#fld#" default="">
	 <cfset val = evaluate("Form.Status#fld#")>
	 
	 <cfif val neq  "">		 	 
		
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
		   	 VALUES ('#ProgramCode#',
					 '#val#',
					 '#SESSION.acc#',
		  			 '#SESSION.last#',		  
				  	 '#SESSION.first#')
	    </cfquery>
	
	</cfif>
	
</cfloop>		