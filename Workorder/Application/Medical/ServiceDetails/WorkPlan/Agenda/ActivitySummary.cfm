
<cfparam name="url.orgunit"    default="">
<cfparam name="url.positionno" default="">

<cfquery name="Check" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   DISTINCT SM.SettingShowSchedule	
		FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
		         WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId INNER JOIN
                 WorkOrderLineAction AS WLA ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
                 WorkOrder AS W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
                 ServiceItemMission AS SM ON W.ServiceItem = SM.ServiceItem AND W.Mission = SM.Mission
		
		WHERE    WP.Mission = '#url.mission#' 
		<cfif url.orgunit neq "" and url.orgunit neq "0">
		AND      WP.OrgUnit = '#url.orgunit#' 
		</cfif>
		<cfif url.positionno neq "">
		AND      WP.PositionNo = '#url.positionno#' 
		</cfif>	
		AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'		
		AND      WPD.WorkActionid is not NULL
		ORDER BY SM.SettingShowSchedule DESC
</cfquery>	


<cfset lMemo = 30>

<table width="100%" class="labelit">

<cfif url.positionno neq "">
			 
	<cfquery name="Schedule"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			SELECT  WSH.CalendarHour, WSH.ActionClass,					
					(SELECT ViewColor
					 FROM   Ref_WorkAction
					 WHERE  ActionClass = WSH.ActionClass) as ViewColor
			
			FROM    WorkScheduleDateHour AS WSH WITH (NOLOCK) INNER JOIN
					WorkSchedule AS W WITH (NOLOCK) ON W.Code = WSH.WorkSchedule 
			
			<!--- define the schedule to be shown for this position, keep in mind we can have more than one but not supported yet in this
			query --->
					 
			WHERE    W.Code IN (SELECT   W.Code	
								FROM     WorkSchedulePosition AS WSP WITH (NOLOCK) INNER JOIN
										 WorkSchedule AS W  WITH (NOLOCK) ON W.Code = WSP.WorkSchedule				 
								WHERE    W.Mission        = '#url.mission#'		 					
								AND      WSP.PositionNo   = '#url.positionno#'					
								AND      WSP.CalendarDate = '#dateformat(url.calendardate,client.dateSQL)#'	
								AND      Operational = 1 )				
					
			AND      WSH.CalendarDate = '#dateformat(url.calendardate,client.dateSQL)#' 
			ORDER BY CalendarHour
													
	 </cfquery>
	 
	 <tr><td colspan="2" valign="top">
	 
		 <table align=="center" style="border:1px solid silver">
		 <tr>		 
		 <cfoutput query="Schedule">
		     <cfif currentrow eq "1">
		 	<td align="center" style="font-size:9px;width:20px;background-color:ffffcf;height:6px;border-left:1px solid silver">#calendarhour#</td>
			<cfelseif currentrow eq recordcount>
			<td align="center" style="font-size:9px;width:20px;background-color:ffffcf;height:6px;border-left:1px solid silver">#calendarhour#</td>
			</cfif>
			
		 </cfoutput>
		 </tr>
		 </table>
		 
	 </td></tr>
 
</cfif> 


<cfif Check.settingshowSchedule eq 1 and url.positionno neq "">
	
	<cfquery name="Summary" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
			SELECT   1 as ListingOrder,
			         WL.WorkOrderLineId, 
					 WPD.DateTimePlanning, 
					 A.LastName, 
					 WLA.ActionClass, 
					 R.DescriptionShort as Description, 
					 WS.Description as WorkOrderService
					 
			FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
			         WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId INNER JOIN
			         WorkOrderLineAction WLA WITH (NOLOCK) ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
			         WorkOrderLine WL WITH (NOLOCK) ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
					 WorkOrderService WS WITH (NOLOCK) ON WS.ServiceDomain = WL.ServiceDomain AND WS.Reference = WL.Reference INNER JOIN
			         Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
		             WorkOrder W WITH (NOLOCK) ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		             Customer C WITH (NOLOCK) ON W.CustomerId = C.CustomerId INNER JOIN
		             Applicant.dbo.Applicant A WITH (NOLOCK) ON C.PersonNo = A.PersonNo	
					 
			WHERE    WP.Mission = '#url.mission#' 
			<cfif url.orgunit neq "" and url.orgunit neq "0">
			AND      WP.OrgUnit = '#url.orgunit#' 
			</cfif>
			<cfif url.positionno neq "">
			AND      WP.PositionNo = '#url.positionno#' 
			</cfif>	
			AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'
			
			AND      WL.Operational   = 1
			AND      WPD.Operational  = 1
			AND      WLA.ActionStatus != '9'
			
			UNION
		
			SELECT   2 as ListingOrder,NULL WorkOrderLineId, WPD.DateTimePlanning, '' LastName, 
					 '' ActionClass, 
					 LEFT(WPD.Memo,#lMemo#) as Description, '' as WorkOrderService
					 
			FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
			         WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId	
					 
			WHERE    WP.Mission = '#url.mission#' 
			<cfif url.orgunit neq "" and url.orgunit neq "0">
			AND      WP.OrgUnit = '#url.orgunit#' 
			</cfif>
			<cfif url.positionno neq "">
			AND      WP.PositionNo = '#url.positionno#' 
			</cfif>	
			AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'
			AND      WPD.Operational  = 1
			AND      WPD.WorkActionId IS NULL	
			AND      WPD.Memo IS NOT NULL
			AND      NOT EXISTS
			(
				
				SELECT * 
				FROM WorkPlanDetail WPD2 WITH (NOLOCK)
				WHERE WPD2.dateTimeplanning = WPD.DateTimePlanning
				AND WPD2.WorkPlanId = WPD.WorkPlanId
				AND WPD2.WorkPlanDetailId != WPD.WorkPlanDetailId
				AND WPD2.Operational = 1
				AND WPD2.WorkActionId IS NOT NULL			
			)	
			ORDER BY ListingOrder,WPD.DateTimePlanning
			
	</cfquery>	
	
	<cfoutput query="Summary">
		<cfif Description neq "">
		  <cfif ActionClass neq "">
			  <tr class="labelit" style="font-size:12px;height:15px">
				<td style="padding-left:6px">
				#timeformat(DateTimePlanning,"HH:")#<font size="1">#timeformat(DateTimePlanning,"MM")#</font>
				</td>
				<td style="padding-left:3px;font-size:12px;padding-top:1px">
				<a href="javascript:openaction('#workorderlineid#')"><font color="0080C0">#LastName# [#left(ActionClass,1)#]</a>
				</td>	
			  </tr>	  			   
			  <tr class="labelit <cfif currentrow neq recordcount>line</cfif>" style="font-size:12px">  	
				<td colspan="2" style="padding-left:10px;color:gray;">#workorderService#:#left(ActionClass,1)#</td>
			  </tr>
		  <cfelseif Len(Description) gt 3>
		  	<tr class="labelit" style="font-size:12px">
				<td style="padding-left:6px;color:gray" colspan="2">-#Description#</td>
		 	 </tr>	      
		  </cfif>
	  	</cfif>
	</cfoutput>

<cfelse>

	<cfquery name="Summary" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   WL.WorkOrderLineId, 
			         WPD.DateTimePlanning, 
					 A.LastName, 
					 WLA.ActionClass, 
					 R.DescriptionShort as Description, 
					 WS.Description as WorkOrderService
					 
			FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
			         WorkPlan WP  WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId INNER JOIN
			         WorkOrderLineAction WLA WITH (NOLOCK) ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
			         WorkOrderLine WL WITH (NOLOCK) ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
					 WorkOrderService WS WITH (NOLOCK) ON WS.ServiceDomain = WL.ServiceDomain AND WS.Reference = WL.Reference INNER JOIN
			         Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
		             WorkOrder W WITH (NOLOCK) ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		             Customer C WITH (NOLOCK) ON W.CustomerId = C.CustomerId INNER JOIN
		             Applicant.dbo.Applicant A WITH (NOLOCK)  ON C.PersonNo = A.PersonNo	
			WHERE    WP.Mission = '#url.mission#' 
			<cfif url.orgunit neq "" and url.orgunit neq "0">
			AND      WP.OrgUnit = '#url.orgunit#' 
			</cfif>
			<cfif url.positionno neq "">
			AND      WP.PositionNo = '#url.positionno#' 
			</cfif>	
			AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'
			
			AND      WL.Operational   = 1
			AND      WPD.Operational  = 1
			AND      WLA.ActionStatus != '9'
			AND      WL.ServiceDomain = 'Operation'
	</cfquery>
	
	<cfoutput query="Summary">
		<cfif Description neq "">
			  <tr class="labelit" style="height:15px;font-size:12px">
				<td style="padding-left:6px">
				#timeformat(DateTimePlanning,"HH:")#<font size="1">#timeformat(DateTimePlanning,"MM")#</font>
				</td>
				<td style="padding-left:3px;font-size:12px">
				<a href="javascript:openaction('#workorderlineid#')"><font color="0080C0">#LastName# [#left(ActionClass,1)#]</a></td>	
			  </tr>
			  
			  <tr class="labelit <cfif currentrow neq recordcount>line</cfif>" style="height:15px;padding-left:3px;font-size:12px">  	
				<td colspan="2" style="padding-left:10px;color:gray;font-size:11px;">#workorderService#:#left(ActionClass,1)#</td>
			  </tr>
	 	</cfif>
	</cfoutput>
	
	<cfquery name="Summary" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   1 as ListingOrder,
			         WLA.ActionClass,
					 R.DescriptionShort as Description, 
					 COUNT(*) AS Counted
			FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
			         WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId INNER JOIN
			         WorkOrderLineAction WLA WITH (NOLOCK) ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
			         WorkOrderLine WL WITH (NOLOCK) ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
			         Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
		             WorkOrder W WITH (NOLOCK) ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		             Customer C WITH (NOLOCK) ON W.CustomerId = C.CustomerId INNER JOIN
		             Applicant.dbo.Applicant A WITH (NOLOCK) ON C.PersonNo = A.PersonNo	
			WHERE    WP.Mission = '#url.mission#' 
			<cfif url.orgunit neq "" and url.orgunit neq "0">
			AND      WP.OrgUnit = '#url.orgunit#' 
			</cfif>
			<cfif url.positionno neq "">
			AND      WP.PositionNo = '#url.positionno#' 
			</cfif>	
			AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'
			
			AND      WL.Operational   = 1
			AND      WPD.Operational  = 1
			AND      WLA.ActionStatus != '9'
			AND      WL.ServiceDomain != 'Operation'
			GROUP BY WLA.ActionClass, WL.ServiceDomain,R.DescriptionShort
				
			UNION
			
			SELECT   2 as ListingOrder,'' as ActionClass, LEFT(WPD.Memo,#lMemo#) as Description, 1 AS Counted
			FROM     WorkPlanDetail WPD WITH (NOLOCK) INNER JOIN
			         WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId 	
			WHERE    WP.Mission = '#url.mission#' 
			<cfif url.orgunit neq "" and url.orgunit neq "0">
			AND      WP.OrgUnit = '#url.orgunit#' 
			</cfif>
			<cfif url.positionno neq "">
			AND      WP.PositionNo = '#url.positionno#' 
			</cfif>	
			AND      WP.DateEffective = '#dateformat(url.calendardate,client.dateSQL)#'
			
			AND      WPD.Operational  = 1
			AND      WPD.WorkActionId IS NULL	
			AND      WPD.Memo IS NOT NULL	
			AND      NOT EXISTS
			(
				
				SELECT * 
				FROM WorkPlanDetail WPD2 WITH (NOLOCK)
				WHERE WPD2.dateTimeplanning =WPD.DateTimePlanning
				AND WPD2.WorkPlanId = WPD.WorkPlanId
				AND WPD2.WorkPlanDetailId != WPD.WorkPlanDetailId
				AND WPD2.Operational = 1
				AND WPD2.WorkActionId IS NOT NULL			
			)	
			ORDER BY ListingOrder	
					
	</cfquery>	
		
	<cfoutput query="Summary">
		<cfif Description neq "">		
			<cfif actionClass neq "">
		  		<tr class="labelit" style="font-size:11px">
					<td style="padding-left:6px">#left(ActionClass,1)#:#Description#</td>
					<td align="right" style="padding-right:5px">#counted#</td>
		 		 </tr>
		  	<cfelseif Len(Description) gt 3>
		  		<tr class="labelit">
					<td style="padding-left:6px;color:gray" colspan="2">- #Description#</td>
		 	 	</tr>	      
		  	</cfif>	  
		 </cfif>
	  
	</cfoutput>

</cfif>

</table>

