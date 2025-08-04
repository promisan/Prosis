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


	<cfparam name="attributes.SystemModule"        default="">
	<cfparam name="attributes.FunctionClass"       default="">
	<cfparam name="attributes.FunctionName"        default="">
	<cfparam name="attributes.MenuClass"           default="">
	<cfparam name="attributes.MenuOrder"           default="">
	<cfparam name="attributes.FunctionMemo"        default="">
	<cfparam name="attributes.Operational"         default="">
	<cfparam name="attributes.FunctionDirectory"   default="">
	<cfparam name="attributes.FunctionPath"        default="">

	<cfparam name="attributes.EnforceUpdate"       default="">

	<cfoutput>

	
		<cfquery name="CheckWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT SystemModule, FunctionClass, FunctionName, MenuClass, MenuOrder, FunctionMemo, FunctionDirectory, FunctionPath, Operational
			FROM Ref_ModuleControl
			WHERE SystemModule = '#attributes.SystemModule#'
			AND FunctionClass  = '#attributes.FunctionClass#'
			AND FunctionName   = '#attributes.FunctionName#'
			AND MenuClass      = '#attributes.MenuClass#'
		</cfquery>
		
		<cfif CheckWidgets.recordcount eq "0">
		    <cfquery name="CreateWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">                                                                                                                                                   
		    	INSERT INTO Ref_ModuleControl (SystemModule, FunctionClass, FunctionName, MenuClass, MenuOrder, FunctionMemo, FunctionDirectory, FunctionPath, Operational)
		    	VALUES ('#attributes.SystemModule#', 
						'#attributes.FunctionClass#', 
						'#attributes.FunctionName#', 
						'#attributes.MenuClass#', 
						'#attributes.MenuOrder#', 
						'#attributes.FunctionMemo#', 
						'#attributes.FunctionDirectory#', 
						'#attributes.FunctionPath#', 
						'#attributes.Operational#')                                                                                                                                                                             
		    </cfquery> 
			
		<cfelseif CheckWidgets.recordcount eq "1" and attributes.EnforceUpdate neq "">
		
			<cfquery name="UpdateWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
				UPDATE Ref_ModuleControl
				SET MenuOrder='#attributes.MenuOrder#', FunctionMemo='#attributes.FunctionMemo#', FunctionDirectory='#attributes.FunctionDirectory#', FunctionPath='#attributes.FunctionPath#', Operational='#attributes.Operational#'
				WHERE SystemModule = '#attributes.SystemModule#'
				AND FunctionClass  = '#attributes.FunctionClass#'
				AND FunctionName   = '#attributes.FunctionName#'
				AND MenuClass      = '#attributes.MenuClass#'
			</cfquery>
		
		</cfif>

	 
	</cfoutput>    