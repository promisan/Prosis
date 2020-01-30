
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

	<cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_ReportControl
		SET   TemplateBoxes     = '#Form.TemplateBoxes#'
		WHERE ControlId = '#URL.ID#'
		</cfquery>
	
		
	<cfif ParameterExists(Form.Update)>
	
		<script language="JavaScript">
		 opener.history.go() 
	     window.location = "RecordEdit.cfm?Id=<cfoutput>#URL.ID#</cfoutput>"
		 <cfif ParameterExists(Form.Update)>
		 alert("Global parameters have been saved.")
		 </cfif>
		</script>  
	
	<cfelse>
	
		<script language="JavaScript">
		
		 opener.history.go() 		
		 window.close()
		
		</script>
	
	</cfif>
	
		

	
