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

<cfparam name="URL.OutputID" default="">
<cfparam name="URL.UserAccess" default="">

<cfif URL.UserAccess neq "ALL">

	<cfquery name="Progress" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	SELECT ProgressId
		FROM ProgramActivityOutput PO INNER JOIN ProgramActivityProgress PA
			ON PO.OutputID = PA.OutputID AND (PA.RecordStatus != 9 or PA.RecordStatus is NULL)
		Where (PO.RecordStatus != 9 OR PO.RecordStatus is NULL)
		AND PO.OutputID = '#URL.OutputId#'		  		
	</cfquery>		

	<cfif #Progress.RecordCount# neq 0>
			
		 <cf_message message = "DELETION DENIED:  Must have Manager Access to delete Outputs that contain active progress reports"
  return = "back">
  <cfabort>
		
	</cfif>	

<cfelse>

	<cfquery name="DeleteOutput" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	UPDATE ProgramActivityOutput 
		SET RecordStatus = 9
		WHERE OutputId = '#URL.OutputId#'		  
	</cfquery>	
		
	<cfoutput>

	<script language="JavaScript">
	 window.location="../ActivityProgram/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#";
	</script>
	</cfoutput>
	
</cfif>
