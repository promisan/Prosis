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
<cfparam name="url.accFilter" 		default="null">
<cfparam name="url.statusFilter" 	default="">
<cfparam name="url.classFilter" 	default="">
<cfparam name="url.sortingFilter" 	default="0">
<cfparam name="url.dateFilter" 		default="#lsDateFormat(now(),client.dateFormatShow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateFilter#">
<cfset vDateFilter = dateValue>

<cfquery name="getSystemParameter" 
	datasource="AppsSystem">
	SELECT TOP 1 *
	FROM   Parameter
</cfquery>

<cfquery name="basedata" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT	O.*,
				R.StatusDescription,
				(
					SELECT	EC.EntityClassName
					FROM	Organization.dbo.OrganizationObject OO
							INNER JOIN Organization.dbo.Ref_EntityClass EC
								ON OO.EntityCode = EC.EntityCode
								AND OO.EntityClass = EC.EntityClass
					WHERE	OO.ObjectId = O.ObservationId
				) as WFClassName
		FROM	[#getSystemParameter.ControlServer#].Control.dbo.Observation O 
				INNER JOIN Organization.dbo.Ref_EntityStatus R 
					ON O.ActionStatus = R.EntityStatus
		WHERe	R.EntityCode       = 'SysTicket'
		AND		O.ObservationClass = 'Inquiry'
		AND		O.ObservationDate <= #vDateFilter#
		
		<cfif not findNoCase("not",url.accFilter) and url.accFilter neq "null" and not findNoCase("all",url.accFilter)>
			AND 	EXISTS
					(
						SELECT 	'X'
						FROM   	Organization.dbo.OrganizationObjectActionAccess OAS 
								INNER JOIN System.dbo.UserNames U 
									ON OAS.UserAccount = U.Account
						WHERE 	OAS.ObjectId = O.ObservationId
						AND		OAS.UserAccount IN (#preserveSingleQuotes(url.accFilter)#)
					)
		<cfelseif findNoCase("all",url.accFilter)>
		
			AND 	 EXISTS
					(
						SELECT 	'X'
						FROM   	Organization.dbo.OrganizationObjectActionAccess OAS 
								INNER JOIN System.dbo.UserNames U 
									ON OAS.UserAccount = U.Account
						WHERE 	OAS.ObjectId = O.ObservationId
					)
		
			<!--- no filtering --->
		
		<cfelseif url.accFilter eq "not">
			AND 	NOT EXISTS
					(
						SELECT 	'X'
						FROM   	Organization.dbo.OrganizationObjectActionAccess OAS 
								INNER JOIN System.dbo.UserNames U 
									ON OAS.UserAccount = U.Account
						WHERE 	OAS.ObjectId = O.ObservationId
					)
		</cfif>
		
		<cfif url.statusFilter eq "" or url.statusFilter eq "null">
			<cfif url.mode eq "0">
				AND		O.ActionStatus     < '3'
			<cfelse>
				AND		O.ActionStatus     = '3'
			</cfif>
		<cfelse>
			AND		O.ActionStatus IN (#preserveSingleQuotes(url.statusFilter)#)
		</cfif>
		
		<cfif url.classFilter neq "" and url.classFilter neq "null">
			AND		EXISTS
					(
						SELECT 	'X'
						FROM	Organization.dbo.OrganizationObject
						WHERE	ObjectId = O.ObservationId
						AND		EntityCode = 'SysTicket'
						AND		EntityClass IN (#preserveSingleQuotes(url.classFilter)#)
					)
		</cfif>
		
		<cfif session.isAdministrator eq "No">
		
		AND    O.Mission IN (SELECT Mission 
		                     FROM   Organization.dbo.OrganizationAuthorization  
							 WHERE  UserAccount = '#session.acc#'
							 AND    Role        = 'OrgUnitManager'
							 AND    Mission     = O.Mission)
		
		</cfif>
		
		<cfif url.sortingFilter eq "1">
			ORDER BY  O.Created ASC
		<cfelseif url.sortingFilter eq "2">
			ORDER BY  O.ActionStatus DESC
		<cfelseif url.sortingFilter eq "3">
			ORDER BY  O.ActionStatus ASC
		<cfelse>
			ORDER BY  O.Created DESC
		</cfif>
		
</cfquery>


<!--- we only load this if the ticket is not closed to gain performance --->

<cfif url.statusfilter neq "3">

	<div style="display:;">
		<cfinvoke component = "Service.Connection.Connection"  
		   method           = "setconnection"    
		   object           = "WorkflowAction" 
		   ScopeId          = "#url.systemfunctionid#"
		   ControllerNo     = "995"
		   ObjectContent    = "#basedata#"
		   Objectidfield    = "observationid"
		   delay            = "8"> 
	</div>
   
</cfif>   

<!--- Search feature --->

<table width="100%">
	<tr>
		<td width="100%" style="padding-top:20px;">
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "topfiltersearch"
			   style            = "width:350px; padding:5px;"
			   rowclass         = "pane_clsSummaryPanelItem"
			   rowfields        = "pane_clsPaneFilterContent">
		</td>
	</tr>
</table>

<!--- getstatus --->

<cfquery name="getstatus" dbtype="query">
	SELECT DISTINCT ActionStatus,StatusDescription
	FROM BaseData
</cfquery>	
      
<cfset vThreshold = 1>

<cfloop query="getStatus">
	
	<cfquery name="get"  dbtype="query"> 
		SELECT *
		FROM BaseData
		WHERE ActionStatus = '#getStatus.ActionStatus#'
	</cfquery>	

	<cf_pane 
		id="ticketMonitor_#getStatus.ActionStatus#" 
		height="auto"
		label="#StatusDescription#"
		paneItemMinSize="#url.itemSize#" 
		paneItemOffset="#url.itemOffset#"
		search="no">
			
			<cfloop query="get">
			
				<cfset vType = 0>
				<cfset vStyle = "background-color:##52ACD1;">
				
				<cfif dateDiff('d',Created, now()) gt vThreshold>
					<cfset vType = 1>
					<cfset vStyle = "background-color:##E04937;">
				</cfif>
				
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
					WHERE 	OAS.ObjectId = '#ObservationId#'
				</cfquery>	
				
				<cfset vActorList = "">
				<cfloop query="getActors">
					<cfset vActorList = vActorList & " " & UserAccount>
				</cfloop>
				
				<cfset vSubmittedByMail = "">
				<cfif trim(lcase(Source)) eq "email">
					<cf_tl id="Submitted by email" var="1">
					<cfset vSubmittedByMail = "&nbsp;&nbsp;&nbsp;<img src='#session.root#/images/mail_white.png' style='height:11px; margin-bottom:-0.5px; cursor:pointer;' title='#lt_text#'>">
				</cfif>
						
				<cf_paneItem id="#ObservationId#" 
						source="#session.root#/System/Portal/Support/Summary/SummaryPanelContent.cfm?ObservationId=#ObservationId#&type=#vType#"
						filterValue="#ObservationNo# #Reference# #RequestName# #ApplicationServer# #OfficerFirstName# #OfficerLastName# #OfficerUserId# #StatusDescription# #vActorList# #WFClassName# #Source# #lsDateFormat(ObservationDate,client.dateFormatShow)#"
						style="background-color:##F2F2F2; border:1px solid ##F2F2F2; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px;"
						headerStyle="font-size:175%; color:##FFFFFF; font-weight:bold; padding-top:0px; padding-bottom:0px; #vStyle#"
						showSeparator="0"
						systemfunctionid="#url.systemfunctionid#"
						width="#url.itemSize#px"
						height="235px"
						ShowPrint="1"
						Transition="fade"
						TransitionTime="1000"
						IconSet="white"
						IconHeight="15px"
						IconStyle="padding-top:11px;"
						label="#ObservationNo# &nbsp;<span style=font-size:60%;><span style=font-weight:normal;>#lsDateFormat(ObservationDate,client.dateFormatShow)#</span>#vSubmittedByMail#</span>">
						
			</cfloop>
			
	</cf_pane>

</cfloop>	





