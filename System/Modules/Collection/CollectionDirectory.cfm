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

<!--- facility to verify if directory exists and allows for creation --->

<cfparam name="url.mode" default="">
<cfparam name="url.path" default="">
<cfparam name="url.container" default="">
<cfparam name="url.resultField" default="directoryVal">

<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>

<cfif path neq "">
	
	<cftry>

		<cfif DirectoryExists("#path#")>					
			
			<tr>
			<td align="left" width="5px">
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
			<input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>
	
<cfelse>

		<!---
		<tr>
		<td>&nbsp;</td>
		<td><img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0"></td>
		<td>Please define directory</td>
		</tr>		
	 	--->
</cfif>

</cfoutput>

</td></tr>
</table>

