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
<cfset vPortalAccess = 0>
<cfif AccessToPortal.recordCount eq 1>
	<cfif AccessToPortal.Status neq '9'>
		<cfset vPortalAccess = 1>
	</cfif>
<cfelse>
	<cfif Main.EnableAnonymous eq 1>
		<cfset vPortalAccess = 1>
	</cfif>
</cfif>

<cfif getAdministrator("*") eq "1">
	<cfset vPortalAccess = 1>
</cfif>

<cfif vPortalAccess eq 0>
	<cfoutput>
		<script>
			parent.window.location = '#session.root#/Portal/SelfService/HTML5/AccessDenied.cfm?id=#url.id#&mission=#url.mission#';
		</script>
	</cfoutput>
</cfif>