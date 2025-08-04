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

<!--- help content --->

<cfquery name="HelpId" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  HelpProjectTopic
	WHERE TopicId       = '#url.topicid#'  	
</cfquery>

<cfoutput>
<table width="100%" height="100%" bgcolor="E6E6E6">
<cfif len(HelpId.UITextHeader) gte "10">
	<tr><td class="labelmedium" style="padding:10px">#HelpId.UITextHeader#</td></tr>
</cfif>
	<tr><td class="labelmedium" style="padding:10px">#HelpId.UITextAnswer#</td></tr>
</table>
</cfoutput>