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
UPDATE Ref_ParameterMission
SET PersonActionPrefix     = '#Form.PersonActionPrefix#',
	PersonActionNo         = '#Form.PersonActionNo#',
	PersonActionEnable     = '#Form.PersonActionEnable#',
	BatchStepIncrement     = '#Form.BatchStepIncrement#',
	DisableSPA             = '#Form.DisableSPA#',
	PersonActionTemplate   = '#Form.PersonActionTemplate#',
	OfficerUserId 	 	   = '#SESSION.ACC#',
	OfficerLastName  	   = '#SESSION.LAST#',
	OfficerFirstName 	   = '#SESSION.FIRST#',
	Created          	   =  getdate()	
WHERE Mission              = '#url.Mission#'
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>
<script>
	#ajaxLink('ParameterEditContract.cfm?mission=#url.mission#&mid=#mid#')#	
</script>
</cfoutput>
