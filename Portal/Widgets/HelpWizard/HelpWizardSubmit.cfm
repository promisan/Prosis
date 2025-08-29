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
<cfoutput>
<cfif url.id neq "">
	<cfif url.process eq "Delete"> 
		<cfquery name="HelpWizardUpdate" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModule
				SET    Status   = '0'
				WHERE  SystemFunctionId = '#url.id#'
				AND    Account = '#SESSION.acc#'
		</cfquery>	
	<cfelseif url.process eq "Complete">
		<cfquery name="HelpWizardUpdate" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserModule
				SET    Status   = '3'
				WHERE  SystemFunctionId = '#url.id#'
				AND    Account = '#SESSION.acc#'
		</cfquery>
	</cfif>
</cfif>
</cfoutput>
	