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

<!--- set --->

<cfswitch expression="#url.field#">

<cfcase value="mailscope">

	<cfquery name="set" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE OrganizationObjectActionMail
		SET #url.field# = '#url.value#'
		WHERE  ThreadId  = '#url.Threadid#'
		AND    SerialNo  = '#url.serialNo#'		
	</cfquery>
	
	<cfoutput>
	
		<cfif url.value eq "all">
			<font color="gray"><u><cf_tl id="public"></u></font>
			<input type="hidden" id="mailscope_#url.threadid#_#url.serialno#" value="support">
		<cfelse>
		    <font color="6688aa"><u><cf_tl id="support"></u></font>
			<input type="hidden" id="mailscope_#url.threadid#_#url.serialno#" value="all">
		</cfif>
	
	</cfoutput>

</cfcase>

</cfswitch>