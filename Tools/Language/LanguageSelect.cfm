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
<cfparam name="Attributes.mode" default="basic">
<cfparam name="Attributes.FunctionName" default="">
<cfparam name="Attributes.box" default="ajaxnavigate">

<cfquery name="Main" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemModule = 'SelfService'
	AND FunctionClass = 'SelfService'
	AND FunctionName = '#attributes.FunctionName#'
	AND (MenuClass = 'Mission' or MenuClass = 'Main')
	ORDER BY MenuOrder
</cfquery>

<cfif Main.SystemFunctionId eq "">

	<table width="100%" height="100%" border="0" cellspacing="0"
	       cellpadding="0" align="center">
		<tr>
			<td align="center" height="40" class="labelmedium">
				<font color="FF0000">
					<cf_tl id="Portal does not exist or has not been configured" class="Message">
				</font>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<cfquery name="qLanguage" datasource="AppsSystem" username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	SELECT *
	 FROM Ref_SystemLanguage
	 WHERE Operational IN ('1','2')
	 AND Code IN (SELECT LanguageCode
	 FROM Ref_ModuleControl_Language
	 WHERE Operational = 1
	 AND SystemFunctionId = '#Main.SystemFunctionId#')
	 ORDER BY SystemDefault DESC 
</cfquery>

<cfoutput>
	
	<cfswitch expression="#attributes.mode#">
		<cfcase value="Flags">
			<cfloop query="qLanguage">
				<cfif client.languageid eq qLanguage.Code>
					<img src="#CLIENT.root#\Images\Flag\#client.languageid#_large.png" border=0>
					
				<cfelse>
					<span>
					<a href="##" 
					   onclick="ColdFusion.navigate('#CLIENT.root#/Tools/Language/LanguageToggle.cfm?id=#qLanguage.Code#','#attributes.box#');">
						<img src="#CLIENT.root#\Images\Flag\#qLanguage.Code#.png" border=0>
					</a>
					</span>
				</cfif>
			</cfloop>
		</cfcase>
		<cfcase value="basic">
			<select id="LanSwitch" onchange="ColdFusion.navigate('#CLIENT.root#/Tools/Language/LanguageToggle.cfm?id='+this.value,'#attributes.box#')" 
			        style="border:1px solid white; height:18px; width:80px; font-size:11px">
			<cfloop query="qLanguage">
				<option value="#qLanguage.code#" <cfif client.languageid eq code>selected</cfif>>
							&nbsp;#LanguageName#
					</option>
			</cfloop>
		</cfcase>
	</cfswitch>
	
</cfoutput>