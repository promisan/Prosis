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

<!--- facility to verify if template exists --->
<cfparam name="url.root" default="">
<cfparam name="url.template" default="">
<cfparam name="url.container" default="">
<cfparam name="url.resultField" default="directoryVal">

<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>

<cfif url.template neq "">
	
	<cftry>
	
		<cfif trim(url.root) neq "">
			<cfset vRoot = url.root>
			<cfset vRoot = replace(vRoot,"..","","ALL")>
			<cfset vRoot = replace(vRoot,"\","/","ALL")>
		<cfelse>
			<cfset vRoot = session.root>
		</cfif>
	
		<cfset vTemplate = url.template>
		<cfset vTemplate = replace(vTemplate,"..","","ALL")>
		<cfset vTemplate = replace(vTemplate,"\","/","ALL")>
		
		<cfset vList = ListToArray(vTemplate,"/")>
		<cfset vFileName = vList[ArrayLen(vList)]>
		<cfset vFileNameP = ListToArray(vFileName,".")>
		
		<cfif FileExists("#vRoot##vTemplate#") and ArrayLen(vFileNameP) gte 2>							
			
			<tr>
			<td align="left" width="5px">
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle" title="Path validated">
		    <input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
			
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0" align="absmiddle" title="Path not validated!">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" align="absmiddle" title="Error trying to validate path">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>

</cfif>

</cfoutput>

</td></tr>
</table>

