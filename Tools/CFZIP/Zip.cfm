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
<cfparam name="attributes.output">
<cfparam name="attributes.filelist"            default = "">
<cfparam name="attributes.savepath"            default = "No">
<cfparam name="attributes.recursedirectory"    default = "Yes">


<cfsetting enablecfoutputonly="yes">

<cfzip file         = "#attributes.output#"
		overwrite   = "yes">
	<cfloop list="#attributes.filelist#" index="vFile">			
		<cfif fileexists(vFile)>
			<cfset vFile = replace(vFile,"//","/","all")>
			<cfset vFile = replace(vFile,"\\","\","all")>			
			
			<cfset vFileDestination = replace(vFile,SESSION.rootpath,"./")>
			
			<cfif attributes.savepath eq "Yes">				
				<cfzipparam
					entrypath  = "#vFile#" 
					source     = "#vFile#"/>
			<cfelse>
				<cfzipparam
					source     = "#vFile#"/>
			</cfif>
		</cfif>			
	</cfloop>			
</cfzip>


<cfsetting enablecfoutputonly="no">
