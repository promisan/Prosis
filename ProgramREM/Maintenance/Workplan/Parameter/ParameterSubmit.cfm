<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Parameter
	SET PasNo                  = '#Form.PasNo#',
	    ApplicationName        = '#Form.ApplicationName#',
		TemplateRoot           = '#Form.TemplateRoot#',
		TemplateHome           = '#Form.TemplateHome#',  
		PeriodDefault          = '#Form.PeriodDefault#', 
		NoTasks                = '#Form.NoTasks#', 
		MinTasks               = '#Form.MinTasks#',
		<!---
		EnforceClosing         = '#Form.EnforceClosing#',
		--->
		ShowCalendar           = '#Form.ShowCalendar#',
		LanguageCode           = '#Form.LanguageCode#',
		HideObjective          = '#Form.HideObjective#',
		HideTraining           = '#Form.HideTraining#'
	WHERE ParameterKey      = '#Form.ParameterKey#'
	</cfquery>

<script>
	alert('Parameters have been saved!');
</script>
	
</cfif>