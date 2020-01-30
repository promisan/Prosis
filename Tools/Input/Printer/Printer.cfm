
<!--- obtain terminal devices (printers) connected to browsers loading this screen --->

<cfparam name="attributes.warehouse" default="">
<cfparam name="attributes.ajax" default="No">

<cfquery name="getPrinters" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
		SELECT DISTINCT TerminalName,_Type
		FROM   WarehouseTerminal
		WHERE  Warehouse = '#attributes.warehouse#'
		AND   Operational = '1'		
</cfquery>	

<cfif GetPrinters._Type eq "Applet">
	<cfoutput>
		<applet id="qz" name="qz"  archive="#client.root#/Scripts/qz-print/qz-print.jar" code="qz.PrintApplet.class" width="1" height="1">
			<param name="jnlp_href" value="#client.root#/Scripts/qz-print/qz-print_jnlp.jnlp">
			<param name="cache_option" value="plugin">
			<param name="disable_logging" value="false">
			<param name="initial_focus" value="false">
		</applet>
	</cfoutput>	
</cfif>

<div style="position:absolute;top:0;left:5;" id="_printer_message_"></div>

<cfset vPrinters = ValueList(getPrinters.TerminalName)>

<cfoutput>
	<input type="hidden" name="terminal" id="terminal" value="#vPrinters#">
	<input type="hidden" name="_printer_devices_" id="_printer_devices_" value="#vPrinters#">
</cfoutput>
	

