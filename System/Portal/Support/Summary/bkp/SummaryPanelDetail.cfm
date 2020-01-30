<cfparam name="url.accFilter" 		default="null">
<cfparam name="url.statusFilter" 	default="">
<cfparam name="url.classFilter" 	default="">
<cfparam name="url.sortingFilter" 	default="0">
<cfparam name="url.dateFilter" 		default="#lsDateFormat(now(),client.dateFormatShow)#">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dateFilter#">
<cfset vDateFilter = dateValue>

<cfquery name="basedata" 
	datasource="AppsControl" 
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
		FROM	Observation O 
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
			AND		O.ActionStatus     < '3'
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

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection"    
   object           = "WorkflowAction" 
   ScopeId          = "#url.systemfunctionid#"
   ControllerNo     = "995"
   ObjectContent    = "#basedata#"
   Objectidfield    = "observationid"
   delay            = "8"> 

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
		paneItemOffset="#url.itemOffset#">
			
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
		
				<cf_paneItem id="#ObservationId#" 
						source="#session.root#/System/Portal/Support/Summary/SummaryPanelContent.cfm?ObservationId=#ObservationId#&type=#vType#"
						filterValue="#ObservationNo# #Reference# #RequestName# #ApplicationServer# #OfficerFirstName# #OfficerLastName# #OfficerUserId# #StatusDescription# #vActorList# #WFClassName#"
						style="background-color:##F2F2F2; border:1px solid ##F2F2F2; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px;"
						headerStyle="font-size:175%; color:##FFFFFF; font-weight:bold; padding-top:0px; padding-bottom:0px; #vStyle#"
						showSeparator="0"
						systemfunctionid="#url.systemfunctionid#"
						width="#url.itemSize#px"
						height="290px"
						ShowPrint="1"
						Transition="fade"
						TransitionTime="1000"
						IconSet="white"
						IconHeight="13px"
						label="#ObservationNo# &nbsp;<span style=font-size:60%;><span style=font-weight:normal;><i>#lsDateFormat(ObservationDate,client.dateFormatShow)#</i></span></span>">
						
			</cfloop>
			
	</cf_pane>

</cfloop>	





