
<cfcomponent displayname="Language Initialization">
	
	<cffunction access="public" name="Table" 
	          output="true" 
			  returntype="string" 
			  displayname="Create language reference table">
			
			<cfargument name="TableCode"      default="">
			<cfargument name="SystemModule"   default="">
			<cfargument name="DataSource"     default="">
			<cfargument name="TableName"      default="#TableCode#">
			<cfargument name="InterfaceTable" default="0">
			<cfargument name="KeyFieldName"   default="">
			<cfargument name="KeyFieldName2"  default="">
			<cfargument name="KeyFieldName3"  default="">
			<cfargument name="KeyFieldName4"  default="">
			<cfargument name="Fields"  default="Description">
			
			<!--- check role --->
			
						<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO LanguageSource
						(TableCode, 
						DataSource, 
						SystemModule,
						TableName, 
						InterfaceTable, 
						KeyFieldName, 
						KeyFieldName2, 
						KeyFieldName3, 
						KeyFieldName4)					
				VALUES('#TableCode#',
						'#DataSource#', 
						'#SystemModule#',
						'#TableName#', 
						'#InterfaceTable#', 
						'#KeyFieldName#', 
						'#KeyFieldName2#', 
						'#KeyFieldName3#', 
						'#KeyFieldName4#')
			</cfquery>
			
			<cfloop index="itm" list="#Fields#" delimiters=",">
			
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO LanguageSourceField
						(TableCode, 
						TranslationField)
				VALUES('#TableCode#','#itm#')
			</cfquery>			
						
			</cfloop>
			
	
	</cffunction>
	
</cfcomponent>