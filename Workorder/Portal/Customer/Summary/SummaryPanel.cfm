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
<cf_divScroll width="100%">
	<table style="width:98%; height:100%;" align="center">
		<tr><td height="15"></td></tr>
		<tr>
			<td>
				<table width="100%" align="center">
					<tr>
						<td class="labellarge" style="padding-left:15px; height:25px; width:7%;"><cf_tl id="Date">:</td>
						<td class="labellarge" style="padding-left:5px; width:93%;">
							<cfform name="dateFrm">
								<cf_intelliCalendarDate8
									FieldName="fReferenceDate"
									class="regularxl"
									Default="#dateformat(now(), CLIENT.DateFormatShow)#"
									AllowBlank="False">
							</cfform>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td style="width:100%; height:100%;">
				<cfdiv id="divSummaryPanel" 
					style="width:100%; height:100%; min-width:100%;"
					bind="url:Summary/SummaryPanelDetail.cfm?referenceDate={fReferenceDate}&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#">
			</td>
		</tr>
	</table>
</cf_divScroll>

 