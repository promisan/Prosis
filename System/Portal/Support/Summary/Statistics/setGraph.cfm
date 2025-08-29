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
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#url.init#">
<cfset vInit = dateValue>
<cfset vInit = dateAdd('s',1,vInit)>
<cfset vInit = dateAdd('s',-1,vInit)>

<cfset dateValue = "">
<CF_DateConvert Value="#url.end#">
<cfset vEnd = dateValue>

<cfset vEnd = dateAdd('d',1,vEnd)>
<cfset vEnd = dateAdd('s',-1,vEnd)>

<cfif url.by eq "actor" or url.by eq "assigner">

	<cfquery name="getTickets" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT DISTINCT	 
					 O.ObservationId,
					 OAS.ObjectId,
					 OAS.UserAccount, 
					 U.FirstName, 
					 U.LastName,
					 OAS.OfficerUserId,
					 OAS.OfficerFirstName,
					 OAS.OfficerLastName,
					 CONVERT(VARCHAR(7),O.Created,120) as DateValue
			FROM     Observation O 
			         INNER JOIN Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4 AND B.EntityCode = 'SysTicket'
			         INNER JOIN Organization.dbo.OrganizationObjectActionAccess OAS ON B.ObjectId = OAS.ObjectId
					 INNER JOIN Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysTicket' AND R.EntityStatus = O.ActionStatus 
				     INNER JOIN System.dbo.Ref_SystemModule M ON O.SystemModule = M.SystemModule 			
					 INNER JOIN System.dbo.Ref_Application  A ON A.Code = B.EntityGroup
					 INNER JOIN System.dbo.UserNames U ON O.Requester = U.Account
					 
			WHERE    O.ObservationClass = 'Inquiry'
						AND		 O.Created BETWEEN #vInit# AND #vEnd#
						AND 	 O.ActionStatus NOT IN ('8','9')
						AND		 O.ObservationId = OAS.ObjectId

	</cfquery>
	
	<cfif url.by eq "actor">

		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					UserAccount as Topic,
					UserAccount as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					UserAccount
			ORDER BY UserAccount ASC, DateValue DESC
		</cfquery>
	
	</cfif>
	
	<cfif url.by eq "assigner">
	
		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					OfficerUserId as Topic,
					OfficerUserId as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					OfficerUserId
			ORDER BY OfficerUserId ASC, Created DESC
		</cfquery>
	
	</cfif>

<cfelse>

	<cfquery name="getTickets" 
		datasource="AppsControl" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT   O.*, 
					 R.StatusDescription,
					 ISNULL((
						SELECT TOP 1 OI.DocumentItemValue
						FROM    Organization.dbo.OrganizationObjectInformation AS OI 
								INNER JOIN Organization.dbo.Ref_EntityDocument AS ED
									ON OI.DocumentId = ED.DocumentId
								INNER JOIN Organization.dbo.OrganizationObject AS OO 
									ON OI.ObjectId = OO.ObjectId
						WHERE	OO.Operational = 1 
						AND		OO.ObjectKeyValue4 = O.ObservationId
						AND		ED.EntityCode = R.EntityCode
						AND		ED.DocumentCode = 'c001'
						ORDER BY OI.CREATED DESC
					),'[Not classified]') as Classification,
					CONVERT(VARCHAR(7),O.Created,120) as DateValue,
					CASE
						WHEN LTRIM(RTRIM(U.AccountOwner)) = '' THEN '[No owner]'
						ELSE ISNULL(LTRIM(RTRIM(U.AccountOwner)), '[No owner]') 
					END as AccountOwner,
					A.Code as Application,
					A.Description as ApplicationDescription
			 
			FROM     Observation O 
			         INNER JOIN [#Parameter.databaseServer#].Organization.dbo.OrganizationObject B ON O.ObservationId = B.ObjectKeyValue4 AND B.EntityCode = 'SysTicket'
					 INNER JOIN [#Parameter.databaseServer#].Organization.dbo.Ref_EntityStatus R ON R.EntityCode = 'SysTicket' AND R.EntityStatus = O.ActionStatus 
				     INNER JOIN [#Parameter.databaseServer#].System.dbo.Ref_SystemModule M ON O.SystemModule = M.SystemModule 			
					 INNER JOIN [#Parameter.databaseServer#].System.dbo.Ref_Application  A ON A.Code = B.EntityGroup
					 INNER JOIN [#Parameter.databaseServer#].System.dbo.UserNames U ON O.Requester = U.Account
					 
			WHERE    O.ObservationClass = 'Inquiry'
			AND		 O.Created BETWEEN #vInit# AND #vEnd#
			AND 	 O.ActionStatus NOT IN ('8','9')
					 
			ORDER BY O.Created DESC
			
	</cfquery>
	
	<cfif url.by eq "status">
	
		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					ActionStatus as Topic,
					StatusDescription as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					ActionStatus,
					StatusDescription
			ORDER BY ActionStatus ASC, Created DESC
		</cfquery>
	
	</cfif>
	
	<cfif url.by eq "owner">
	
		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					AccountOwner as Topic,
					AccountOwner as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					AccountOwner
			ORDER BY AccountOwner ASC, Created DESC
		</cfquery>
	
	</cfif>
	
	<cfif url.by eq "application">
	
		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					Application as Topic,
					ApplicationDescription as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					Application,
					ApplicationDescription
			ORDER BY Application ASC, Created DESC
		</cfquery>
	
	</cfif>
	
	<cfif url.by eq "classification">
	
		<cfquery name="getTicketsByDateTopic" dbtype="query">
			SELECT	DateValue,
					Classification as Topic,
					Classification as TopicValue,
					COUNT(*) as TopicTotal
			FROM	getTickets
			GROUP BY
					DateValue,
					Classification
			ORDER BY Classification ASC, Created DESC
		</cfquery>
	
	</cfif>
	
</cfif>

<cfset vImagePath = "#session.rootpath#\CFRStage\user\#session.acc#\_supportStatisticChart_">
<cfset vImageURL = "#session.root#/CFRStage/user/#session.acc#/_supportStatisticChart_">
<cfset colorArray = ['##E8875D','##339AFA','##66AC6A','##5DB7E8','##5DE8D8','##CCCA6A','##E8BC5D','##E85DA2','##FFFA9A','##999A9A']>

<cfset vPlacement = "default">
<cfswitch expression="#url.type#">
	<cfcase value="area">
		<cfset vPlacement = "stacked">
	</cfcase>
	<cfcase value="bar">
		<cfset vPlacement = "cluster">
	</cfcase>
	<cfcase value="pie">
		<cfset vPlacement = "cluster">
	</cfcase>
</cfswitch>

<cfoutput>
	<div class="clsPrintContentSupportImage_#url.id#">
		<table width="100%" align="center">
			<tr>
				<td class="labellarge" width="50px" style="font-size:45px; padding-left:20px;">
					#url.id#
				</td>
				<td width="100%">
					<table width="100%">
						<tr>
							<td class="labellarge" id="printTitle"><span style="text-transform:capitalize;"><cf_tl id="Tickets by"> #url.by#</span></td>
						</tr>
						<tr>
							<td class="labelit" style="font-size:11px; padding-left:5px;">
								#lsDateFormat(vInit,client.dateFormatShow)# - #lsDateFormat(vEnd,client.dateFormatShow)#
							</td>
						</tr>
					</table>
				</td>
				<td style="padding-right:10px;" align="right" valign="middle" width="10px" class="clsNoPrint">
					<table>
						<tr>
							<td style="padding-right:5px;">
								<cf_tl id="Print" var="1">
								<cf_button2 
									type="Print"
									mode="Icon"
									height="30px"
									width="auto"
									title="#lt_text#"
									printTitle="##printTitle"
									printContent=".clsPrintContentSupportImage_#url.id#,.clsPrintContentSupportGraph_#url.id#">
							</td>
							<td>
								<cf_tl id="Remove" var="1">
								<cf_button2 
									mode="Icon"
									image="delete_blue.png"
									height="30px"
									width="auto"
									title="#lt_text#"
									onclick="removeChart('#url.id#');">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" style="display:none;" class="clsPrintContentSupportGraph_#url.id#">
					<table width="100%" align="center">
						<tr>
							<td width="100%" align="center">
								<cfset vGenerateFile = 1>
								<cfinclude template="drawGraph.cfm">
								<img src="#vImageURL##url.id#.png?ts=#now()#" align="absmiddle">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" class="clsNoPrint">
					<cfset vGenerateFile = 0>
					<cfinclude template="drawGraph.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" id="detailContainer_#url.id#" class="clsNoPrint"></td>
			</tr>
			<tr>
				<td colspan="4" align="right" class="labelit" style="font-size:11px; padding-right:10px;">
					#lsDateFormat(now(), client.dateFormatshow)# - #lsTimeFormat(now(),'hh:mm:ss tt')#
				</td>
			</tr>
		</table>
	</div>
</cfoutput>

