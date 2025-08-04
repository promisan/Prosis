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

<TITLE>Preferences submit</TITLE>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

<cfparam name="Form.EnableMailHolder" default="0">

<cfquery name="UpdateUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   UserNames 
SET      eMailAddressExternal     = '#Form.eMailAddressExternal#'
WHERE    Account = '#SESSION.acc#'
</cfquery>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE  UserEntitySetting
SET     EnableMailHolder = '#Form.EnableMailHolder#'
WHERE   Account    = '#SESSION.acc#' 
AND     EntityCode = '#URL.EntityCode#'
</cfquery>
		
<cfquery name="System" 
	datasource="AppsSystem">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemModule = 'SelfService'
	AND   FunctionClass IN ('SelfService','Report')
	AND   FunctionName = '#URL.ID#' 
</cfquery>
										
<cfoutput>
	<script language="JavaScript">
		window.location = "#SESSION.root#/#System.FunctionDirectory#/#System.FunctionPath#?ID=#URL.ID#&#system.FunctionCondition#"
	</script>
</cfoutput>
	