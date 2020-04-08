
<cfparam name="url.mission"          default="">
<cfparam name="client.workactionid"  default="">
<cfparam name="url.workactionid"     default="#client.workactionid#">
<cfparam name="url.orgunit"          default="0">
<cfparam name="url.minute" 			 default="">
<cfparam name="url.hour" 			 default="">
<cfparam name="url.size"             default="small">

<cfif url.size neq "embed">
	
	<cfoutput>
		<script>
			function showPrintableAgenda(mission, orgunit, schedule, selecteddate, positions) {
				var vPositions = "";
				$.each(positions, function(key, value) {
					if (key == 0) {
						vPositions = vPositions + "'" + value + "'";
					} else {
						vPositions = vPositions + ", '" + value + "'";
					}
				});
				window.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?template=/workorder/application/medical/serviceDetails/workplan/agenda/printable/agenda.cfr&id1="+mission+"&ID2="+orgunit+"&id3="+schedule+"&id4="+selecteddate+"&id5="+vPositions,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no");
			}
		</script>
	</cfoutput>

</cfif>


<cfif url.workactionid neq "">
	<cfset client.workactionid = url.workactionid>
</cfif>

<cfif url.workactionid neq "" and url.orgunit eq ""> 

	<cfquery name="WorkAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WorkOrderLineAction WLA WITH (NOLOCK), WorkOrderLine WL WITH (NOLOCK)
		WHERE  WLA.WorkOrderId   = WL.WorkOrderId
		AND    WLA.WorkorderLine = WL.WorkOrderLine
		AND    WLA.WorkActionid      = '#url.workactionid#'
	</cfquery>

	<cfset url.orgunit = WorkAction.OrgUnitImplementer>

</cfif>

<cfparam name="url.selecteddate"  default="05/05/2019">
<cfparam name="url.positionno"    default="">
<cfparam name="url.personno"      default="">
<cfparam name="url.matrix"        default="No">

<cfif url.size eq "">
	<cfset url.size = "small">
</cfif>

<cfif url.positionno eq "">
	<cfset url.matrix = "Yes">
</cfif>

<cfif url.matrix eq "yes">
	<cfset url.positionno = "">
</cfif>

<!--- ------------------------------ --->
<!--- obtain specialists to be shown --->
<!--- ------------------------------ --->

<cfif url.positionno neq "">

	<cfquery name="Position" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   DISTINCT P.PositionNo, 
		         P.FunctionDescription, 
				 P.OrgUnitOperational,
				 Pe.PersonNo, 
				 Pe.LastName, 
				 Pe.MiddleName,
				 Pe.FirstName,
				 G.PostOrder
	    FROM     Position P WITH (NOLOCK) INNER JOIN
	             PersonAssignment PA WITH (NOLOCK) ON P.PositionNo = PA.PositionNo INNER JOIN
	             Person Pe WITH (NOLOCK) ON PA.PersonNo = Pe.PersonNo INNER JOIN Ref_PostGrade G
				 ON G.PostGrade = P.PostGrade
	    WHERE    P.PositionNo = '#url.positionno#' 	
		<!--- is indeed working in that period --->
		AND      PA.DateEffective  <= '#dateformat(url.selecteddate,client.dateSQL)#' 
		AND      PA.DateExpiration >= '#dateformat(url.selecteddate,client.dateSQL)#'	
		AND      PA.AssignmentStatus IN ('0','1')
	</cfquery>	
		
<cfelse>
	
	<cfinvoke component = "Service.Access"  
	method           = "workorderprocessor" 
	mission          = "#url.mission#" 	
	orgunit          = "#url.orgunit#"					  
	returnvariable   = "access">  

	<cfquery name="Position" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   DISTINCT P.PositionNo, 
		         P.OrgUnitOperational,
		         P.FunctionDescription, 
				 Pe.PersonNo, 
				 Pe.LastName, 
				 Pe.MiddleName,
				 Pe.FirstName,
				 G.PostOrder
	    FROM     Position P WITH (NOLOCK) INNER JOIN
	             PersonAssignment PA WITH (NOLOCK) ON P.PositionNo = PA.PositionNo INNER JOIN
	             Person Pe ON PA.PersonNo = Pe.PersonNo INNER JOIN Ref_PostGrade G
				 ON G.PostGrade = P.PostGrade
	    WHERE    P.OrgUnitOperational = '#url.orgunit#' 					 
		AND      PA.Incumbency = 100 
		AND      PA.AssignmentStatus IN ('0','1')
		
		<!--- is indeed working in that period --->
		AND      PA.DateEffective  <= '#dateformat(url.selecteddate,client.dateSQL)#' 
		AND      PA.DateExpiration >= '#dateformat(url.selecteddate,client.dateSQL)#'
		
		<cfif access neq "ALL">
		<!--- person can inquire only his own --->
		AND      Pe.PersonNo = '#client.personno#'  
		</cfif>
		
		<!--- this position is enabled in one of the schedules --->
	 	
		AND      P.PositionNo IN ( SELECT   WSP.PositionNo
							       FROM     WorkSchedulePosition AS WSP 
							       WHERE    WSP.PositionNo = P.PositionNo 
								   AND      WSP.CalendarDate >= '#dateformat(url.selecteddate,client.dateSQL)#'
								 )	
		
		ORDER BY G.PostOrder ASC
	</cfquery>		
	
	<cfif Position.recordcount eq "0">
		
		<cfquery name="Position" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   DISTINCT P.PositionNo, 
			         P.OrgUnitOperational,
			         P.FunctionDescription, 
					 Pe.PersonNo, 
					 Pe.LastName, 
					 Pe.MiddleName,
					 Pe.FirstName,
					 G.PostOrder
		    FROM     Position P WITH (NOLOCK)INNER JOIN
		             PersonAssignment PA WITH (NOLOCK) ON P.PositionNo = PA.PositionNo INNER JOIN
		             Person Pe WITH (NOLOCK) ON PA.PersonNo = Pe.PersonNo INNER JOIN Ref_PostGrade G
				 ON G.PostGrade = P.PostGrade
		    WHERE    P.OrgUnitOperational = '#url.orgunit#' 						 
			AND      PA.Incumbency = 100 
			AND      PA.AssignmentStatus IN ('0','1')	
			
			<cfif access neq "ALL">
			<!--- person can inquire only his own --->
			AND      Pe.PersonNo = '#client.personno#'  
			</cfif>
					
			<!--- is indeed working in that period --->
			AND      PA.DateEffective  <= '#dateformat(url.selecteddate,client.dateSQL)#' 
			AND      PA.DateExpiration >= '#dateformat(url.selecteddate,client.dateSQL)#'
			ORDER BY G.PostOrder ASC		
		</cfquery>		
	
	</cfif>		

</cfif>

<!--- ------------ --->
<!--- base dataset --->
<!--- ------------ --->

<!--- make this generic and obtain this from Ref_Action based on schedule --->

<cfset wclass = "Contact">

<cfquery name="Base" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     WL.WorkOrderId, 
	           WL.WorkOrderLine, 
			   WL.WorkOrderLineId, 
			   WL.ActionStatus,
			   WL.Reference,
			   WL.DateEffective,
			   WL.ParentWorkOrderId,
			   WLA.ActionClass, 
			   WS.DescriptionShort as WorkOrderService,
			   S.Description as ServiceItemDescription,
			   
			   <!---
			   ( SELECT WorkActionId
			     FROM   WorkorderLineBillingAction
				 WHERE  WorkActionId = WLA.WorkActionId ) as hasBilling,	
			   --->
			   
			   ISNULL((	
    				
    				SELECT TOP 1 w1.WorkOrderId
				    FROM   WorkORder.dbo.WorkOrder AS W1 WITH (NOLOCK)
					       INNER JOIN 	WorkOrder.dbo.WorkOrderLineAction as wla1 WITH (NOLOCK)
					   	   LEFT OUTER JOIN WorkORder.dbo.WorkPlanDetail as wpd1 WITH (NOLOCK)
					   			ON 		wla1.WorkActionId = wpd1.WorkActionId
				    			ON 		w1.WorkOrderId = wla1.WorkOrderId
				    		AND 		wla1.ActionClass = 'Contact'
				    		AND 		wla1.ActionStatus NOT IN ('9','8') <!---not to have absences and cancelled ---->
				    WHERE 	W1.CustomerId = W.CustomerId
					
				   ORDER BY CASE
				   		WHEN WPD1.DateTimePlanning IS NOT NULL
							THEN WPD1.DateTimePlanning
				            ELSE 
								ISNULL(WLA1.DateTimePlanning, W1.OrderDate)
						END 
					ASC

				),W.WorkOrderId)firstWorkOrderID,
				
			   (
    				<!---- to point to the invoice specifically for this date 
					For : Ronmell if you do this again, please help me to understand, took me 20 mins to align this query properly
					and still not sure i this is the most effective query
					----->
    				SELECT TOP 1 WorkActionId 
					FROM   WorkORder.dbo.WorkPlanDetail WITH (NOLOCK)
					WHERE  WorkActionId IN (
								SELECT WorkActionId 
								FROM   WorkOrderLineAction WITH (NOLOCK)
								WHERE  WorkActionId in (	SELECT A.WorkActionId
														FROM   WorkOrderLineBilling AS B WITH (NOLOCK) INNER JOIN WorkOrderLineBillingAction AS A WITH (NOLOCK) 
														  ON   B.WorkOrderId = A.WorkOrderid AND B.WorkOrderLine = A.WorkOrderLine AND B.BillingEffective = A.BillingEffective
														WHERE  A.WorkOrderid = (
														         SELECT DISTINCT WorkOrderId	
														         FROM WorkORder.dbo.WorkOrderLine WITH (NOLOCK)
														         WHERE WorkORderLineID = WL.WorkOrderLineId )																 
													     AND   B.BillingExpiration IN (
														             SELECT TransactionDate
														             FROM   WorkORder.dbo.WorkOrderLineCharge WITH (NOLOCK)
														             WHERE  WorkOrderId = (
														                 SELECT DISTINCT WorkOrderId
														                 FROM   WorkOrder.dbo.WorkOrderLine WITH (NOLOCK)
														                 WHERE  WorkOrderLineId = WL.WorkOrderLineId )
														         )
														 )
						        AND     ActionClass = 'Contact')
						        AND     Operational = '1'
						        AND     DATEADD(dd, DATEDIFF(dd, 0, DateTimePlanning), 0) = DATEADD(dd, DATEDIFF(dd, 0, WP.DateEffective), 0)
				) AS hasBilling,			   
				 			 
			   ( SELECT Description 
			     FROM   Ref_PlanOrder  WITH (NOLOCK)
				 WHERE  Code        = WPD.PlanOrderCode) as PlanOrder,
				 
			  ( SELECT ListingOrder 
			     FROM   Ref_PlanOrder  WITH (NOLOCK)
				 WHERE  Code        = WPD.PlanOrderCode) as PlanSort,
				 
			   ( SELECT Color 
			     FROM   Ref_PlanOrder  WITH (NOLOCK)
				 WHERE  Code       = WPD.PlanOrderCode) as PlanColor, 
				 
			   ( SELECT count(*) 
				 FROM   CustomerPayer WITH (NOLOCK)
				 WHERE  CustomerId = W.CustomerId) as hasPayer,
				 
			   <!--- get the very first contact action of this person to compare with the action to show to determine if this is New New --->
			   
			   ISNULL(( SELECT TOP 1 wpd1.WorkActionId
        		  FROM WorkOrderLineAction CWL WITH (NOLOCK)
		  			inner join WorkOrder CW WITH (NOLOCK)
		  			ON CW.WorkOrderId = CWL.WorkOrderId
					inner join WorkPlanDetail wpd1 WITH (NOLOCK)
		  			on wpd1.WorkActionId = cwl.WorkactionId
		  			and wpd1.Operational = '1'
	   				WHERE CW.CustomerId =W.CustomerId
              			AND CWL.ActionClass = 'Contact'
              			AND CWL.ActionStatus not in ('9','8')
              			/*AND ISNULL(wpd1.DateTimePlanning,CWL.DateTimePlanning) <= ISNULL(wpd.DateTimePlanning,wla.DateTimePlanning)*/
        				/*ORDER BY CASE WHEN CWL.DateTimeActual is NULL THEN CWL.DateTimePlanning ELSE CWL.DateTimeActual END ASC*/
        			ORDER BY ISNULL(wpd1.DateTimePlanning, CWL.DateTimePlanning) ASC
				),WLA.WorkActionid) as firstWorkActionId /*to get the current one*/, 							 
				( SELECT TOP 1 R1.DescriptionShort
					        FROM WorkOrderLine wl1 WITH (NOLOCK)
					             INNER JOIN WorkORder AS wo WITH (NOLOCK) ON wo.WorkOrderId = wl1.WorkOrderId
					             INNER JOIN WorkOrderLineAction AS wla1  WITH (NOLOCK) ON wla1.WorkOrderId = wo.WorkOrderId
					                                                       AND wla1.WorkOrderLine = wl1.WorkOrderLine
					             INNER JOIN Ref_ServiceItemDomainClass R1 WITH (NOLOCK)  ON WL1.ServiceDomain = R1.ServiceDomain
                                                						 AND WL1.ServiceDomainClass = R1.Code
                                 INNER JOIN WorkOrder.dbo.WorkPlanDetail wpd1 WITH (NOLOCK) ON wpd1.WorkActionId = wla1.WorkActionId
					        WHERE wo.customerId = W.CustomerId
					              AND ActionClass = '#wclass#'
					              AND wla1.ActionStatus NOT IN ( '9','8')
					              AND wo.ActionStatus != '9'
					              AND wpd1.Operational = '1'
					              AND R1.DescriptionShort = R.DescriptionShort
					              AND wla1.WorkActionId != wla.WorkActionId
							      AND ISNULL(wpd1.DateTimePlanning,wla1.DateTimePlanning) <= ISNULL(wpd.DateTimePlanning,wla.DateTimePlanning)
					       ORDER BY ISNULL(wpd1.DateTimePlanning, wla1.DateTimePlanning) DESC
				) as lastServiceDomainClass, 
				
				
						   	
			   WLA.ActionStatus as WorkOrderLineActionStatus,
			   WL.ServiceDomainClass,
			   R.DescriptionShort as Description, 
			   R.DescriptionShort as wlservicedomainclassnow, 
			   WPD.WorkPlanId,
			   WPD.WorkPlanDetailId,
			   WPD.DateTimePlanning, 
			   WPD.LocationId,
			   L.Color as LocationColor,
			   L.LocationName,
			   WPD.Memo,
			   WP.PositionNo,
			   A.LastName, 
			   A.LastName2,
			   A.FirstName, 
			   A.MiddleName,
			   A.PersonNo, 
			   A.DocumentReference,
			   W.CustomerId,
               WLA.WorkActionId,
			   (SELECT count(*) 
			    FROM   WorkPlanDetail 
			    WHERE  WorkActionid = WPD.WorkActionId
				AND    Operational=0) as ScheduleLog
			   
			   
	FROM       WorkPlanDetail WPD  WITH (NOLOCK) LEFT OUTER JOIN
			   Location L WITH (NOLOCK) ON WPD.LocationId = L.LocationId INNER JOIN
               WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId INNER JOIN
               WorkOrderLineAction WLA WITH (NOLOCK) ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
               WorkOrderLine WL WITH (NOLOCK) ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
			   WorkOrderService WS WITH (NOLOCK) ON WS.ServiceDomain = WL.ServiceDomain AND WS.Reference = WL.Reference INNER JOIN
               Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
               WorkOrder W WITH (NOLOCK) ON WL.WorkOrderId = W.WorkOrderId AND WL.WorkOrderId = W.WorkOrderId INNER JOIN
			   ServiceItem S WITH (NOLOCK) ON W.ServiceItem = S.Code INNER JOIN
               Customer C WITH (NOLOCK) ON W.CustomerId = C.CustomerId INNER JOIN
               Applicant.dbo.Applicant A WITH (NOLOCK) ON C.PersonNo = A.PersonNo	
			   
	WHERE      <cfif url.mission neq "">
			   WP.Mission = '#url.mission#' 
			   <cfelse>
			   1=1
			   </cfif>
	<cfif url.orgunit neq "" and url.orgunit neq "0">
	AND        WP.OrgUnit = '#url.orgunit#' 
	</cfif>		
	<cfif Position.recordcount eq "0">			
	AND        1=0
	<cfelse>
	AND        WP.PositionNo    IN (#quotedValueList(Position.PositionNo)#) 
	</cfif>	
	AND        WP.DateEffective = '#dateformat(url.selecteddate,client.dateSQL)#'
	AND        WL.Operational   = 1		
	
	<!--- 30/11/2016 only the active schedules to be shown --->
	AND        WPD.Operational  = 1
	
	ORDER BY   WPD.DateTimePlanning, WL.Reference, WPD.Created 		
</cfquery>	


<cfquery name="getSchedule"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT   TOP 1 W.*		
		FROM     WorkSchedulePosition AS WSP WITH (NOLOCK) INNER JOIN
				 WorkSchedule AS W WITH (NOLOCK) ON W.Code = WSP.WorkSchedule				 
		WHERE    W.Mission = '#url.mission#'		 		
		<cfif Position.recordcount gte "1">					
		AND      WSP.PositionNo    IN (#quotedValueList(Position.PositionNo)#) 
		</cfif>	
		AND      WSP.CalendarDate = '#dateformat(url.selecteddate,client.dateSQL)#'
		AND      Operational = 1 	
									
 </cfquery>
 
<cfquery name="Schedule"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT  DISTINCT 
				WSH.CalendarHour, 
				W.HourMode,
				(SELECT ViewColor
				 FROM   Ref_WorkAction
				 WHERE  ActionClass = WSH.ActionClass) as ViewColor
		
		FROM     WorkSchedulePosition AS WSP WITH (NOLOCK) INNER JOIN
		         WorkScheduleDateHour AS WSH WITH (NOLOCK) ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
				 WorkSchedule AS W ON W.Code = WSP.WorkSchedule 
				 
		WHERE    W.Code = '#getSchedule.Code#'
		AND      WSP.CalendarDate = '#dateformat(url.selecteddate,client.dateSQL)#' 
		
		<cfif Position.recordcount eq "0">					
		AND      1=0		
		<cfelse>		
		AND      WSP.PositionNo IN (#quotedValueList(Position.PositionNo)#) 		
		</cfif>	
								
 </cfquery>
 
 <cfsavecontent variable="vTheMainContent">

	<table style="min-width:500" border="0" width="99%" height="100%">

	<tr><td valign="top" style="padding-left:6px;padding-right:6px">

	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="navigation_table">

	<tr style="height:20px">	
				
		<cfif url.size eq "small" or url.size eq "embed">
		
			<td style="padding-left:5px;height:30px;font-size:20px;" colspan="4" class="labellarge clsNoPrint">	
			
			<cfoutput>
			
			<cfif url.orgunit neq "">
			
				<cfquery name="Org" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT     *				   
					FROM       Organization
					WHERE      OrgUnit = '#url.orgunit#'			
				</cfquery>	
				
				#Org.OrgUnitName#<br>
			
			</cfif>		 

			<cf_tl id="#dateformat(url.selecteddate,'MMMM')#" var="lblMonthTitle">
			<cf_tl id="#dateformat(url.selecteddate,'DDDD')#" var="lblDayTitle">			
			<font size="2">#lblDayTitle# #lblMonthTitle# #dateformat(url.selecteddate,"DD")#
			
			</cfoutput>
			
		<cfelse>
		
		   <td colspan="4" class="clsNoPrint">	
		  		   
			<cfoutput>
			
			<table border="0" style="height:40px">
			<tr class="line">
			
			<cfset dtep = dateAdd("d","-1",url.selecteddate)>		
			<cfset dten = dateAdd("d","+1",url.selecteddate)>
						
			<td align="right" style="cursor:pointer;" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';calendardetail('#dateformat(dtep,client.DateSQL)#','wide')">
			   <img src="#session.root#/images/Scroll-Left.png" width="36" height="36">
		    </td>	
						
		    <cf_tl id="Refresh" var="1">	
			<td align="center" 
				title="#lt_text#" 
				style="width:350px;padding-left:8px;padding-right:8px;cursor:pointer" 
				class="clsNoPrint" 
				onclick="Prosis.busy('yes'); _cf_loadingtexthtml='';calendardetail('#dateformat(url.selecteddate,client.DateSQL)#','wide')">
            <h style="font-weight:normal;font-size:25px;padding-top:16px;color:gray">		
			#dateformat(url.selecteddate,"DDDD, MMMM DD")# #dateformat(url.selecteddate,"YYYY")#
			</h3>
			
			</td>
						
			<td align="center" style="cursor:pointer;" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';calendardetail('#dateformat(dten,client.DateSQL)#','wide')">			
				<img src="#session.root#/images/Scroll-Right.png" width="36" height="36">
			</td>
						
			<td style="padding-left:10px;font-size:30px" class="clsNoPrint">
			
			<cfif url.orgunit neq "">
			
				<cfquery name="Org" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT     *				   
				FROM       Organization
				WHERE      OrgUnit = '#url.orgunit#'			
				</cfquery>	
			
                <h style="color:gray;font-weight:normal;font-size:25px;padding-top:16px">#Org.OrgUnitName#</h3>
			
			</cfif>
			
			</td>
			</tr>
			</table>
			
			</cfoutput>
			
		</cfif>	
		</td>		

		<cfoutput>
		
			<cfif url.size neq "embed">		
		
			<td align="right" class="clsNoPrint">
				
			    <table>
				<tr>
				
					<cfif url.size eq "small">
				
				    <td style="font-size:18px;padding-bottom:3px;height:20px;" class="labelmedium">		
						<table width="100%">
						<tr>		
						<cfoutput>			
						<td align="center" style="padding-left:3px;padding-right:5px;cursor:pointer" class="clsNoPrint">						
						 <cf_tl id="Add contact" var="lbl">		
						 <input style="width:120;height:24px" type="button" value="#lbl#" class="button10g" onclick="addworkplan('#org.mission#','#url.orgunit#','#url.personno#','#dateformat(url.selecteddate,client.dateFormatShow)#')" >				
						</td>	
						</cfoutput>			
						</tr>
						</table>		
					</td>	
					
					</cfif>
						
					<td>
											
												
						<cfset vPositionsArray = "[]">							
						<cfif Position.recordcount gt 0>			
							<cfset vPositionsArray = "[#quotedValueList(Position.PositionNo)#]">
						</cfif>	
						
						<cf_tl id="Print" var="1">
						
						<cf_button2 
							mode		= "icon"
							type		= "button"
							image		= "print_gray.png"
							title       = "#lt_text#" 
							id          = "Print"					
							height		= "40px"
							width		= "36px"
							onclick		= "showPrintableAgenda('#url.mission#', '#url.orgunit#', '#getSchedule.Code#', '#dateformat(url.selecteddate,client.dateSQL)#', #vPositionsArray#);">
					</td>
					
					<td style="padding-left:7px">
																		
						<cf_button2 
							mode		= "icon"
							height		= "32px"
							width		= "32px"
							image		= "maximize.png"
							id          = "ToggleCalendar"
							onclick		= "Prosis.busy('yes');toggleCalendar('#dateformat(url.selecteddate,client.dateSQL)#');">
					</td>
				</tr>
			</table>
				
			</td>	
			
			</cfif>
			
			<input type="hidden" id="currentdate" value="#dateformat(url.selecteddate,client.dateformatshow)#">
		
		</cfoutput>

	</tr>    
		 
	<tr><td id="process" class="hide"></td></tr>

	<!--- --------------------- --->
	<!--- filtering for patient --->
	<!--- --------------------- --->

	<cfif url.size neq "small" and url.size neq "embed">
												
		<tr class="labelmedium">								
		<td colspan="5" style="height:40px;padding-left:10px">
		
			<table width="100%">
			<tr>
			<td style="width:90" class="labelmedium">
			<cf_tl id="Patient">
			</td>
			<td style="padding-left:3px">		
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "direct"
				   name             = "filtersearch"
				   label            = ""
				   style            = "font:14px;height:25;width:120"
				   rowclass         = "clsPatientRow"
				   rowfields        = "ccontent">		   
				   </td>
				   		   			   
				<cfoutput>		
				<td align="right" style="padding-left:3px;padding-right:22px;cursor:pointer" class="clsNoPrint">								
				<cf_tl id="Add contact" var="lbl">		
				<input style="width:180;height:27px" type="button" value="#lbl#" class="button10g" onclick="addworkplan('#org.mission#','#url.orgunit#','#url.personno#','#dateformat(url.selecteddate,client.dateFormatShow)#')" >						
				</td>			
				</cfoutput>		   
		   </tr>
		   </table>		
		
		</td>							
		</tr>	
											
	</cfif>

	<!--- showing the content --->
		
	<tr><td colspan="5" height="100%" valign="top" style="padding-right:2px">
			
		<form name="agenda" id="agenda" style="height:100%">  

			<cf_divScroll id="mainAgendaListing">
											
			<table width="99%" border="0" cellspacing="0" cellpadding="0" class="clsPrintContent navigation_table">
			
				<cfif url.size eq "small" or 
				      url.size eq "embed" or  
				      url.matrix eq "No" or 
					  Position.recordcount eq "1">		
					 									  				  
					  	<cfset url.matrix = "No">
		
							<cfloop query="Position">			
												
								   <!--- ensure a workplan exists --->
																												
								  <cfinvoke component = "Service.Process.WorkOrder.Workplan"  
								     method           = "addWorkPlan" 
		  						     mission          = "#url.mission#" 
								     orgunit          = "#orgunitoperational#" 
								     positionno       = "#positionno#"
								     personno         = "#personno#"
								     dateeffective    = "#url.selecteddate#"
								     returnvariable   = "workplanid">	   													
							
									<cfoutput>																											
									
									 <cfif url.size neq "small">	
										 <tr class="labelmedium">								
									     <td colspan="5" style="font-size:25px;height:50px;padding-left:5px;"><font color="0080C0">#LastName#,#FirstName#</td>									
										 </tr>
									 <cfelseif url.size eq "embed">	
										 <tr class="labelmedium">								
									     <td colspan="5" style="font-size:25px;height:50px;padding-left:5px;"><font color="0080C0">#LastName#,#FirstName#</td>									
										 </tr>	 
									 <cfelse>
										 <cfif Position.recordcount gte "2">
										 <tr class="labelmedium">
										 <td colspan="5" style="font-size:17px;height:32px;padding-left:5px;"><font color="0080C0">#LastName#,#FirstName#</td>
										 </tr>
										 </cfif>
									 </cfif>									
									
									</cfoutput>
															
									<cfset row = 1>
																	
									<cfloop query="Schedule">
												
										<cfoutput>	
										
										<cfset dte = dateadd("h",CalendarHour,url.selecteddate)>				
										<cfset part = CalendarHour-int(CalendarHour)>
										<cfset partVal = INT(part*100)>
										<cfset hr = int(CalendarHour)>
										
										<cfswitch expression="#partVal#">				
										<cfcase value="0">
											<cfset min = "0">					
										</cfcase>
										<cfcase value="25">
										    <cfset min = "15">
										</cfcase>
										<cfcase value="33">
										    <cfset min = "20">
										</cfcase>
										<cfcase value="50">
											<cfset min = "30">
										</cfcase>
										<cfcase value="66">
										    <cfset min = "40">
										</cfcase>
										<cfcase value="75">
											<cfset min = "45">
										</cfcase>				
										</cfswitch>																
										
										<cfif url.workactionid neq "">
											<cfset link = "if (document.getElementById('workactionid')) { Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/WorkPlan/setSchedule.cfm?workschedule=#getSchedule.code#&matrix=no&size=#url.size#&mode=medical&workactionid=#url.workactionid#&selecteddate=#URLencodedformat(url.selecteddate)#&mission=#url.mission#&orgunit=#url.orgunit#&positionno=#position.positionno#&personno=#position.personno#&hour=#hr#&minute=#min#','calendartarget','','','POST','scheduleform')}">
										<cfelse>
											<cfset link = "">
										</cfif>								  								
										<tr>		
														
										<td valign="top"
										    class="line labelmedium clsHour_#hr#_#min#"
											style="font-size:30px;cursor:pointer;height:12px;padding-left:1px;padding-right:1px"
											onClick="#link#" onMouseOver="this.bgColor='Yellow'" onMouseOut="this.bgColor='EfEfEf'">																														
											
											<cfinclude template="ShowSchedule.cfm">											
																																																							
										</td>
										
										</cfoutput>		
																																				
												<cfquery name="Summary" dbtype="query">
													SELECT   *
													FROM     Base
													WHERE    PositionNo = #Position.PositionNo#
													AND      DateTimePlanning >= #dte# 
													AND      DateTimePlanning < #vNextInitHour#		
													ORDER BY PlanSort								 
												</cfquery>	
																																
												<cfif summary.PositionNo neq "">															
												
													<td height="100%" style="padding:0px" colspan="4" class="line">															
														<table width="100%" height="100%" style="border:2px solid white" cellspacing="0" cellpadding="0">																									
															<cfoutput query="Summary">																													
																<cfinclude template="ActivityListDetail.cfm">				
															</cfoutput>													
														</table>																		
													</td>
												
												<cfelse>	
																																				
													<!--- create entries --->
													<cfinvoke component = "Service.Process.WorkOrder.Workplan"  
													   method           = "addWorkPlanDetail" 
													   workplanid       = "#workplanid#" 
													   Planorder        = "1"
													   PlanOrderCode    = ""
													   WorkSchedule     = "#getSchedule.Code#"
													   OrgUnitOwner     = "#position.orgunitoperational#"
													   WorkActionId     = ""
													   LocationId       = ""  		
													   DateTimePlanning = "#dte#"					   
													   returnvariable   = "workplandetail">	 		
													   																																		
													 <cfoutput>		
													
													 
													 <td onMouseOver="this.bgColor='cacaca'" onMouseOut="this.bgColor='EfEfEf'" bgcolor="EfEfEf" 
														  colspan="4" style="width:100%;border-top:solid silver 1px;border-right:none;height:23px;padding-right:6px;padding-left:40px;cursor:pointer">
														 
														  <table height="100%" width="100%" border="0">
														     <tr class="labelit">
															 <td onclick="#link#" style="min-width:19px;padding-left:1px"></td>
															 <td style="width:100%;border:0px">															 											 
															 <cfif url.size eq "Small" or url.size eq "Embed">													 
															 	#workplandetail.memo#														
															 <cfelse>			
															 						 											 														 																									 
															  <input type="text" 
															    name="Memo_#left(workplandetail.WorkPlanDetailId,8)#" 
															    value="#workplandetail.Memo#" 
																onchange="ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/setScheduleMemo.cfm?id=#workplandetail.WorkPlanDetailId#','process','','','POST','agenda')"
																style="height:23px;background-color:DEF8EF;border:0px;border-left:1px solid silver;border-right:1px solid silver;width:100%" 
																class="regularxl enterastab">												 
																
															 </cfif>													 
															 </td>
															 </tr>
															 </table>												 
														  										
													 </td>	
													 </cfoutput>	
												</cfif>					
										</tr>										
									</cfloop>										
								</td>
							</tr>
						</cfloop>					
					
					<cfelse>
					
						<cfset url.matrix = "Yes">					
													
						<tr class="labelmedium line" style="height:20px;border-top:1px solid silver">
						
							<td align="center" style="border-right:1px solid silver;height:38px;font-size:16px"><cf_tl id="Time"></td>
							
							<cfoutput query="Position">
								<td align="center" style="padding-left:4px;padding-right:4px;border-right:1px solid silver;height:38px;font-size:22px">#LastName#</td>
							</cfoutput>														
							
						</tr>
																												
							<cfset row = 1>
																
							<cfloop query="Schedule">
														
								<cfset dte = dateadd("h",CalendarHour,url.selecteddate)>				
								<cfset part = CalendarHour-int(CalendarHour)>
								<cfset partVal = INT(part*100)>
								<cfset hr = int(CalendarHour)>		
								
								<cfswitch expression="#partVal#">				
									<cfcase value="0">
										<cfset min = "0">					
									</cfcase>
									<cfcase value="25">
									    <cfset min = "15">
									</cfcase>
									<cfcase value="33">
									    <cfset min = "20">
									</cfcase>
									<cfcase value="50">
										<cfset min = "30">
									</cfcase>
									<cfcase value="66">
									    <cfset min = "40">
									</cfcase>
									<cfcase value="75">
										<cfset min = "45">
									</cfcase>				
								</cfswitch>						
																												  								
								<tr class="line">
															
									<td valign="top" align="right" 
									onMouseOver="this.bgColor='Yellow'" onMouseOut="this.bgColor='EfEfEf'"
									class="line labelmedium" style="height:12px;width:60px;padding-left:6px;padding-right:0px">									
									
									<cfinclude template="ShowSchedule.cfm">
									
									</td>							
																																					
									<cfloop query="position">
									
										<!--- ensure a workplan exists --->
																																					
										<cfinvoke component = "Service.Process.WorkOrder.Workplan"  
										   method           = "addWorkPlan" 
										   mission          = "#url.mission#" 
										   orgunit          = "#url.orgunit#" 
										   positionno       = "#positionno#"
										   personno         = "#personno#"
										   dateeffective    = "#url.selecteddate#"
										   returnvariable   = "workplanid">
																				
																		
										<cfif url.workactionid neq "">
											<cfset link = "if (document.getElementById('workactionids')) { Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/WorkPlan/setSchedule.cfm?workschedule=#getSchedule.code#&matrix=yes&size=#url.size#&mode=medical&workactionid=#url.workactionid#&selecteddate=#URLencodedformat(url.selecteddate)#&mission=#url.mission#&orgunit=#url.orgunit#&positionno=#positionno#&personno=#personno#&hour=#hr#&minute=#min#','calendartarget','','','POST','scheduleform')}">
										<cfelse>
											<cfset link = "">
										</cfif>
																				
										<cfset wid = "#93/position.recordcount#">	
										
										<cfquery name="Summary" dbtype="query">
												SELECT *
												FROM   Base
												WHERE  PositionNo = #positionno#
												AND    DateTimePlanning >= #dte# 
												AND    DateTimePlanning < #vNextInitHour#
												ORDER BY PlanSort
											</cfquery>		
																					
										<cfif summary.PositionNo neq "">		
																			
											<td style="border-right:1px solid silver" valign="top" 
											 width="<cfoutput>#wid#%</cfoutput>">	
											 																																																																					
												<table width="100%" height="100%">	
																			 
													<cfoutput query="Summary">																
														<cfinclude template="ActivityListDetail.cfm">				
													</cfoutput>																							
												
												</table>		
											</td>	
										
										<cfelse>
										
											<cfinvoke component = "Service.Process.WorkOrder.Workplan"  
											   method           = "addWorkPlanDetail" 
											   workplanid       = "#workplanid#" 
											   Planorder        = "1"
											   PlanOrderCode    = ""
											   WorkSchedule     = "#getSchedule.Code#"
											   OrgUnitOwner     = "#url.orgunit#"
											   WorkActionId     = ""
											   LocationId       = ""  
											   DateTimePlanning = "#dte#"							   
											   returnvariable   = "workplandetail">	 
										
											<cfoutput>									
																					
											 <td width="<cfoutput>#wid#%</cfoutput>" valign="top" 
											     onMouseOver="this.bgColor='cacaca'" onMouseOut="this.bgColor='EfEfEf'"								 
											     bgcolor="efefef">	
												 
												 <table height="100%" width="100%">
												 <tr class="labelit">
												 <td onclick="#link#" style="min-width:62px"></td>
												 <td style="width:99%;height:40px">													 
																	 											 
												 <input type="text" name="Memo_#left(workplandetail.WorkPlanDetailId,8)#" value="#workplandetail.Memo#" 
						onchange="ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/setScheduleMemo.cfm?id=#workplandetail.WorkPlanDetailId#','process','','','POST','agenda')"
						style="width:100%;border:0px;height:40px" class="amemo regularxl enterastab">	
											
												 </td></tr></table>												 
											 </td>		
											 
											 </cfoutput>										
										
										</cfif>													
										
									</cfloop>
																
								</tr>										
							
							</cfloop>		
							
										
					</cfif>			
			</table>
			</cf_divScroll>
		</form>		
	</td>
	</tr>

	<!--- ------------------------- --->
	<!--- -------inputting--------- --->
	<!--- ------------------------- --->
					
	<cfif url.workactionid neq "">

	    <cfquery name="Found" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT     *				   
			FROM       WorkPlanDetail WITH (NOLOCK)
			WHERE      WorkActionId = '#url.workactionid#'		
			AND        Operational = 1   	
		</cfquery>	
			
		<cfif found.recordcount gte "0">
		
			<tr><td style="height:5px"></td></tr>
			
			<cfoutput>
				<input type="hidden" id="workactionid" value="#url.workactionid#">
			</cfoutput>	
			
			 <cfquery name="get" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   C.CustomerName, C.PersonNo, W.ServiceItem
				FROM     WorkOrderLineAction WLA WITH (NOLOCK) INNER JOIN
		                 WorkOrder W WITH (NOLOCK) ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
		                 Customer C WITH (NOLOCK)  ON W.CustomerId = C.CustomerId 
				WHERE    WorkActionId = '#url.workactionid#'	
			</cfquery>	

			<tr>
			<td colspan="5" style="background-color:eaeaea;padding-bottom:3px;padding-top:2px;border:1px solid gray">
			<table width="100%">
				<tr class="labelmedium" style="height:18px">
					<td style="padding-left:4px"><cfoutput>#get.Customername#</cfoutput></td>
					<td align="right" style="padding-right:4px">
					<cfoutput>
					<!--- onclick="$('##currentcustomer').html('');" --->
					<img src="#session.root#/images/close.png" 
					   onclick="ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/resetCustomer.cfm','currentcustomer')"
					   alt="" width="22" height="22" border="0">
					</cfoutput>
					</td>
				</tr>
			</table>
			</td></tr>
			
			<tr>
			<td id="currentcustomer" colspan="5" style="padding-top:10px;padding-left:10px;border:1px solid gray">
			
				<form name="scheduleform" id="scheduleform">
			
					<table style="height:100%">
					
					<cfoutput>
						<input type="hidden" id="workactionid" value="#url.workactionid#">
					</cfoutput>										
											
						<cfif url.positionno neq "">
						
						<td>
																	
							<cfquery name="getHour"
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
									SELECT   MIN(W.HourMode) as HourMode,
									         MIN(WSH.CalendarHour) as MinHour, MAX(WSH.CalendarHour) as MaxHour
									FROM     WorkSchedulePosition AS WSP WITH (NOLOCK) INNER JOIN
									         WorkScheduleDateHour AS WSH WITH (NOLOCK) ON WSP.WorkSchedule = WSH.WorkSchedule AND WSP.CalendarDate = WSH.CalendarDate INNER JOIN
											 WorkSchedule AS W ON W.Code = WSP.WorkSchedule
									WHERE    WSP.CalendarDate = '#dateformat(url.selecteddate,client.dateSQL)#' 
									AND      WSP.PositionNo   = '#positionno#'

							</cfquery>

							<cfset jumpMinutes = 1>
							<cfif getHour.recordCount gt 0>
								<cfif trim(getHour.HourMode) neq "">
									<cfset jumpMinutes = getHour.HourMode>
								</cfif>
							</cfif>

							<cfset vMinHour = 0>
							<cfif getHour.recordCount gt 0>
								<cfif trim(getHour.MinHour) neq "">
									<cfset vMinHour = INT(getHour.MinHour)>
								</cfif>
							</cfif>

							<cfset vMaxHour = 23>
							<cfif getHour.recordCount gt 0>
								<cfif trim(getHour.MaxHour) neq "">
									<cfset vMaxHour = INT(getHour.MaxHour)>
								</cfif>
							</cfif>
						   
						   	<cf_setCalendarDate name="DateTimePlanning" 
						       class        = "regularxl" 
							   valuecontent = "datetime" 
							   future       = "Yes" 						   
							   minHour      = "#vMinHour#"
							   maxHour      = "#vMaxHour#"
							   jumpMinutes  = "#jumpMinutes#"
							   value        = "#Dateformat(url.selecteddate, CLIENT.DateFormatShow)# 08:30" 
							   mode         = "time">			

							<!--- ----------------------------------------------------- --->		 							 
							
						</td>	
						
						</cfif>
						
						<td style="padding-left:4px">
						
							<cfquery name="PlanOrderList"
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT     *
								FROM       Ref_PlanOrder
								ORDER BY   ListingOrder
							</cfquery>	
							
													
							<select name="PlanOrderCode" class="regularxl" style="height:27px">
								<cfoutput query="PlanOrderList">
								<option value="#Code#" <cfif found.PlanOrderCode eq Code>selected</cfif>>#Description#</option>
								</cfoutput>					
							</select>					
						
						</td>
						
						<td style="padding-left:4px">
						
							<cfquery name="LocationList"
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT     *
								FROM       Location
								WHERE      Mission = '#url.mission#'
								AND        LocationId IN (SELECT LocationId FROM LocationServiceItem WHERE ServiceItem = '#get.ServiceItem#')
								ORDER BY   ListingOrder
							</cfquery>	
							
							<cfif LocationList.recordcount eq "0">
							
								<cfquery name="LocationList"
									datasource="AppsWorkOrder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT     *
									FROM       Location
									WHERE      Mission = '#url.mission#'								
									ORDER BY   ListingOrder
								</cfquery>	
							
							</cfif>							
													
							<select name="LocationId" class="regularxl" style="height:27px">
								<cfoutput query="LocationList">
								<option value="#LocationId#" <cfif found.LocationId eq LocationId>selected</cfif>>#LocationName#</option>
								</cfoutput>					
							</select>					
													
						</td>
						
						<cfif url.positionno neq "">
						
						<td style="padding-left:4px" id="schedule">	
						    
							<cfoutput>															
							
							<cf_tl id="Save" var="1">
							<input type="button" style="width:80px;height:27px"
							   onclick="_cf_loadingtexthtml='';	ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/WorkPlan/setSchedule.cfm?workschedule=#getSchedule.code#&size=#url.size#&mode=medical&workactionid=#url.workactionid#&selecteddate=#URLencodedformat(url.selecteddate)#&mission=#url.mission#&orgunit=#url.orgunit#&positionno=#url.positionno#&personno=#url.personno#','calendartarget','','','POST','scheduleform')" name="Save" class="button10g" value="#lt_text#">	
							   
							</cfoutput>
							
						</td>	
						
						</cfif>
						
					</tr>
					</table>		
				
				</form>				 	
			
			</td></tr>
			
		</cfif>	

	</cfif>

	</table>

	</td></tr>
	</table>

	<!--- ------------------------------  added 20/1/2017 --------------------------------- --->
	<!--- this code will refresh the selector of the specialists based on the selected date --->
	
	<cfif url.size neq "Embed">

		<cfoutput>
		<cfset dte = dateformat(url.selecteddate,client.dateformatshow)>
		<script>
			_cf_loadingtexthtml='';
			ColdFusion.navigate('#session.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Agenda/ActivitySelectPerson.cfm?mission=#url.mission#&orgunit='+document.getElementById('orgunitimplementer').value+'&selecteddate=#dte#&positionno=#url.positionno#','unitcontent')
			Prosis.busy('no')
		</script>
		</cfoutput>
	
	</cfif>
	

	<!--- --------------------------------------------------------------------------------- --->

	<cfset ajaxonload("doHighlight")>

</cfsavecontent>

<!--- reducing output --->
<cfset vTheMainContent = replace(vTheMainContent,"	","","ALL")>
<cfset vTheMainContent = replace(vTheMainContent,"#chr(13)#","","ALL")>
<cfset vTheMainContent = replace(vTheMainContent,"&nbsp;","","ALL")>

<!--- displaying output --->
<cfoutput>
	#vTheMainContent#
</cfoutput>

<cfif trim(url.hour) neq "" AND trim(url.minute) neq "">
	<cfset ajaxOnLoad("function() { scrollToHour('#url.hour#','#url.minute#'); }")>
</cfif>

