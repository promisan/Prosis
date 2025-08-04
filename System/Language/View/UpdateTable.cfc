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

<cfcomponent displayname="Language Initialization">
	
	<cffunction access="public" name="Table" 
	          output="true" 
			  returntype="string" 
			  displayname="Create language reference table">
			
			<cfargument name="TableCode"      default="">
			<cfargument name="SystemModule"   default="">
			<cfargument name="DataSource"     default="">
			<cfargument name="TableName"      default="#TableCode#">
			<cfargument name="InterfaceTable" default="0">
			<cfargument name="KeyFieldName"   default="">
			<cfargument name="KeyFieldName2"  default="">
			<cfargument name="KeyFieldName3"  default="">
			<cfargument name="KeyFieldName4"  default="">
			<cfargument name="Fields"  default="Description">
			
			<!--- check role --->
			
						<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO LanguageSource
						(TableCode, 
						DataSource, 
						SystemModule,
						TableName, 
						InterfaceTable, 
						KeyFieldName, 
						KeyFieldName2, 
						KeyFieldName3, 
						KeyFieldName4)					
				VALUES('#TableCode#',
						'#DataSource#', 
						'#SystemModule#',
						'#TableName#', 
						'#InterfaceTable#', 
						'#KeyFieldName#', 
						'#KeyFieldName2#', 
						'#KeyFieldName3#', 
						'#KeyFieldName4#')
			</cfquery>
			
			<cfloop index="itm" list="#Fields#" delimiters=",">
			
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO LanguageSourceField
						(TableCode, 
						TranslationField)
				VALUES('#TableCode#','#itm#')
			</cfquery>			
						
			</cfloop>
			
	
	</cffunction>
	
</cfcomponent>