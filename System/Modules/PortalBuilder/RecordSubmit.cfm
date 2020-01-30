
<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">

<cfquery name="validate" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.systemmodule#'
		AND		FunctionClass = '#url.functionClass#'
		AND		MenuClass = '#url.class#'
		AND		FunctionName = '#Form.FunctionName#'
</cfquery>

<cfset vOperational = 0>
<cfif isDefined("Form.Operational")>
	<cfset vOperational = 1>
</cfif>

<cfset vEnforceReload = 0>
<cfif isDefined("Form.EnforceReload")>
	<cfset vEnforceReload = 1>
</cfif>

<cfif url.id neq "">

	<cfif validate.recordCount gt 0 and Form.FunctionName neq Form.FunctionNameOld>
		
		<script>
			alert('This name already exists.  Please, enter a new name.');
		</script>
	
	<cfelse>

		<cfset vFunctionId = "#url.id#">
	
		<cfquery name="update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 UPDATE     Ref_ModuleControl
			 SET		FunctionName       	= '#Form.FunctionName#',
			 			MenuClass			= '#Form.MenuClass#',
			 			FunctionMemo       	= <cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">'#evaluate("Form.FunctionMemo_#client.languageId#")#'<cfelse>null</cfif>,
			 			FunctionBackground  = '#trim(Form.FunctionBackground)#',
			 			FunctionInfo 		= <cfif trim(Form.FunctionInfo) neq "">'#Form.FunctionInfo#'<cfelse>null</cfif>,
						FunctionDirectory 	= <cfif trim(Form.FunctionDirectory) neq "">'#Form.FunctionDirectory#'<cfelse>null</cfif>,
						FunctionPath 		= <cfif trim(Form.FunctionPath) neq "">'#Form.FunctionPath#'<cfelse>null</cfif>,
						FunctionCondition 	= <cfif trim(Form.FunctionCondition) neq "">'#Form.FunctionCondition#'<cfelse>null</cfif>,
						FunctionTarget 		= <cfif trim(Form.FunctionTarget) neq "">'#trim(Form.FunctionTarget)#'<cfelse><cfif trim(lcase(url.systemmodule)) eq "pmobile">''<cfelse>'right'</cfif></cfif>,
						EnableAnonymous		= '#Form.EnableAnonymous#',
						AccessDatasource	= <cfif trim(Form.AccessDatasource) neq "">'#Form.AccessDatasource#'<cfelse>null</cfif>,
						MenuOrder  			= #Form.MenuOrder#,
						Operational 		= #vOperational#,
						BrowserSupport		= '#Form.BrowserSupport#',
						FunctionContact  	= <cfif trim(Form.FunctionContact) neq "">'#replace(Form.FunctionContact," ","","ALL")#'<cfelse>null</cfif>,						
						EnforceReload		= #vEnforceReload#
						<cfif lcase(trim(form.MenuClass)) eq "layout" and lcase(trim(form.functionName)) eq "logo" and isDefined("Form.ScreenWidth")>
						,ScreenWidth		= <cfif trim(replace(Form.ScreenWidth,",","","ALL")) neq "">#replace(Form.ScreenWidth,",","","ALL")#<cfelse>50</cfif>
						</cfif>
						<cfif lcase(trim(form.MenuClass)) eq "layout" and lcase(trim(form.functionName)) eq "logo" and isDefined("Form.ScreenHeight")>
						,ScreenHeight		= <cfif trim(replace(Form.ScreenHeight,",","","ALL")) neq "">#replace(Form.ScreenHeight,",","","ALL")#<cfelse>50</cfif>
						</cfif>
			 WHERE		SystemFunctionId 	= '#url.id#'
		</cfquery>
		
		
		<!--- '#evaluate("Form.FunctionName_#client.languageId#")#', --->
		<!--- <cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Key1Value       = "#vFunctionId#"
			Key2Value       = "#url.mission#"
			Mode            = "Save"
			Name1           = "FunctionName"	
			Operational     = "1"> --->
	
		<cf_LanguageInput
			TableCode       		= "Ref_ModuleControl" 
			Key1Value       		= "#vFunctionId#"
			Key2Value       		= "#url.mission#"
			Mode            		= "Save"
			Name1           		= "FunctionMemo"	
			Operational       		= "1"
			ShowLanguageOperational = "#form.ShowLanguageOperational#"
			EnforceDefault          = "0">
		
		<!--- SET FUNCTIONNAME THE SAME FOR ALL LANGUAGES --->
		<cfif trim(form.functionName) neq "">
		
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 UPDATE Ref_ModuleControl_Language
				 SET 	FunctionName = '#Form.FunctionName#'
				 WHERE	SystemFunctionId = '#vFunctionId#'
			</cfquery>
		
		</cfif>
		
		<script>			 		
		 try {
			opener.document.getElementById('listing_refresh').click() } catch(e) {}	
		</script>		
		
		<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
			<cfoutput>
				<script>
					ColdFusion.navigate('RecordEditDetail.cfm?id=#url.id#&mission=#url.mission#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#','divMain');
				</script>
			</cfoutput>
		<cfelse>
			<cfoutput>
				<script>	
					opener.ColdFusion.navigate("RecordListingClass.cfm?name=#url.functionClass#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#","div#url.class#");    
					window.close();
				</script>
			</cfoutput>
		</cfif>
	
	</cfif>
		
<cfelse>

	<cfif validate.recordCount gt 0>
			
		<script>
			alert('This name already exists.  Please, enter a new name.');
		</script>
	
	<cfelse>

		<cf_AssignId>
		
		<cfset vFunctionId = rowguid>
		
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 INSERT INTO Ref_ModuleControl (
					SystemFunctionId,
					SystemModule,
					FunctionClass,
					MenuClass,
					MenuOrder,
					FunctionName,
					<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">FunctionMemo,</cfif>
					FunctionBackground,
					<cfif trim(Form.FunctionInfo) neq "">FunctionInfo,</cfif>
					<cfif trim(Form.FunctionDirectory) neq "">FunctionDirectory,</cfif>
					<cfif trim(Form.FunctionPath) neq "">FunctionPath,</cfif>
					<cfif trim(Form.FunctionCondition) neq "">FunctionCondition,</cfif>
					<cfif trim(Form.FunctionTarget) neq "">FunctionTarget,</cfif>
					<cfif trim(Form.AccessDatasource) neq "">AccessDatasource,</cfif>
					<cfif lcase(trim(form.MenuClass)) eq "layout" and lcase(trim(form.functionName)) eq "logo">
					ScreenWidth,
					ScreenHeight,
					</cfif>
					Operational,
					BrowserSupport,
					<cfif trim(Form.FunctionContact) neq "">FunctionContact,</cfif>
					EnforceReload,
					OfficerUserId,
					OfficerFirstName,
					OfficerLastName
				) VALUES (
					'#vFunctionId#',
					'#url.systemmodule#',
					'#url.functionClass#',
					'#Form.menuClass#',
					#Form.menuOrder#,
					'#Form.FunctionName#',
					<cfif trim(evaluate("Form.FunctionMemo_#client.languageId#")) neq "">'#evaluate("Form.FunctionMemo_#client.languageId#")#',</cfif>
					'#trim(Form.FunctionBackground)#',
					<cfif trim(Form.FunctionInfo) neq "">'#Form.FunctionInfo#',</cfif>
					<cfif trim(Form.FunctionDirectory) neq "">'#Form.FunctionDirectory#',</cfif>
					<cfif trim(Form.FunctionPath) neq "">'#Form.FunctionPath#',</cfif>
					<cfif trim(Form.FunctionCondition) neq "">'#Form.FunctionCondition#',</cfif>
					<cfif trim(Form.FunctionTarget) neq "">'#trim(Form.FunctionTarget)#',</cfif>
					<cfif trim(Form.AccessDatasource) neq "">'#Form.AccessDatasource#',</cfif>
					<cfif lcase(trim(form.MenuClass)) eq "layout" and lcase(trim(form.functionName)) eq "logo" and isDefined("Form.ScreenWidth") and isDefined("Form.ScreenHeight")>
					#replace(Form.ScreenWidth,",","","ALL")#,
					#replace(Form.ScreenHeight,",","","ALL")#,
					</cfif>
					#vOperational#,
					'#Form.BrowserSupport#',
					<cfif trim(Form.FunctionContact) neq "">'#replace(Form.FunctionContact," ","","ALL")#',</cfif>
					#vEnforceReload#,
					'#SESSION.acc#',
					'#SESSION.first#',
					'#SESSION.last#' 
				)
		</cfquery>
		
		<cf_LanguageInput
			TableCode       		= "Ref_ModuleControl" 
			Key1Value       		= "#vFunctionId#"
			Key2Value      		 	= "#url.mission#"
			Mode           		 	= "Save"
			Name1           		= "FunctionMemo"	
			Operational     		= "1"
			ShowLanguageOperational = "#form.ShowLanguageOperational#">
			
		<!--- SET FUNCTIONNAME THE SAME FOR ALL LANGUAGES --->
		<cfif trim(form.functionName) neq "">
		
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 UPDATE Ref_ModuleControl_Language
				 SET 	FunctionName = '#Form.FunctionName#'
				 WHERE	SystemFunctionId = '#vFunctionId#'
			</cfquery>
		
		</cfif>
		
		<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
			<cfset vDefaultDirectory = "Custom/Portal/#Form.FunctionName#/">
			<cfif not DirectoryExists("#SESSION.rootpath##vDefaultDirectory#")>
				<cfdirectory action="create" directory="#SESSION.rootpath##vDefaultDirectory#">
			</cfif>
			
			<cfif trim(lcase(url.systemmodule)) neq "pmobile">
				<cfset url.contextFunctionName = Form.FunctionName>
				<cfinclude template="RecordSubmitDefaultValues.cfm">
			</cfif>
		</cfif>
		
		<cfoutput>
			<script>	
			    try {
				opener.document.getElementById('listing_refresh').click() } catch(e) {}
				if (opener.document.getElementById('div#url.class#')) {	
					opener.ColdFusion.navigate("RecordListingClass.cfm?name=#url.functionClass#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#","div#url.class#");
				}
				window.close();
			</script>
		</cfoutput>
	
	</cfif>
	
</cfif>
