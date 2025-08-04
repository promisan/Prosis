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
<cfparam name="url.EntityCode"  default="">
<cfparam name="url.EntityClass" default="">

<cfoutput>

<cfquery name="RestoreLog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE R
		SET 	ActionParent  = L.ActionParent,
				ActionGoToYes = L.ActionGoToYes,
				ActionGoToNo  = L.ActionGoToNo
		FROM 	Ref_EntityClassAction R 
		        INNER JOIN Ref_EntityClassActionLog L ON R.ActionCode = L.ActionCode AND R.EntityCode = L.EntityCode AND R.EntityClass = L.EntityClass 
		WHERE   R.EntityCode = '#URL.EntityCode#' 
		AND     R.EntityClass = '#URL.EntityClass#' 
	</cfquery>

</cfoutput>			

<cfoutput>
	<script language="JavaScript">
		alert("The Workflow configuration was successfully restored.")
		window.location = "FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#"
	</script>
</cfoutput>
			  
</body>