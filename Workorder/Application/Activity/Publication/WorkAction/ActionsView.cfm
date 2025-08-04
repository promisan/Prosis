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
<cfquery name="getOrgunit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Organization
		WHERE	OrgUnit = '#url.OrgUnit#'
</cfquery>

<cfquery name="getPub" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		WHERE	PublicationId = '#url.PublicationId#'
</cfquery>

<cfquery name="getPubElement" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	PublicationClusterElement
		WHERE	PublicationId = '#url.PublicationId#'
		AND		Cluster = '#url.code#'
		AND		OrgUnit = '#url.orgUnit#'
</cfquery>

<cfquery name="getActions" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 A.*,
				 RA.Description AS ActionClassDescription,
				 (
					SELECT	WorkActionId 
					FROM 	PublicationWorkOrderAction 
					WHERE 	1=1
					<cfif getPubElement.recordCount gt 0>
					AND		PublicationElementId = '#getPubElement.PublicationElementId#'
					AND		WorkActionId = A.WorkActionId
					<cfelse>
					AND		1=0
					</cfif>
				 ) as Selected,
				 CONVERT(VARCHAR(10),DateTimeRequested,112) AS DateTimeRequested_Date,
				 L.ServiceDomainClass,
				 DC.Description as ServiceDomainClassDescription,
				 L.Reference as LineReference,
				 ISNULL((
				 	SELECT 	ISNULL(COUNT(*),0)
					FROM	System.dbo.Attachment
					WHERE	Reference = CONVERT(VARCHAR(50), A.WorkActionId)
					AND		FileStatus <> '9'
					AND		(FileName like '%.gif' OR FileName like '%.png' OR FileName like '%.jpg')
				 ),0) as PictureCount
		FROM	 WorkOrderLineAction A
				 INNER JOIN Workorder W     ON A.WorkOrderId = W.WorkOrderId
				 INNER JOIN WorkOrderLine L ON A.WorkOrderId = L.WorkOrderId	AND A.WorkOrderLine = L.WorkOrderLine
				 INNER JOIN Ref_ServiceItemDomainClass DC ON L.ServiceDomain = DC.ServiceDomain AND L.ServiceDomainClass = DC.Code
				 INNER JOIN Ref_Action RA 	ON A.ActionClass = RA.Code
		WHERE	 A.DateTimeActual IS NOT NULL
		and		 A.ActionStatus = '3'
		AND		 A.WorkOrderId = '#getPub.workOrderId#'
		AND		 L.OrgUnit = '#url.orgUnit#'
		AND		 A.DateTimeRequested BETWEEN '#getPub.PeriodEffective#' and '#getPub.PeriodExpiration#'
		ORDER BY RA.ListingOrder DESC, RA.Code, A.DateTimeRequested ASC, L.ServiceDomainClass ASC, L.Reference ASC
</cfquery>

<cf_tl id="Pictures recorded" var="vPictureLabel">

<table width="99%" height="100%" align="center">
	<tr>
		<td valign="top" style="padding-left:3px;">
			<table width="100%" class="navigation_table">
				<tr>
					<td colspan="9" class="labelmedium">
						<cfoutput>#getOrgunit.orgUnitName#</cfoutput>
					</td>
				</tr>
				<tr><td height="3"></td></tr>
				<tr><td colspan="9" class="line"></td></tr>
				<tr><td height="3"></td></tr>
				<tr>
					<td colspan="9">
						<table width="100%">
							<tr>
								<td class="labelmedium" width="5%"><cf_tl id="Memo">:</td>
								<td style="padding-left:5px;" width="90%">
									<cfoutput>
										<input type="Text" 
										        id="elementMemo" 
												name="elementMemo" 
												style="width:100%" 
												class="regularxl" 
												value="#getPubElement.Memo#" 
												<cfif getPub.actionStatus neq "3">
												onchange="ColdFusion.navigate('../WorkAction/setMemo.cfm?publicationElementId=#getPubElement.publicationElementId#&val='+this.value+'&publicationId=#url.publicationId#&cluster=#url.code#&orgunit=#url.orgunit#','processmemo');"
												</cfif>>
									</cfoutput>
								</td>
								<td id="processmemo" style="padding-left:5px;" width="5%"></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td height="3"></td></tr>
				<tr><td colspan="9" class="line"></td></tr>
				<tr><td height="3"></td></tr>
				<tr class="labelmedium line">
					<td width="20px"></td>
					<td width="20px"></td>
					<td width="20px"></td>
					<td style="max-width:1%;" valign="middle" align="center">
						<cfif getPub.actionStatus neq "3">
							<cfquery name="qGetActions" dbtype="query">
								SELECT 	*
								FROM	getActions
								WHERE	Selected = WorkActionId
							</cfquery>
							
							<cfoutput>
								<cf_tl id="Select all" var="1">
								<input 
									type	= "Checkbox" 
									id		= "selectAll" 
									style   = "height:20px; width:20px; cursor:pointer;" 
									onclick	= "selectAllActions(this,'highlight1','#url.PublicationId#','#getPubElement.publicationElementid#','#url.code#','#url.orgunit#');" 
									title	= "#lt_text#" 
									class	= "radiol" 
									<cfif qGetActions.recordCount eq getActions.recordCount>checked</cfif>>
							</cfoutput>
						</cfif>
					</td>					
					<td style="width:5%; max-width:5%; padding-left:5px;"><cf_tl id="Area"></td>
					<td style="width:10%; max-width:10%; padding-left:10px;"><cf_tl id="Planned"></td>
					<td style="width:65%; max-width:65%; padding-left:8px;"><cf_tl id="Description"></td>
					<td style="width:20%; max-width:20%; padding-left:5px;"><cf_tl id="Completed"></td>
					<td style="width:1%;"></td>
				</tr>
				
				<tr><td height="3"></td></tr>
				<cfif getActions.recordCount eq 0>
					<tr>
						<td colspan="9" align="center" class="labelmedium" style="color:gray;">
							<cf_tl id="No actions completed">
						</td>
					</tr>
				</cfif>
				
				<cfset row = 0>
				
				<cfoutput query="getActions" group="ActionClass">
				
					<tr><td class="labellarge" colspan="9" style="background-color:##E8E8E8;">#UCASE(ActionClassDescription)#</td></tr>
					<tr><td height="5"></td></tr>
				
					<cfoutput group="DateTimeRequested_Date">
					
						<cfset row = row+1>
					
						<cfquery name="qActionsDate" dbtype="query">
							SELECT 	COUNT(*) as Total
							FROM	getActions
							WHERE	DateTimeRequested_Date = '#DateTimeRequested_Date#'
							AND		ActionClass = '#ActionClass#'
							AND		Selected = WorkActionId
						</cfquery>
						
						<cfset vGroupId = dateFormat(DateTimeRequested,"yyyymmdd")>
						<cfset vDayName = dateFormat(DateTimeRequested,"dddd")>
						
						<tr class="line navigation_row" onclick="toggleActionGroup('#vGroupId#');">
							<td width="20px"></td>
							<td width="20px"></td>
							<td colspan="6">		
								<table width="100%">
									<tr>
										<td width="1%" style="padding-left:3px">
											<cfif qActionsDate.Total neq "" and qActionsDate.Total gt 0>
												<img src="#session.root#/images/arrowdown3.gif" id="twistie_#vGroupId#">
											<cfelse>
												<img src="#session.root#/images/arrowright.gif" id="twistie_#vGroupId#">
											</cfif>
										</td>
										<td style="padding-left:5px;" class="labelmedium">
											#dateFormat(DateTimeRequested,client.dateFormatShow)# <cf_tl id="#vDayName#">  
										</td>
									</tr>
								</table>		
							</td>
							<td class="labelmedium" align="right" style="padding:4px;" id="action_#vGroupId#">	
								<cfset vShowDetailRows = "display:none;">
								<cfif qActionsDate.Total neq "" and qActionsDate.Total gt 0>
									<cfset vShowDetailRows = "">
									<div style="color:##5C5C5C; border:1px solid ##5C5C5C; background-color:##FFFFBD; text-align:center; padding-top:3px; padding-left:1px; border-radius:20px; height:20px; width:20px; font-size:13px;">
										#qActionsDate.Total#
									</div>
								</cfif>
							</td>						
						</tr>
											
						<cfoutput group="ServiceDomainClass">
						
							<tr>
								<td width="20px"></td>
								<td width="20px"></td>
								<td width="20px"></td>
							    <td colspan="6" class="labelmedium clsActionGroup_#vGroupId#" style="#vShowDetailRows# font-style:italic;">#ServiceDomainClassDescription#</td>
							</tr>
						
							<cfoutput>
							
								<cfif Selected eq workActionId>
									<cfset cl = "highlight1">
								<cfelse>
									<cfset cl = "">	
								</cfif>
								
								<cfset vId = replace(workActionId,"-","","ALL")>
							
								<tr 
									class="line labelit clsActionDetail clsActionGroup_#vGroupId# clsActionbox_#vId# #cl#" 
									style="#vShowDetailRows# cursor:pointer;">
									
									<td width="20px"></td>
									<td width="20px"></td>					
									<td style="padding-left:15px; height:25px;"></td>
									<td style="padding-left:1px; padding-right:1px0;" valign="middle" align="center">
										<input type="Hidden" id="groupAction_#vId#" value="#vGroupId#">
										<cfif getPub.actionStatus neq "3">
											<input type = "Checkbox" 
												id      = "action_#vId#" 									
												class   = "radiol clsActionCB navigation_action"
												style   = "height:20px; width:20px; cursor:pointer;" 
												value   = "#workActionId#"									
												onclick = "selectAction(this,'highlight1','#url.PublicationId#','#getPubElement.publicationElementid#','#url.code#','#url.orgunit#','#vGroupId#'); viewPictures('#getPubElement.publicationElementid#','#workActionId#','#url.publicationId#','#url.code#','#url.orgUnit#');" 
												<cfif Selected eq workActionId>checked</cfif>>
										</cfif>
									</td>
									<td style="padding-left:5px;">#LineReference#</td> 
									<td style="padding-left:10px;">#timeFormat(DateTimeRequested,'hh:mm tt')#</td> 
									<td style="padding-left:8px;">#ActionMemo#</td>
									<td style="padding-left:5px;">#timeFormat(DateTimeActual,'hh:mm tt')# #ActionOfficerUserId#</td>
									<td style="padding-left:5px;" onclick="viewPictures('#getPubElement.publicationElementid#','#workActionId#','#url.publicationId#','#url.code#','#url.orgUnit#');">
										<cfif PictureCount gt 0>
											<img src="#session.root#/images/picture_blueSquare.png" title="#vPictureLabel#: #pictureCount#">
										</cfif>
									</td>
									
								</tr>
							
							</cfoutput>
						
						</cfoutput>
						
					</cfoutput>
					
					<tr><td class="labellarge" colspan="9" height="10"></td></tr>
				
				</cfoutput>
			</table>
		</td>
	</tr>
</table>

<cfset AjaxOnLoad("doHighlight")>