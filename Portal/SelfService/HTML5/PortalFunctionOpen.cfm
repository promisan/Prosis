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
<cf_param name="url.MenuClass" 			default="process" type="String">
<cf_param name="url.mid" 	   	 		default="mid" type="String">
<cf_param name="url.id" 	    		default=""    type="String">
<cf_param name="url.SystemFunctionId" 	default=""    type="String">
<cf_param name="url.Public"         	default="internal"  type="String">

<cfquery name="Menu" 
	datasource="AppsSystem">
		SELECT 	 *
		FROM   	 #CLIENT.LanPrefix#Ref_ModuleControl
		WHERE  	 SystemModule   	 = 'SelfService'
		AND    	 FunctionClass  	 = '#url.id#'
		AND    	 MenuClass      	 = '#url.menuClass#'
		AND    	 Operational 	 = 1
		AND	   	 SystemFunctionId = '#url.SystemFunctionId#'
		<cfif url.public eq "external">
		AND      MenuOrder != '0' 
		</cfif>
		ORDER BY MenuOrder  
				
</cfquery>

<cfif trim(menu.functionpath) neq "">

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
  	<cfinclude template="../../../#Menu.FunctionDirectory#/#Menu.FunctionPath#">
	
</cfif>
