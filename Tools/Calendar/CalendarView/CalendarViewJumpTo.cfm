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
<cf_tl id="Jump To Date" var="vTitle">

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td bgcolor="white">

	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<!--- <tr><td height="20" colspan="2" class="labellarge">#vTitle#</td></tr> --->
	  
		<tr>
			
			<td colspan="2" align="center" style="padding-top:8px;height:165;width:200;border:0px solid silver">
			    				
				<cfform name="calendarJump">				
				
					<cf_intelliCalendarDate9
					    class="regularxl"
						FieldName="calendarJumpToDate"
						Inline="true"
						Default="#dateformat(now(), '#CLIENT.DateFormatShow#')#"
						AllowBlank="False">
												
				</cfform>				
				
			</td>
		</tr>
				
		<tr>
			<td colspan="2" align="center" style="height:50">
				
					<input type="button" style="width:150px;height:24" name="btnCalendarJumpTo" id="btnCalendarJumpTo" value="Go to date" class="button10g" onclick="calendarDoJumpTo(document.getElementById('calendarJumpToDate').value);">
				
			</td>
		</tr>
	</table>

</td></tr>

</table>

<cfset AjaxOnLoad("doCalendar")>

</cfoutput>