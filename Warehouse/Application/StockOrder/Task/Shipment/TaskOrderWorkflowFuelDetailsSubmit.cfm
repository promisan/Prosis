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
<cfparam name="URL.ID" default = "">

<cfif URL.ID neq "">
	<cfquery name = "qInit" datasource = "AppsMaterials">
		DELETE FROM TaskOrderDetail
		WHERE StockOrderId = '#URL.ID#'
	</cfquery>
		
	<cfset cnt = 1>
	<cfset i = 1>
	<cfloop list="#Form.Reference1#" index="element">
		
		<cfset element  = #replace(element,'null','')#>
		<cfset element2 = #replace(trim(listGetAt(FORM['reference2'], cnt)),'null','')#>		
		<cfset element3 = #replace(trim(listGetAt(FORM['reference3'], cnt)),'null','')#>		
		
		<cfif element neq "" or element2 neq "" or element3 neq "">
			<cfquery name = "qInsert" datasource = "AppsMaterials">
				INSERT INTO TaskOrderDetail (StockOrderId,DetailNo,Reference1,Reference2, Reference3,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES ('#URL.ID#',#i#,'#element#','#element2#','#element3#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			</cfquery>
			<cfset i = i + 1>
		</cfif>
		<cfset cnt = cnt + 1>
		
	</cfloop>	

</cfif>

<cf_compression>