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

<cfparam name="URL.ActivityID" default="">
<cfparam name="URL.UserAccess" default="">

<cfif URL.UserAccess neq "ALL">

	<cfquery name="Progress" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	Select ProgressId
	FROM   ProgramActivity P 
	       INNER JOIN ProgramActivityOutput PO ON P.ActivityID = PO.ActivityID AND PO.RecordStatus != 9 
           INNER JOIN ProgramActivityProgress PA ON PO.OutputID = PA.OutputID AND PA.RecordStatus != 9
	WHERE  P.RecordStatus != 9 
	AND    P.ActivityID = '#URL.ActivityId#'		  		
	</cfquery>		

	<cfif #Progress.RecordCount# neq 0>			
		DELETION DENIED:  Must have Manager Access to delete Activities that contain active progress reports
	</cfif>	

<cfelse>

	<cfquery name="DeleteActivity" 
		datasource="AppsProgram" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		Update ProgramActivity
		    Set RecordStatus = 9
			WHERE ActivityId = '#URL.ActivityId#'		  
		</cfquery>		

		<cfoutput>

	<script language="JavaScript">
	 window.location="../ActivityProgram/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#";
	</script>
	</cfoutput>
	
</cfif>	
