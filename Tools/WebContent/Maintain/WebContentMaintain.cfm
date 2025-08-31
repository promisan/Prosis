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
<cfparam name="Attributes.SystemFunctionId"  default="">
<cfparam name="Attributes.ContentId"         default="">

<cfif attributes.systemfunctionid neq "">
	
		<cfquery name="content" datasource="AppsSystem">

			SELECT *
			FROM   Ref_ModuleControlContent
			WHERE  ContentId        = '#Attributes.ContentId#'
			AND    SystemFunctionId = '#Attributes.SystemFunctionId#'

		</cfquery>

		<cfquery name="language" datasource="AppsSystem">

			SELECT *
			FROM   Ref_SystemLanguage
			WHERE  Operational = '2'
			
		</cfquery>
		
		<cfoutput>
		
			<form name="languageform" id="languageform" action="#SESSION.root#/Tools/Webcontent/Maintain/WebcontentSubmit.cfm" method="post"> 
			
				<cfloop query="language">
					<b>#Language.LanguageName#</b> </br>
					<textarea name="Text#Language.Code#" id="Text#Language.Code#" style="width:100%; height:150px">#Evaluate("content.Text#Language.Code#")#</textarea></br></br>
				</cfloop>

				<input type="hidden" id="ContentId" name="ContentId" value="#Attributes.ContentId#">
				<input type="hidden" id="SystemFunctionId" name="SystemFunctionId" value="#Attributes.SystemFunctionId#">
				
				<input type="submit" id="submit" name="submit" value="save">
			</form>
			
		</cfoutput>
		
</cfif>