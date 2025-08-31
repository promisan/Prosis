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
	<cfquery name="HelpId" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  HelpProjectTopic
			WHERE TopicId   = '#URL.TopicId#' 
	</cfquery>
	  
	<cfoutput query="helpid">
		
	<table width="98%" border="0" align="center">	  	
		<tr><td colspan="2">	
			<input type="hidden" name="topicid" id="topicid" value="#url.topicid#">		
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">		
				<tr><td colspan="2" align="center">
					<cfdiv bind="url:HelpDialogFeedback.cfm?topicid=#url.topicid#" id="feedback"/>		
				</td></tr>			
				<tr><td class="linedotted"></td></tr>						
				<tr><td>#HelpId.UITextQuestion#</td></tr>		
				<cfif HelpId.UITextAnswer neq "">
					<tr><td>#HelpId.UITextAnswer#</td></tr>
				</cfif>		
			</table>		
		</td></tr>	
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>				
	</table>
	
	</cfoutput>