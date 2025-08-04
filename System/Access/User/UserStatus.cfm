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

<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE UserNames
	SET    Disabled = '#url.status#'
    WHERE  Account  = '#URL.Account#'
</cfquery>

<cfoutput>

<cfif url.status eq "0">
	<a title="Press to disable" href="javascript:ColdFusion.navigate('UserStatus.cfm?account=#url.account#&status=1','userstatus')">
	<font size="2" color="green"><u>Active
	</a>
<cfelse>
	<a title="Press to activate" href="javascript:ColdFusion.navigate('UserStatus.cfm?account=#url.account#&status=0','userstatus')">
	<font size="2" color="FF0000"><u>Disabled</b></font>
	</a>&nbsp;&nbsp;&nbsp;<font color="gray"><cf_UIToolTip tooltip="This applies for Backoffice only. User might still access a Portal.">( Backoffice only )</cf_UIToolTip></font>
</cfif>

</cfoutput>


