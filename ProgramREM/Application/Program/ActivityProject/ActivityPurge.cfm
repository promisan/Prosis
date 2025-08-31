<!--
    Copyright © 2025 Promisan B.V.

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
<CF_RegisterAction 
SystemFunctionId="0101" 
ActionClass="Activity" 
ActionType="Delete" 
ActionReference="#URL.ProgramCode# #URL.Period# #URL.ActivityID#" 
ActionScript="">

<cfparam name="URL.ActivityID" default="">
<cfparam name="URL.UserAccess" default="">

<cfif URL.UserAccess neq "ALL">

	<cfquery name="Progress" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	Select ProgressId
		From ProgramActivity P INNER JOIN ProgramActivityOutput PO
			ON P.ActivityID = PO.ActivityID AND PO.RecordStatus != 9 
		INNER JOIN ProgramActivityProgress PA
			ON PO.OutputID = PA.OutputID AND PA.RecordStatus != 9
		Where P.RecordStatus != 9 
		AND P.ActivityID = '#URL.ActivityId#'		  		
	</cfquery>		

	<cfif Progress.RecordCount neq 0>
	
		<CF_RegisterAction 
		SystemFunctionId="0101" 
		ActionClass="Activity" 
		ActionType="Deletion denied" 
		ActionReference="#URL.ProgramCode# #URL.Period# #URL.ActivityID#" 
		ActionScript="">
		
		DELETION DENIED:  Must have Manager Access to delete Activities that contain active progress reports
	</cfif>	

<cfelse>

	<cfquery name="DeleteActivity" 
		datasource="AppsProgram" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		UPDATE ProgramActivity
		    SET RecordStatus = 9
			WHERE ActivityId = '#URL.ActivityId#'		  
		</cfquery>		

	<!--- mark record for deletion in translation table --->	 
	<cfquery name="Languages" 
		datasource="AppsSystem" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		SELECT LanguageCode
		FROM Ref_Language
		WHERE Operational = '1'
		</cfquery>		

	<cfloop Query="Languages">
		<cfquery name="DeleteActivity" 
			datasource="AppsProgram" 
			username=#SESSION.login# 
			password=#SESSION.dbpw#>
			UPDATE xl#LanguageCode#_ProgramActivity
			    SET RecordStatus = 9
				WHERE ActivityId = '#URL.ActivityId#'		  
			</cfquery>		
	</cfloop>

	<cfoutput>

	<script language="JavaScript">
	 window.location="../Activity/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#";
	</script>
	</cfoutput>
	
</cfif>
	