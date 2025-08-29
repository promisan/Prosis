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
<cfparam name="URL.debug" default="0">

<cfif url.debug eq 0>

	<cf_screentop height="100%" scroll="No" jquery="yes" html="No" blockevent="rightclick">
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
	<cfajaximport tags="cfchart">
	
	<!---	
	<cf_divscroll overflowx="scroll" id="_divPivotContainer">
	--->
		
		<cfdiv bind="url:#SESSION.root#/Tools/CFReport/Analysis/OutputPrepareContent.cfm?#cgi.query_string#">
	
	<!---	
	</cf_divscroll>
	--->
	
	
	<!--- load the script --->
	<cfinclude template="../../../Component/Analysis/CrossTabHolder.cfm">
	
	<!---  <cfinclude template="OutputPrepareContent.cfm"> --->
	
<cfelse>
	
	<cfinclude template="../../../Tools/CFReport/Analysis/OutputPrepareContent.cfm">

</cfif>