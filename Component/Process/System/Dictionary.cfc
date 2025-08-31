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
<cfcomponent>
	

	
	
	<cffunction name="getDescription" access="remote" returnFormat="plain" output="false">	
		<cfargument name="item"   type="string" required="false" default="">
		
			<cfquery name="qDescription" datasource="AppsSystem">
				SELECT Description,ModuleMemo
				FROM Ref_SystemModule
				WHERE SystemModule = '#ARGUMENTS.item#'
			</cfquery>	


			<cfset str = Wrap(qDescription.ModuleMemo,30)>
			<cfset str = replace(str,chr(13)&chr(10),chr(10),"ALL")>
			<cfset str = replace(str,chr(13),chr(10),"ALL")>
			<cfset str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL")>
			<cfset str = replace(str,chr(10),"","ALL")>

			<cfreturn "<h5>#qDescription.Description#</h5>#qDescription.ModuleMemo#">			
	</cffunction>
	
		
</cfcomponent>