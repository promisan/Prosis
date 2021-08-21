	 <cfquery name="Layout" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControl R
	    WHERE     FunctionName = 'FunctionViewListing'
		AND       TemplateSQL  = 'Application'
	</cfquery>
	
	<cfif Layout.recordcount eq "0">
	
		<cf_assignid>
		
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ReportControl
					(ControlId,
					 SystemModule, 
					 FunctionClass, 
					 FunctionName, 
					 ReportRoot,					 
					 TemplateSQL, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
			 VALUES ('#rowGuid#',
			         'Roster',
			         'Reports',
					 'FunctionViewListing',					 
					 'Application',
					 'Application',
			         '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
			</cfquery>	
			
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControlOutput
						(ControlId, 					 
						 DataSource, 
						 OutputClass,
						 VariableName, 
						 OutputName, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName) 
				 VALUES ('#rowguid#',					 
					     'appsQuery',
					     'variable',
					     'table1', 
					     'Candidates in Bucket',
					     '#SESSION.acc#',
					     '#SESSION.last#',
					     '#SESSION.first#')
			</cfquery>

	
	</cfif>
	
	 <cfquery name="Layout" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControl R
	    WHERE     FunctionName = 'FunctionViewListing'
		AND       TemplateSQL  = 'Application'
	</cfquery>
	
	<cfset URL.ControlId = Layout.ControlId>
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>  

	<cfoutput>
		<script language="JavaScript">		
	  	  window.location = "#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcel.cfm?mid=#mid#&table1=#SESSION.acc#Roster_#FileNo#&controlid=#Layout.ControlId#"		 		 
		</script>
	</cfoutput>
