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
<cfset row = 0>

<cfparam name="form.LocationCode" default="""">

<cfoutput>
<cfloop index="loc" list="#Form.LocationCode#">

	<cfset row = row+1>

	<cfquery name="getName" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   Code,Name,
			         LocationCode,
					 L.Description,Continent,'' as LocationDefault
			FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
			WHERE    L.LocationCountry = N.Code		
			AND      LocationCode = '#loc#'
		</cfquery>		
				
	<cfif row gt "1">;&nbsp;</cfif><cfoutput>#getName.Name# #getName.Description#</cfoutput>

</cfloop>
</cfoutput>
