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
<cfquery name="FunctionTopic" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionOrganizationTopic
	 WHERE FunctionId = '#URL.ID#'
	 ORDER BY Parent, TopicOrder
	</cfquery>
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center" bordercolor="#D4D4D4" class="formpadding">
	
	<cfoutput query="FunctionTopic">
	
	<input type="hidden" name="Topic_#CurrentRow#" value="#TopicId#">
									
	<tr class="linedotted">	
		<td width="4%" align="right" class="labelmedium">#currentRow#.&nbsp;</td>
		<td width="80%" class="labelmedium">#TopicPhrase#</td>
		<td width="9%" align="center">
		<select name="TopicParameter_#CurrentRow#" class="regularx">
			<option value="1">Yes</option>
			<option value="0">No</option>
			<option value="9">N/A</option>
		</select>
		</td>
	</tr>
					
	</cfoutput>
																		
</table>
		
				