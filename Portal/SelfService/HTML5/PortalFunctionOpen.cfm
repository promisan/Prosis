<cf_param name="url.MenuClass" 			default="process" type="String">
<cf_param name="url.mid" 	   	 		default="mid" type="String">
<cf_param name="url.id" 	    		default=""    type="String">
<cf_param name="url.SystemFunctionId" 	default=""    type="String">

<cfquery name="Menu" 
	datasource="AppsSystem">
		SELECT 	 *
		FROM   	 #CLIENT.LanPrefix#Ref_ModuleControl
		WHERE  	 SystemModule   	 = 'SelfService'
		AND    	 FunctionClass  	 = '#url.id#'
		AND    	 MenuClass      	 = '#url.menuClass#'
		AND    	 Operational 	 = 1
		AND	   	 SystemFunctionId = '#url.SystemFunctionId#'
		ORDER BY MenuOrder  
</cfquery>

<cfif trim(menu.functionpath) neq "">

  <cfinclude template="../../../#Menu.FunctionDirectory#/#Menu.FunctionPath#">
	
</cfif>
