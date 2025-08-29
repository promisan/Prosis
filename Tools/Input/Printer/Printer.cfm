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
<cfparam name="attributes.warehouse" default="">
<cfparam name="attributes.ajax" default="No">

<cfquery name="getPrinters" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
		SELECT DISTINCT TerminalName
		FROM   WarehouseTerminal
		WHERE  Warehouse = '#attributes.warehouse#'
		AND   Operational = '1'		
</cfquery>

<cfif getPrinters.recordcount gt 1>
	<cfquery name="getPrinters"
			datasource="AppsMaterials"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT DISTINCT TerminalName
		FROM   WarehouseTerminal
		WHERE  Warehouse = '#url.warehouse#'
	AND TaxOrgUnitEDI IS NOT NULL
	AND    Operational = '1'
	</cfquery>
</cfif>

<div style="position:absolute;top:0;left:5;" id="_printer_message_"></div>

<cfset vPrinters = ValueList(getPrinters.TerminalName)>

<cfoutput>
	<input type="hidden" name="terminal" id="terminal" value="#vPrinters#">
	<input type="hidden" name="_printer_devices_" id="_printer_devices_" value="#vPrinters#">
</cfoutput>
	

