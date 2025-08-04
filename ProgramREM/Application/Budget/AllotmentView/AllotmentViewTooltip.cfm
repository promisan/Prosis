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

						
<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * FROM Program
	WHERE ProgramCode = '#URL.Programcode#'
</cfquery>	

<cfif Program.ProgramDescription eq "">

	<cfoutput>
	<table><tr><td width="200" align="center">No additional information available</td></tr></table>
	</cfoutput>

<cfelse>

	<cfoutput>
	<table><tr><td>#Program.ProgramDescription#</td></tr></table>
	</cfoutput>
	
</cfif>	
