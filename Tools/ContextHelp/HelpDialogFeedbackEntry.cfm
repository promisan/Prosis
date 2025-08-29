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
<cfoutput>

<cfform action="HelpDialogFeedbackSubmit.cfm?topicid=#url.topicid#&rating=#url.rating#">
	
	<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
	    <tr><td width="30">
		<cfswitch expression="#url.rating#">
		<cfcase value="1"><cfset i = "Positive"></cfcase>
		<cfcase value="2"><cfset i = "Normal"></cfcase>
		<cfcase value="3"><cfset i = "Negative"></cfcase>
		</cfswitch>
		<img alt="useful" src="<cfoutput>#SESSION.root#</cfoutput>/Images/rate#i#.gif" 
			border="0">
		</td>
		<td width="95%" class="labelit">Tell us what you think.</td>
		</tr>
		<tr><td colspan="2">
			<textarea style="border-radius:5px;padding:3px;font-size:12px;height:50;width:98%" class="regular" name="Remarks"></textarea>
		</td></tr>
		<tr><td align="center" colspan="2">
			<input type="submit" value="Submit" name="Submit" id="Submit" class="button10g">
			<input type="button" value="Cancel" name="Cancel" id="Cancel" class="button10g" onclick="feedbackreturn('#url.topicid#')">
		</td></tr>   
	</table>

</cfform>

</cfoutput>