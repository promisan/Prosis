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
	<cf_divscroll id="printingprogress" float="yes" width="400" height="100" overflowy="hidden" zindex="11" padding="3px" close="no">
		<cf_tableround mode="modal" totalheight="100%">
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" bgcolor="e9f5ff" align="center">
				<tr>
					<td valign="middle" align="center">

						<font face="calibri" size="3">Preparing Print</font><br>

						<img src="#SESSION.root#/Images/busy3.gif">
						<span id="printclosedialog" style="display:none; cursor:pointer; color:blue" onclick="document.getElementById('printingprogress').style.display = 'none'">Close</span>
						<script>
							setTimeout("document.getElementById('printclosedialog').style.display = 'block'", 5000);
						</script>
					</td>
				</tr>
			</table>
        </cf_tableround>
    </cf_divscroll>
    </cfoutput>
