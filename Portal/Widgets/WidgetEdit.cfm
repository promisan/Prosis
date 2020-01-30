
<cfparam name="url.id" default="">
<cfparam name="url.delete" default="">

	<cfif url.delete neq "" and url.id neq "">

	<cfquery name="WidgetUpdate" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			UPDATE UserModule
			SET Status = '0'
			WHERE (SystemFunctionId = '#url.id#')
			AND Account = '#SESSION.acc#' 

	</cfquery>
	
	
	</cfif>
	