<cfif url.workActionId neq "">

	<cfif url.PublicationElementId eq "">
	
		<cfquery name="validatePubElement" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	PublicationClusterElement
				WHERE	PublicationId = '#url.PublicationId#'
				AND		Cluster       = '#url.cluster#'
				AND		OrgUnit       = '#url.orgUnit#'
		</cfquery>
		
		<cfif validatePubElement.recordCount eq 0>
		
			<!--- Create element --->
			<cf_assignId>
			
			<cfquery name="insertPubElement" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO PublicationClusterElement (
							PublicationElementId,
							PublicationId,
							Cluster,
							OrgUnit,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
					) VALUES (
							'#rowGuid#',
							'#url.publicationId#',
							'#url.cluster#',
							'#url.orgunit#',
							'#session.acc#',
							'#session.last#',
							'#session.first#' )
			</cfquery>
			
			<cfset url.PublicationElementId = rowGuid>
		
		<cfelse>
		
			<cfset url.PublicationElementId = validatePubElement.PublicationElementId>
		
		</cfif>
	</cfif>

	<cfquery name="getAction" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	WorkOrderLineAction
			WHERE	WorkActionId = '#url.workActionId#'
	</cfquery>
	
	<cfquery name="getPictures" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	Attachment
			WHERE	Reference = '#url.workActionId#'
			AND		FileStatus <> '9'
			AND		SUBSTRING(FileName,LEN(FileName)-2,LEN(FileName)) IN ('JPG', 'PNG', 'GIF')
			ORDER BY Created ASC
	</cfquery>
	
	<table width="100%" height="100%">
		<tr>
			<td valign="top" style="padding-left:5px;">
			    
				<table width="100%">
				    <cfoutput query="getAction">
					<tr>
						<td colspan="2" class="labelmedium">#getAction.ActionMemo#</td>
					</tr>
					<tr>
						<td class="labelit"><cf_tl id="Planned">:</td>
						<td class="labelmedium">#dateFormat(getAction.DateTimeRequested,"dd/mm")# #timeFormat(getAction.DateTimeRequested,'hh:mm tt')#</td>
					</tr>
					<tr>
						<td class="labelit"><cf_tl id="Completed">:</td>
						<td class="labelmedium">#dateFormat(getAction.DateTimeActual,"dd/mm")# #timeFormat(getAction.DateTimeActual,'hh:mm tt')# <cf_tl id="by"> #getAction.ActionOfficerUserId#</td>
					</tr>
					</cfoutput>
					<tr><td height="5"></td></tr>
					<tr><td colspan="2" class="line"></td></tr>
					<tr><td height="10"></td></tr>
					<cfif getPictures.recordCount eq 0>
						<tr>
							<td colspan="2" align="center" class="labelit" style="color:red;">
								[<cf_tl id="No pictures recorded for this action">]
							</td>
						</tr>
					</cfif>
					
					<cf_tl id="Click to enlarge" var="vView">
					<cf_tl id="Rotate Picture" var="vRotate">
					
					<cfoutput query="getPictures">
					
						<cfif FileExists("#session.rootdocument#/#serverPath#/#filename#")>
											
						<tr>
							<td colspan="2" width="100%" align="center">
								<table style="border:1px solid ##C0C0C0;" class="navigation_table">
									<tr class="navigation_row">
										<td style="padding:15px;">
											
											<cfquery name="get" 
												datasource="AppsWorkOrder" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT 	*
													FROM	PublicationWorkOrderAction
													WHERE	PublicationElementId = '#url.PublicationElementId#'
													AND     WorkActionId = '#url.workActionId#'			
											</cfquery>
											
											<cfquery name="select" 
												datasource="AppsSystem" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT 	TOP 1 *
													FROM	Attachment
													WHERE	Reference = '#get.PublicationActionId#'
													AND     FileName  = '#filename#'
													AND		FileStatus <> '9'		
											</cfquery>		
											
											<cfif get.recordCount gt 0>
											
												<cfquery name="getPub" 
													datasource="AppsWorkOrder" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT 	*
														FROM	Publication
														WHERE	PublicationId = '#url.PublicationId#'
												</cfquery>
											
												<cfif getPub.actionStatus neq "3">															
													
													<cfif select.recordcount gt 0>
													
														<input type="Checkbox" 
															style="width:35px; height:35px;" 
															id="picture_#AttachmentId#" 
															checked
															onclick="selectPicture(this,'#url.PublicationElementId#','#url.workActionId#','#attachmentId#','process_#AttachmentId#','#currentrow#');">
												
													<cfelse>
													
														<input type="Checkbox" 
															style="width:35px; height:35px;" 
															id="picture_#AttachmentId#" 
															onclick="selectPicture(this,'#url.PublicationElementId#','#url.workActionId#','#attachmentId#','process_#AttachmentId#','#currentrow#');">
														
													</cfif>
												
												</cfif>
											
											</cfif>
												
										</td>
										<td align="center" style="background-color:##FFFFFF;">
											<input type="Hidden" name="PublicationActionId_#attachmentId#_#currentrow#" id="PublicationActionId_#attachmentId#_#currentrow#" value="#select.attachmentid#">
											<table>
												<tr>
													<td class="labelit" align="center" style="padding:5px;">
														<button 
															type="button" 
															title="#vRotate#"
															style="background-color:transparent; border-style:none; cursor:pointer;" 
															onclick="rotatePicture('#attachmentId#',$('##PublicationActionId_#attachmentId#_#currentrow#').val());">
																<img src="#session.root#/Images/rotate.png" style="height:20px;">
														</button>														
													</td>
												</tr>
												<tr>
													<td id="pictureContainer_#attachmentId#">
														<img src="#session.rootdocument#/#serverPath#/#filename#" 
															style="max-width:300px; height:auto; cursor:pointer;" 
															title="#vView#" 
															onclick="viewPicture('#attachmentId#')">
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						<tr>
							<td colspan="2" width="100%" align="center" class="labelit" style="font-size:11px;">
								<table class="formpadding">
									<tr><td align="center" class="labelit">
										#OfficerFirstName# #OfficerLastName# @ #timeFormat(getAction.DateTimeActual,"hh:mm tt")#
										</td>
									</tr>									
									<tr><td align="center" class="labelit" id="box_#AttachmentId#">
									       <cfif select.recordcount gte "1">
											<input type="Text" 
												id="pictureAttachmentMemo_#AttachmentId#" 
												value="#select.AttachmentMemo#" 
												class="regularxl clsPictureAttachmentMemo" 
												style="width:375px;" 
												onchange="ColdFusion.navigate('#session.root#/WorkOrder/Application/Activity/Publication/Picture/setMemo.cfm?attachmentId=#select.attachmentId#&memo='+encodeURIComponent(this.value),'process_#AttachmentId#');">																							
											</cfif>	
										</td>
									</tr>									
									<tr><td align="center" class="labelit" id="process_#AttachmentId#"></td></tr>
								</table>
							</td>
						</tr>
						<tr><td height="8"></td></tr>
						<tr><td colspan="2" class="line"></td></tr>
						<tr><td height="8"></td></tr>
						
						<cfelse>
						
							<cf_fileDelete attachmentid="#attachmentid#" mode="hide">			
						
						</cfif>
						
					</cfoutput>
				</table>
			</td>
		</tr>
	</table>

</cfif>

<!--- removes the 'X' from the inputs in IE10+ --->
<style>
	.clsPictureAttachmentMemo::-ms-clear
	{
		width:0;
		height:0;
	}
</style>

<cfset AjaxOnLoad("doHighlight")>