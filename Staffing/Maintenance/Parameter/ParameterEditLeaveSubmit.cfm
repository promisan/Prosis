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
<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE 	Ref_ParameterMission
	SET 	OvertimePayroll   = '#Form.OvertimePayroll#', 
    		BatchLeaveBalance = '#Form.BatchLeaveBalance#',
			DisableTimesheet  = '#Form.DisableTimesheet#', 
			OfficerUserId 	  = '#SESSION.ACC#',
			OfficerLastName   = '#SESSION.LAST#',
			OfficerFirstName  = '#SESSION.FIRST#',
			Created           =  getdate()			
	WHERE 	Mission = '#url.mission#'	
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
<script>
	#ajaxLink('ParameterEditLeave.cfm?mission=#url.mission#&mid=#mid#')#	
</script>
</cfoutput>
