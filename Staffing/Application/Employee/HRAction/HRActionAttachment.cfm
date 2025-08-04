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
<cfoutput>
			
	<!--- Query returning search results --->
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Parameter
	</cfquery>
	
	<cf_filelibraryN
		DocumentPath = "#Parameter.DocumentLibrary#"
		SubDirectory = "#url.id#" 
		Filter       = "HRAction_#left(url.ActionId,8)#"
		LoadScript   = "No"
		attachdialog = "yes"
		Insert       = "yes"
		Remove       = "yes"
		Listing      = "yes">


</cfoutput>			