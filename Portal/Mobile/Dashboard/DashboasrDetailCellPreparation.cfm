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
<cfset vQuery = trim(UCase(CellValueQuery))>
<cfset vCellResultString = "--">

<cfif vQuery neq "">

	<cfset vQuery = replace(vQuery, "@ID", "#url.systemfunctionid#", "ALL")>
	<cfset vQuery = replace(vQuery, "@MISSION", "#url.mission#", "ALL")>
	<cfset vQuery = replace(vQuery, "@USER", "#session.acc#", "ALL")>
	<cfset vQuery = replace(vQuery, "@TODAY", "GETDATE()", "ALL")>
	
	<cfquery name="getCellResult" 
		datasource="#CellValueDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		 
			#preserveSingleQuotes(vQuery)#
	</cfquery>
	
	<cfset vCellResult = evaluate("getCellResult.#CellValueField#")>
	
	<cfif lcase(CellValueFormat) eq "number">
		<cfset vCellResultString = lsNumberFormat(vCellResult, ",")>
	</cfif>
	
	<cfif lcase(CellValueFormat) eq "currency">
		<cfset vCellResultString = lsNumberFormat(vCellResult, ",.__")>
		<cfset vCellResultString = "#application.baseCurrency# #vCellResultString#">
	</cfif>
	
	<cfif lcase(CellValueFormat) eq "text">
		<cfset vCellResultString = vCellResult>
	</cfif>

</cfif>