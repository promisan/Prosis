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
<cfquery name="getSystemParameter" 
	datasource="AppsSystem">
	SELECT TOP 1 *
	FROM   Parameter
</cfquery>

<cfset vMessageLength = 100>

<cfquery name="getDetail" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	O.*,
				R.StatusDescription,
				
				(
					SELECT TOP 1 OfficerDate
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObjectAction
					WHERE   ObjectId = O.ObservationId 
					AND     ActionStatus != '0'
					ORDER BY OfficerDate DESC
				) AS LastAction,
				
				(
					SELECT TOP 1 OfficerLastName
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObjectAction
					WHERE   ObjectId = O.ObservationId 
					AND     ActionStatus != '0'
					ORDER BY OfficerDate DESC
				) AS LastActionName,	
				(
					SELECT TOP 1 Created
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObjectActionMail
					WHERE   ObjectId = O.ObservationId 
					AND		MailType = 'Comment'
					ORDER BY Created DESC
				) AS LastMessage,
				(
					SELECT TOP 1 OfficerUserId
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObjectActionMail
					WHERE	ObjectId = O.ObservationId 
					AND		MailType = 'Comment'
					ORDER BY Created DESC
				) AS LastMessageByAcc,
				(
					SELECT TOP 1 OfficerLastName
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObjectActionMail
					WHERE	ObjectId = O.ObservationId 
					AND		MailType = 'Comment'
					ORDER BY Created DESC
				) AS LastMessageName,
				(
					SELECT 	MAX(ActionTimeStamp) 
					FROM 	[#getSystemParameter.DatabaseServer#].Organization.dbo.UserActionEntity 
					WHERE 	ObjectId = O.ObservationId 
					AND 	Account = O.OfficerUserId
				) as LastAccess,
				(
					SELECT	EC.EntityClassName
					FROM	[#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObject OO
							INNER JOIN [#getSystemParameter.DatabaseServer#].Organization.dbo.Ref_EntityClass EC
								ON OO.EntityCode = EC.EntityCode
								AND OO.EntityClass = EC.EntityClass
					WHERE	OO.ObjectId = O.ObservationId
				) as WFClassName
					
		FROM	Observation O INNER JOIN [#getSystemParameter.DatabaseServer#].Organization.dbo.Ref_EntityStatus R ON O.ActionStatus = R.EntityStatus AND R.EntityCode = 'SysTicket'
		WHERE	O.ObservationId = '#url.ObservationId#'
		AND     O.ObservationId IN (SELECT ObjectKeyValue4 FROM [#getSystemParameter.DatabaseServer#].Organization.dbo.OrganizationObject WHERE Objectid = O.ObservationId AND Operational = 1)									
		ORDER BY ObservationDate DESC
</cfquery>


<cfquery name="getRequester" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   System.dbo.UserNames U 
	WHERE  U.Account = '#getDetail.requester#'
</cfquery>	

<cfquery name="getActors" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT 
			OAS.UserAccount, 
			U.FirstName, 
			U.LastName
	FROM   	OrganizationObjectActionAccess OAS 
			INNER JOIN System.dbo.UserNames U 
				ON OAS.UserAccount = U.Account
	WHERE 	OAS.ObjectId = '#url.ObservationId#'
</cfquery>	

<cfset vTextColor = "color:##6D6E70;">

<cfif getDetail.recordcount eq "0">

	<table width="100%"><tr><td class="labelmedium" style="padding-top:30px" align="center">Record no longer exists</td></tr></table>

<cfelse>

	<cfoutput query="getDetail">	
		
		<table width="100%" style="#vTextColor# padding-left:10px">
			<tr>
				<td style="padding-left:15px;">
					<table width="100%" style="#vTextColor#">
						<tr>
							<td class="labelit" width="22%" valign="top" style="padding-top:8px;">
								<table>
									<tr>
										<td class="clsNoPrint" style="padding-right:10px;">
											<cf_tl id="View Ticket" var="1">
											<img 
												src="#session.root#/Images/open_gray.png" 
												style="cursor:pointer; height:14px;" 
												title="#lt_text#" 
												onclick="supportticketedit('#ObservationId#')">
										</td>
										<td>								
										
											<table><tr>
												<td bgcolor="<cfif RequestPriority eq 'High'>red<cfelseif RequestPriority eq 'Medium'>FF8000<cfelse>Yellow</cfif>" style="height:14px;width:14px;border:1px solid gray"></td>
												<td bgcolor="<cfif ObservationFrequency eq 'High'>red<cfelseif ObservationFrequency eq 'Medium'>FF8000<cfelse>Yellow</cfif>" style="width:14px;border:1px solid gray"></td>
												<td bgcolor="<cfif ObservationImpact eq 'High'>red<cfelseif ObservationImpact eq 'Medium'>FF8000<cfelse>Yellow</cfif>" style="width:14px;border:1px solid gray"></td>							
											</tr></table>
										</td>
									</tr>
								</table>
							</td>
							<td class="labelit" valign="top" style="padding-top:8px;">
							 <table><tr><td class="labelit" style="padding-right:4px">
							 #getRequester.FirstName# #UCASE(getRequester.LastName)#
							 </td>
							 
							 </tr>
							 
							 </table>
								
							</td>
							<td rowspan="7" valign="top" align="center" width="5%">
								<table>
									<tr>
										<td align="center">
											<cfif not FileExists("#session.rootdocumentpath#\EmployeePhoto\#OfficerUserId#.jpg")>
												<cfset vEmpPhotoPath = "#session.root#/images/logos/no-picture-male.png">	
											<cfelse>
												<cfset vEmpPhotoPath = "#session.rootdocument#/EmployeePhoto/#OfficerUserId#.jpg">									
											</cfif>
											<img src="#vEmpPhotoPath#" title="#OfficerFirstName# #OfficerLastName#" style="height:85px; max-width:110px; cursor:pointer; width:auto;" align="absmiddle">	
										</td>
									</tr>
									<tr>
										<td align="center" style="padding-top:5px;">
											<cfif actionStatus eq 3>
												<cf_tl id="Completed" var="1">
												<img src="#session.root#/images/thumbsup_green.png" style="height:45px; cursor:pointer;" align="absmiddle" title="#lt_text#">
											<cfelse>
												<cfif actionStatus eq 2>
													<cf_tl id="Resolved but not completed yet" var="1">
													<img src="#session.root#/images/check_orange.png" style="height:45px; cursor:pointer;" align="absmiddle" title="#lt_text#">
												<cfelse>
													<cfif url.type eq 1 and actionStatus lt 2>
														<cf_tl id="Delayed and without action" var="1">
														<img src="#session.root#/images/warning.png" style="height:45px; cursor:pointer;" align="absmiddle" title="#lt_text#">
													</cfif>
												</cfif>									
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td class="labelit">
								<cf_tl id="Application">:
							</td>
							<td class="labelit">
								#ApplicationServer#/#SystemModule#
							</td>
						</tr>
						
						<tr>
							<td class="labelit">
								<cf_tl id="Lead Time">:
							</td>
							<td class="labelit">
								<cfset vDays = dateDiff('d',Created, now())>
								<cfif vDays lt 1>
									<cfset vHours = dateDiff('h',Created, now())>
									<cfif vHours lt 1>
										<cfset vMinutes = dateDiff('n',Created, now())>
										#vMinutes# <cfif vMinutes eq 1><cf_tl id="Minute"><cfelse><cf_tl id="Minutes"></cfif>
									<cfelse>
										#vHours# <cfif vHours eq 1><cf_tl id="Hour"><cfelse><cf_tl id="Hours"></cfif>
									</cfif>
								<cfelse>
									#vDays# <cfif vDays eq 1><cf_tl id="Day"><cfelse><cf_tl id="Days"></cfif>
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td class="labelit">
								<cf_tl id="Status">:
							</td>
							<td class="labelit">
								<b>#StatusDescription#</b>
							</td>
						</tr>
						
						<tr>
							<td class="labelit">
								<cf_tl id="Class">:
							</td>
							<td class="labelit">
								<b>#WFClassName#</b>
							</td>
						</tr>
												
						<cfif LastAction neq "">
							<tr>
								<td class="labelit">
									<cf_tl id="Last Action">:
								</td>
								<td class="labelit">																
									#lsDateFormat(LastAction,"DD/MM")# #timeFormat(LastAction,"HH:MM")# #LastActionName#
								</td>
							</tr>
							
						</cfif>
						
												
						
						<tr>
							<td class="labelit">
								<cf_tl id="Comment">:
							</td>
							<td class="labelit">
								<cfif LastMessage neq "">
								#lsDateFormat(LastMessage,"DD/MM")# #timeFormat(LastMessage,"HH:MM")# #LastMessageName#
								<cfelse>
								n/a
								</cfif>
							</td>
						</tr>
						
						
						<tr>
							<td class="labelit" valign="top" style="">
								<cf_tl id="Actors">:
							</td>
							<td class="labelit" colspan="2" valign="top" style=" font-weight:bold;">
								<cfset vActorList = "">
								<cfloop query="getActors">
									<cfset vActorList = vActorList & LastName & ", ">
								</cfloop>
								<cfif vActorList neq "">
									<cfset vActorList = mid(vActorList, 1, len(vActorList) - 2)>
									#vActorList#
								<cfelse>
									[<cf_tl id="Not defined">]
								</cfif>
							</td>
						</tr>
						
						<tr>
							<td class="labelit" valign="top" style="padding-top:3px;">
								<cf_tl id="Briefs">:
							</td>
							<cfset vRequestText = trim(RequestName)>
							<td valign="top" class="labelit" colspan="2" style="padding-top:3px; #vTextColor#" title="#vRequestText#">
								#LEFT(vRequestText, 50)#<cfif LEN(vRequestText) gt 50>...</cfif>
							</td>
						</tr>

					</table>
				</td>
			</tr>
		</table>
		
	</cfoutput>
	
</cfif>	