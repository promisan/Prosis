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
<cf_textareascript>
<cfajaximport tags="cfform,cfdiv">

<cfquery name="GetFunction" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT	*
	FROM	Ref_ModuleControl
	WHERE	SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="GetRole" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_AuthorizationRole  
	WHERE  Role = '#URL.Role#'
</cfquery>

<!---
<cf_screentop label="Grant Function/Role to Mission" option="[#GetFunction.SystemModule#  [#GetRole.Role# - #GetRole.Description#]" jquery="yes" height="100%" banner="yellow" scroll="Yes" layout="webapp" user="no">
--->

<cf_securediv id="irolen" bind="url:RecordMissionListingDetail.cfm?functionId=#URL.ID#&role=#url.Role#&allType=#url.allType#">