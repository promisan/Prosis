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
<cfquery name="pubs" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  P.PublicationId,
				P.PeriodEffective,
				P.PeriodExpiration,
				P.Description,
				PC.Code as Cluster,
				PC.Description as ClusterDescription,
				PC.ListingOrder as ClusterListingOrder,
				PCE.OrgUnit as ElementOrgUnit,
				O.OrgUnitName as ElementOrgUnitName,
				PCE.Memo as ElementMemo,
				PWA.WorkActionId,
				PWA.PublicationActionId,
				WOLA.ActionMemo,
				WOLA.ActionClass,
				WOLA.DateTimeActual,
				WOLA.ActionOfficerLastName,
				WOLA.ActionOfficerFirstName,
				AC.Description ActionClassDescription,
				A.AttachmentId,
				A.ServerPath,
				A.FileName,
				A.AttachmentMemo,
				A.Created,
				A.OfficerLastName,
				A.OfficerFirstName
		FROM	Publication P
				INNER JOIN PublicationCluster PC
					ON P.PublicationId = PC.PublicationId
				INNER JOIN PublicationClusterElement PCE
					ON PC.PublicationId = PCE.PublicationId
					AND PC.Code = PCE.Cluster
				INNER JOIN PublicationWorkOrderAction PWA
					ON PCE.PublicationElementId = PWA.PublicationElementId
				INNER JOIN WorkOrderLineAction WOLA
					ON PWA.WorkActionId = WOLA.WorkActionId
				INNER JOIN Ref_Action AC
					ON WOLA.ActionClass = AC.Code
				INNER JOIN Organization.dbo.Organization O
					ON PCE.OrgUnit = O.OrgUnit
				LEFT OUTER JOIN System.dbo.Attachment A
					ON CONVERT(VARCHAR(36),PWA.PublicationActionId) = A.Reference
		WHERE 	1=1
		<cfif url.publicationId neq "">
		AND		P.PublicationId = '#url.PublicationId#'
		<cfelse>
		AND		1=0
		</cfif>
		<cfif url.cluster neq "">
		AND		PC.Code = '#url.cluster#'
		<cfelse>
		AND		1=0
		</cfif>
		<cfif url.orgunit neq "">
			<cfif url.orgunit neq "VIEWALLORGUNITS">
				AND		PCE.OrgUnit = '#url.orgUnit#'
			</cfif>
		<cfelse>
		AND		1=0
		</cfif>
		AND		A.FileStatus <> '9'
		AND		SUBSTRING(A.FileName,LEN(A.FileName)-2,LEN(A.FileName)) IN ('JPG', 'PNG', 'GIF')
		ORDER BY 
				A.Created ASC
</cfquery>

<cfset headerLabelColor = "##EBEBEB">
<cfset labelColor = "##D6D6D6">
<cfset dataColor = "##FFFFFF">

<table width="100%" align="center">
	<cfif pubs.recordCount eq 0>
		<tr>
			<td align="center" class="labellarge" style="padding-top:50px; color:red;">
				<cfif url.orgunit eq "VIEWALLORGUNITS">
					[<cf_tl id="No elements publicated">]
				<cfelse>
					[<cf_tl id="No elements publicated in this location">]
				</cfif>
			</td>
		</tr>
	</cfif>
	<cfif url.orgunit neq "VIEWALLORGUNITS">
		<tr>
			<td class="labellarge" style="padding-left:3px; font-style:italic;"><cfoutput>#pubs.ElementMemo#</cfoutput></td>
		</tr>
	</cfif>
	<tr>
		<td>
			<div id="carousel" class="flexslider" style="border-style:none; box-shadow:none;">
			  <ul class="slides">
			  	<cfoutput query="pubs">
				    <li style="cursor:pointer;">
						<cfdiv style="height:125px; max-height:125px; width:auto;" bind="url:getPicture.cfm?url=#URLEncodedFormat('#session.rootdocument#/#ServerPath#/#filename#')#&style=#URLEncodedFormat('height:100%; width:100%; margin:0 auto; border:5px solid ##FFFFFF;')#&id=#currentrow#">
					  	<div style="margin-top:-50px; height:35px; margin-left:25%; margin-right:25%; border-radius:2px; -moz-border-radius:2px; -webkit-border-radius:2px; padding-top:5px; position:relative; z-index:2; background-color:rgba(0,0,0,0.5); color:#headerLabelColor#; text-align:center;">
							<span style="font-size:13px;">#currentrow#</span>
							<br>
							<span style="padding-top:3px; font-size:10px;">#lsDateFormat(Created,client.dateFormatShow)#</span>
						</div>
				    </li>
				</cfoutput>
			  </ul>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div id="slider" class="flexslider" style="border-style:none; box-shadow:none;">
			  <ul class="slides">
			  	<cfoutput query="pubs">
				    <li>
						<div style="max-height:485px; width:auto; margin:0 auto;">
							<cfdiv bind="url:getPicture.cfm?url=#URLEncodedFormat('#session.rootdocument#/#ServerPath#/#filename#')#&style=#URLEncodedFormat('height:550px; width:auto; margin:0 auto;')#&roundborder=1&id=#currentrow#&rotateEvent=1">
							<div style="margin-top:-150px; height:130px; margin-left:20%; margin-right:20%; border-radius:10px 10px 0 0; -moz-border-radius:10px 10px 0 0; -webkit-border-radius:10px 10px 0 0; position:relative; z-index:2; background-color:rgba(0,0,0,0.4); color:##FFFFFF; padding:10px;">
								<table width="100%">
									<tr>
										<td width="50%" valign="top">
											<table width="100%">
												<tr>
													<td width="5%" class="labelit" style="color:#labelColor#;">
														<cf_tl id="No.">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#currentrow#
													</td>
												</tr>
												<tr>
													<td class="labelit" style="color:#labelColor#;">
														<cf_tl id="Location">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#ElementOrgUnitName#
													</td>
												</tr>
												<tr>
													<td class="labelit" style="color:#labelColor#;">
														<cf_tl id="Description">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#ActionMemo#
													</td>
												</tr>
												<tr>
													<td class="labelit" style="color:#labelColor#;">
														<cf_tl id="Remarks">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#AttachmentMemo#
													</td>
												</tr>
											</table>
										</td>
										<td style="padding-left:10px;" valign="top">
											<table width="100%">
												<tr>
													<td width="5%" class="labelit" style="color:#labelColor#;">
														<cf_tl id="Class">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#ActionClassDescription#
													</td>
												</tr>
												<tr>
													<td class="labelit" style="color:#labelColor#;">
														<cf_tl id="Completed">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#lsDateFormat(DateTimeActual,client.dateFormatshow)# @ #lsTimeFormat(DateTimeActual, 'hh:mm tt')#
													</td>
												</tr>
												<tr>
													<td class="labelit" style="color:#labelColor#;">
														<cf_tl id="Picture">
													</td>
													<td width="1%" style="padding-left:3px; padding-right:3px; color:#labelColor#;">:</td>
													<td style="padding-left:5px; color:#dataColor#;" class="labelit">
														#OfficerFirstName# #OfficerLastName# @ #lsDateFormat(Created,client.dateFormatshow)# #lsTimeFormat(Created, 'hh:mm tt')#
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</div>
						</div>
				    </li>
				</cfoutput>
			  </ul>
			</div>
		</td>
	</tr>
</table>

<cfset vSlideShowSpeed = 10000>

<cfsavecontent variable="loaded">

	$('#carousel').flexslider({
		animation: 'slide',
		useCSS: true,
		controlNav: false,
		animationLoop: false,
		animationSpeed: 1000, 
		slideshow: false,
		itemWidth: 210,
		itemMargin: 5,
		touch: true, 
		asNavFor: '#slider'
	});
	
	$('#slider').flexslider({
		animation: 'fade',
		useCSS: true,
		controlNav: false,
		animationLoop: true,
		animationSpeed: 1000, 
		touch: true, 
		slideshow: true,
		slideshowSpeed: <cfoutput>#vSlideShowSpeed#</cfoutput>,
		pausePlay: true, 
		pauseText: 'Pausa',
		playText: 'Play', 
		pauseOnAction: true,
		pauseOnHover: false,
		multipleKeyboard: true,
		keyboard: true,
		mousewheel: false,
		prevText: "Anterior",
		nextText: "Siguiente",
		sync: '#carousel'
	});

</cfsavecontent>

<cfset AjaxOnLoad("function(){ #loaded# }")>


  

