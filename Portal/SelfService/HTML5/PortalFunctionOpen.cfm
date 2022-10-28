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
