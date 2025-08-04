<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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