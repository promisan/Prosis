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
<cfparam name="attributes.template"				default="">
<cfparam name="attributes.removeHTMLSpaces"		default="0">
<cfparam name="attributes.sendToFile"			default="0">

<cfif trim(attributes.template) neq "">
	<cfsavecontent variable="vTheMainContent">
		<cfinclude template="#attributes.template#">
	</cfsavecontent>

	<!--- reducing output --->
	<cfset vTheMainContent = replace(vTheMainContent,"	","","ALL")>
	<cfset vTheMainContent = replace(vTheMainContent,"#chr(13)#","","ALL")>
	<cfif trim(lcase(attributes.removeHTMLSpaces)) eq "yes" OR trim(lcase(attributes.removeHTMLSpaces)) eq "1">
		<cfset vTheMainContent = replace(vTheMainContent,"&nbsp;","","ALL")>
	</cfif>

	<!--- outputting --->
	<cfoutput>#preserveSingleQuotes(vTheMainContent)#</cfoutput>

	<!---send to file--->
	<cfif trim(lcase(attributes.sendToFile)) eq "yes" OR trim(lcase(attributes.sendToFile)) eq "1">
		<cfsilent>
			<cfoutput>
				<cf_logpoint filename="__logMinimized.txt">
					#vTheMainContent#
				</cf_logpoint>
			</cfoutput>
		</cfsilent>
	</cfif>
</cfif>