<cfquery name="ActionPictures" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	
		SELECT	A.*,
				(CONVERT(VARCHAR(8), A.DateTimePlanning, 112)) as DateTimePlanningDate,
				P.ServerPath,
				P.FileName,
				P.AttachmentMemo,
				(P.OfficerFirstName + ' ' + P.OfficerLastName) as AttachmentOfficer,
				P.Created as AttachmentCreated
		FROM	WorkOrderLineAction A
				INNER JOIN System.dbo.Attachment P
					ON CONVERT(VARCHAR(36), A.WorkActionId) = CONVERT(VARCHAR(36), P.Reference)
		WHERE	P.FileStatus <> '9'
		AND		(P.FileName like '%.jpg' OR P.FileName like '%.gif' OR P.FileName like '%.png')
		ORDER BY CONVERT(VARCHAR(10), A.DateTimePlanning, 112) ASC
	
</cfquery>

<cf_divScroll overflowx="auto">
	
	<table width="95%" cellpadding="0" cellspacing="0">
		
		<cfoutput query="ActionPictures" group="DateTimePlanningDate">
			<tr>
				<td colspan="2" class="labelmedium">#dateFormat(DateTimePlanning, client.dateFormatShow)#</td>
			</tr>
			<cfoutput>
				<tr>
					<td width="5%"></td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid ##C0C0C0; padding:10px;">
							<tr>
								<td valign="top">
									<table width="50%" cellpadding="0" cellspacing="0">
										<tr>
											<td><cf_tl id="Officer">:</td>
											<td>#AttachmentOfficer#</td>
										</tr>
										<tr>
											<td><cf_tl id="Created">:</td>
											<td>#dateFormat(AttachmentCreated, client.dateFormatShow)#</td>
										</tr>
										<tr>
											<td><cf_tl id="Memo">:</td>
											<td>#AttachmentMemo#</td>
										</tr>
									</table>
								</td>
								
								<td>
									<cfset vImagePath = urlEncodedFormat('#session.rootdocument#/#ServerPath#/#FileName#')>
									<img align="absmiddle"" style="max-height:250px; cursor:pointer;" src="#urlDecode(vImagePath,'utf-8')#">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td height="10"></td></tr>
			</cfoutput>
		</cfoutput>
			
	</table>
	
</cf_divScroll>
