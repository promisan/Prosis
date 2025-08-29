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
<cfparam name="attributes.id" 	default = "">
<cfparam name="attributes.src" 	default = "">

<cfoutput>
<cfif thisTag.executionmode is 'start'>


     <cfset tagdata = getbasetagdata("CF_PRESENTER")>
     
     <cfif tagdata.thisTag.executionmode neq 'inactive'>
		<!--- nada --->
     <cfelse>

       	<cfif tagdata.attributes.details eq "">
			<cfif attributes.src eq "">
				<cfset tagdata.attributes.details = "'#attributes.id#'">
			<cfelse>
				<cfset tagdata.attributes.details = "#attributes.src#">	
			</cfif>	
		<cfelse>
			<cfif attributes.src eq "">
				<cfset tagdata.attributes.details = "#tagdata.attributes.details#,'#attributes.id#'">
			<cfelse>
				<cfset tagdata.attributes.details = "#tagdata.attributes.details#,#attributes.src#">	
			</cfif>	
		</cfif>
		
		
     </cfif>

	
	<cfif attributes.src eq "" and attributes.id neq "">	
		<div id="#attributes.id#">
	</cfif>
	
<cfelse>

	<cfif attributes.src eq "" and attributes.id neq "">	
		<cfsavecontent variable="vreturn">
				#thisTag.GeneratedContent#
				</div>
		</cfsavecontent>

		<cfset thisTag.GeneratedContent = vreturn>
	</cfif>
	
</cfif>
</cfoutput>
