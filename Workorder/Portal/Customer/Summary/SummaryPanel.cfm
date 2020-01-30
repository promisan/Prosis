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

 