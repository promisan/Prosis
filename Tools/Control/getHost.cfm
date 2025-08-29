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
<cfparam name="Attributes.Host"  default="#cgi.http_host#">

<cfset cnt = 1>
<cfloop index="itm" list="#Attributes.Host#" delimiters=".">
	<cfif cnt eq "1">
		<cfset caller.host = itm>
		<cfif itm neq "www" and itm neq "admin" and not isNumeric(itm)>
			<cfset cnt = 2>
			<!--- this will stop the loop --->
		</cfif>		
	</cfif>
</cfloop>