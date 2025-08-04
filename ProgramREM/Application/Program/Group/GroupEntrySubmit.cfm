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


<cfquery name="ResetGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE From ProgramGroup
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
	SELECT ProgramGroup
	FROM   ProgramGroup
	WHERE  ProgramCode = '#Form.ProgramCode#' 
	AND    ProgramGroup = '#Item#'
</cfquery>

<cfif VerifyGroup.recordCount is 1 > 
	
	<cfquery name="UpdateGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  ProgramGroup
		SET 	Status = '1', 
				OfficerUserId    = '#SESSION.acc#',
				OfficerLastName  = '#SESSION.last#',
				OfficerFirstName = '#SESSION.first#'
		WHERE   ProgramCode      = '#Form.ProgramCode#' 
		AND     ProgramGroup     = '#Item#'
	</cfquery>

<cfelse>
	
	<cfquery name="InsertGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO ProgramGroup 
	    	     (ProgramCode,
				 ProgramGroup,
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


