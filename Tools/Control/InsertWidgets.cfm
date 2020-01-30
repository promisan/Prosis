

	<cfparam name="attributes.SystemModule"        default="">
	<cfparam name="attributes.FunctionClass"       default="">
	<cfparam name="attributes.FunctionName"        default="">
	<cfparam name="attributes.MenuClass"           default="">
	<cfparam name="attributes.MenuOrder"           default="">
	<cfparam name="attributes.FunctionMemo"        default="">
	<cfparam name="attributes.Operational"         default="">
	<cfparam name="attributes.FunctionDirectory"   default="">
	<cfparam name="attributes.FunctionPath"        default="">

	<cfparam name="attributes.EnforceUpdate"       default="">

	<cfoutput>

	
		<cfquery name="CheckWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT SystemModule, FunctionClass, FunctionName, MenuClass, MenuOrder, FunctionMemo, FunctionDirectory, FunctionPath, Operational
			FROM Ref_ModuleControl
			WHERE SystemModule = '#attributes.SystemModule#'
			AND FunctionClass  = '#attributes.FunctionClass#'
			AND FunctionName   = '#attributes.FunctionName#'
			AND MenuClass      = '#attributes.MenuClass#'
		</cfquery>
		
		<cfif CheckWidgets.recordcount eq "0">
		    <cfquery name="CreateWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">                                                                                                                                                   
		    	INSERT INTO Ref_ModuleControl (SystemModule, FunctionClass, FunctionName, MenuClass, MenuOrder, FunctionMemo, FunctionDirectory, FunctionPath, Operational)
		    	VALUES ('#attributes.SystemModule#', 
						'#attributes.FunctionClass#', 
						'#attributes.FunctionName#', 
						'#attributes.MenuClass#', 
						'#attributes.MenuOrder#', 
						'#attributes.FunctionMemo#', 
						'#attributes.FunctionDirectory#', 
						'#attributes.FunctionPath#', 
						'#attributes.Operational#')                                                                                                                                                                             
		    </cfquery> 
			
		<cfelseif CheckWidgets.recordcount eq "1" and attributes.EnforceUpdate neq "">
		
			<cfquery name="UpdateWidgets" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
				UPDATE Ref_ModuleControl
				SET MenuOrder='#attributes.MenuOrder#', FunctionMemo='#attributes.FunctionMemo#', FunctionDirectory='#attributes.FunctionDirectory#', FunctionPath='#attributes.FunctionPath#', Operational='#attributes.Operational#'
				WHERE SystemModule = '#attributes.SystemModule#'
				AND FunctionClass  = '#attributes.FunctionClass#'
				AND FunctionName   = '#attributes.FunctionName#'
				AND MenuClass      = '#attributes.MenuClass#'
			</cfquery>
		
		</cfif>

	 
	</cfoutput>    