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

<TITLE>Sector</TITLE>
 
<!--- Insert Function --->   

<cfquery name="ResetSector" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE From ProgramSector
	WHERE ProgramCode = '#Form.ProgramCode#'
</cfquery>

<cfparam name="Form.ProgramSector" type="any" default="">

<cfloop index="Item" 
        list="#Form.ProgramSector#" 
        delimiters="' ,">

<cfquery name="VerifyGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT ProgramSector
	FROM   ProgramSector
	WHERE ProgramCode = '#Form.ProgramCode#' AND ProgramSector = '#Item#'
</cfquery>

<CFIF VerifyGroup.recordCount is 1 > 

<cfquery name="UpdateGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  ProgramSector
	SET     Status = '1'
	WHERE   ProgramCode = '#Form.ProgramCode#' 
	AND     ProgramSector = '#Item#'
</cfquery>

<cfelse>

<cfquery name="InsertGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO ProgramSector 
	         (ProgramCode,
			 ProgramSector,
			 Status,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#Form.ProgramCode#', 
	      	  '#Item#',
		      '1',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
		  </cfquery>
</cfif>

</cfloop>		


