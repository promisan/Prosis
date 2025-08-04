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
	
	<cfquery name="Last" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM ItemUoM
		WHERE ItemNo = '#Attributes.ItemNo#'
		AND    UoM LIKE '__'
		ORDER BY UoM DESC				
	</cfquery>
	
	<cfif Last.UoM neq "">							
		<cfset UoM = Last.UoM+1>
	<cfelse>
	    <cfset UoM = 1>
	</cfif>	
	<cfif UoM lt 10>
	     <cfset UoM = 10+UoM>
	</cfif>
			
	<CFSET Caller.UoM = UoM>		
