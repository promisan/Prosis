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
<cfparam name="Object.ObjectKeyValue1" default="">
<cfparam name="url.submissionedition" default="#Object.ObjectKeyValue1#">

<cfquery name="defaultLanguage"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   TOP 1 * 
	FROM     Ref_SystemLanguage
	WHERE    LanguageCode != ''
	AND      SystemDefault = 1
</cfquery>

<cfparam name="URL.languagecode" default="#defaultLanguage.LanguageCode#">

<cfparam name="Action.ActionId" default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.ActionId" default="#Action.ActionId#">

<cfoutput>
	
	<cf_divscroll>
	
		<cfform action="#session.root#/Roster/Maintenance/RosterEdition/Materials/PublishTextSubmit.cfm?submissionedition=#url.submissionedition#&languagecode=#url.languagecode#&actionid=#url.actionid#&nocache=yes" name="profile#url.languagecode#">
	
			<cfinclude template="PublishTextContent.cfm">
	
		</cfform>	
	
	</cf_divscroll>

</cfoutput>
