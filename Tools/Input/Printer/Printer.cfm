
<!--- obtain terminal devices (printers) connected to browsers loading this screen --->

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
	

