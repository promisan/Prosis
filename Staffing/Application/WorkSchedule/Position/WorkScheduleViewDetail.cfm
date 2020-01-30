
<!--- show schedules --->

<cfparam name="url.action" default="">

<cfquery name="Position" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * FROM Position WHERE PositionNo = '#url.positionno#'		 
</cfquery>

<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRPosition'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessPosition">	

<cf_verifyOperational 
         module="WorkOrder" 
		 Warning="No">		
		 
<cfset go = "1">			 
		 
<cfif url.action eq "remove" or url.action eq "removeall">

	<cfif Operational eq "1">
	
		<cfquery name="PositionUsedInSchedule" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     WorkOrder.dbo.WorkOrderLineSchedulePosition WLSP INNER JOIN
	                 WorkOrder.dbo.WorkOrderLineSchedule WLS ON WLSP.ScheduleId = WLS.ScheduleId INNER JOIN
	                 WorkOrder.dbo.WorkOrderLine WL ON WLS.WorkOrderId = WL.WorkOrderId AND WLS.WorkOrderLine = WL.WorkOrderLine
					 
			WHERE    WLSP.PersonNo IN (SELECT     PersonNo
									   FROM       PersonAssignment
									   WHERE      PositionNo = '#url.positionNo#' 
									   AND        AssignmentStatus IN ('0', '1') 
									   AND        DateEffective <= #url.selecteddate# 
									   AND        DateExpiration >= #url.selecteddate#)
			
			
			AND      WLSP.isActor = '2' <!--- is actor --->

			AND 	 WLS.ActionStatus != '9'
					
			AND      WLS.WorkSchedule = '#url.workschedule#' <!--- for this schedule --->
			
			AND      WLS.ScheduleEffective <= #url.selecteddate# AND WLS.ActionStatus <> '0'  <!--- schedule is valid --->
			
			AND      WL.Operational = 1 AND  WL.DateEffective <= #url.selecteddate# AND (WL.DateExpiration IS NULL OR WL.DateExpiration >= #url.selecteddate#) <!--- line is operational --->		
						
		</cfquery>
				
		<cfif PositionUsedInSchedule.recordcount gte "1">
		
			<cfset go = "0">
		
		</cfif>
				
	</cfif>

</cfif>		 


<table width="97%" align="center">
	
<cfif go eq "0">

	<tr><td colspan="6" style="height:30" class="labelit" align="center"><font color="FF0000">Schedule may not be removed as the current incumbent is assigned as a RESPONSIBLE for one or more ongoing activities.</font></td></tr>	

<cfelse>		

	<cfif url.action eq "remove">	
	
		<cfquery name="PositionSchedule" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE  FROM WorkSchedulePosition 
			  WHERE   PositionNo   = '#url.positionNo#' 
			  AND     WorkSchedule = '#url.workschedule#'
			  AND     CalendarDate = #url.selecteddate#
		</cfquery>
		
		<!--- refreshing --->
		<cfloop index="d" from="#day(url.selecteddate)#" to="#day(url.selecteddate)#">
			<cfset vDate = createDate(year(url.selectedDate),month(url.selectedDate),d)>
			<cfoutput>
				<script>
				    _cf_loadingtexthtml="";	
					calendarrefreshonly('#d#','#urlencodedformat(vDate)#');
				</script>
			</cfoutput>
		</cfloop>	
	
	<cfelseif url.action eq "removeall">
	
		<cfquery name="PositionSchedule" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  DELETE  FROM WorkSchedulePosition 
			  WHERE   PositionNo  = '#url.positionNo#' 
			  AND     WorkSchedule = '#url.workschedule#'
			  AND     CalendarDate >= #url.selecteddate#
		</cfquery>
			
		<!--- refreshing --->
		<cfloop index="d" from="#day(url.selecteddate)#" to="#daysInMonth(url.selectedDate)#">
			<cfset vDate = createDate(year(url.selectedDate),month(url.selectedDate),d)>
			<cfoutput>
				<script>
				    _cf_loadingtexthtml="";	
					calendarrefreshonly('#d#','#urlencodedformat(vDate)#');
				</script>
			</cfoutput>
		</cfloop>
		
	<cfelseif url.action eq "add">	
	
			<!--- adding positions --->
			<cfquery name  = "clearPosition" 
		    	datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">    
				DELETE FROM   WorkSchedulePosition
			    WHERE         WorkSchedule  = '#url.workschedule#'		
				AND           PositionNo    = '#url.positionNo#' 			  
				AND           CalendarDate >= #url.selectedDate#
			</cfquery>
			
			<cfloop index="date" from="#url.selectedDate#" to="#Position.DateExpiration#">
											
					<!--- adding positions --->
					
					<cfquery name  = "checkdate" 
				    	datasource= "AppsEmployee" 
					    username  = "#SESSION.login#" 
						password  = "#SESSION.dbpw#">    
						SELECT      * 
						FROM        WorkScheduleDate
					    WHERE       WorkSchedule  = '#url.workschedule#'					  
						AND         CalendarDate  = '#dateFormat(date,client.dateSQL)#'
					</cfquery>		
					
					<cfif checkdate.recordcount eq "1">
						
						<cfquery name  = "add" 
					    	datasource= "AppsEmployee" 
						    username  = "#SESSION.login#" 
							password  = "#SESSION.dbpw#">    
							INSERT INTO WorkSchedulePosition
								    (WorkSchedule,
									 CalendarDate,
									 PositionNo,
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
							VALUES ('#url.workschedule#',
							        '#dateFormat(date,client.dateSQL)#',
									'#url.positionno#',
									'#session.acc#',
									'#session.last#',
									'#session.first#')					
						 </cfquery>	
					
					</cfif>
	
			</cfloop>	
			
			<!--- refreshing --->
			<cfloop index="d" from="#day(url.selecteddate)#" to="#daysInMonth(url.selectedDate)#">
				<cfset vDate = createDate(year(url.selectedDate),month(url.selectedDate),d)>
				<cfoutput>
					<script>
					    _cf_loadingtexthtml="";	
						calendarrefreshonly('#d#','#urlencodedformat(vDate)#');
					</script>
				</cfoutput>
			</cfloop>
					
	</cfif>
	
</cfif>	

<cfquery name="PositionSchedule" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT  DISTINCT WS.Code, WS.Description, WS.HourMode, WSP.OfficerUserId, WSP.OfficerLastName, WSP.OfficerFirstName, WSP.Created
	   FROM    WorkSchedulePosition WSP INNER JOIN WorkSchedule WS ON WSP.WorkSchedule = WS.Code
	   WHERE   WSP.PositionNo  = '#url.positionNo#' 
	   AND     WSP.CalendarDate = #url.selecteddate#
</cfquery>

<tr><td height="4"></td></tr>	
<tr class="linedotted labelmedium">
	<td><cf_tl id="Code"></td>
	<td>Description</td>
	<td>Mode</td>
	<td>Officer</td>
	<td>Recorded</td>
	<td></td>
</tr>

<cfoutput query="PositionSchedule">

	<tr class="labelmedium linedotted">
		<td>#Code#</td>
		<td>#Description#</td>
		<td>#HourMode#</td>
		<td>#OfficerLastName#</td>
		<td>#dateformat(created, client.dateformatshow)#</td>	
		<td align="right">
			<table cellspacing="0" cellpadding="0">
				<tr>
				<td>
				
				<cfif accessPosition eq "EDIT" or accessPosition eq "ALL">
																
					<cf_img icon="delete" tooltip="Remove position from schedule for this date only." 
					 onclick="javascript:workscheduleaction('remove','#code#','#positionno#','#urlencodedformat(url.selecteddate)#','Remove this schedule for this date only')">
				</td>
				<td style="padding-left:7px">
					<img style="cursor:pointer" title="Remove position from schedule for this date onwards" src="#session.root#/images/delete_all.gif" border="0"  
					 onclick="workscheduleaction('removeall','#code#','#positionno#','#urlencodedformat(url.selecteddate)#','remove this schedule as of this date')">
				</td>
				
				<cf_verifyOperational module="WorkOrder">
							
				<cfif Operational eq "1">
				
				
				<td style="padding-left:7px">
				
					<img style="cursor:pointer; height:15px;" title="Replace this schedule" src="#session.root#/images/refresh_gray.png" border="0" 
					  onclick="replaceWorkSchedule('#code#', '#positionNo#', '#Position.PositionParentId#');">
					  
				</td>
				
				</cfif>
				
				<td style="padding-left:7px">
				
				</cfif>
				
				</td>				
				</tr>
			</table>
		</td>
	</tr>
		
</cfoutput>

<cfif accessPosition eq "EDIT" or accessPosition eq "ALL">
		
	 <cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT * FROM Organization WHERE OrgUnit = '#Position.OrgUnitOperational#'		 
	 </cfquery>
	 
	  <cfset accessList = "'#Position.OrgUnitOperational#'">

	  <cfset Parent = Check.ParentOrgUnit>
	  
	  <cfloop condition="Parent neq ''">
					      	  
		   <cfquery name="LevelUp" 
			datasource="AppsOrganization" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		          SELECT OrgUnit, ParentOrgUnit 
		          FROM   Organization
		          WHERE  OrgUnitCode = '#Parent#'
				  AND    Mission     = '#Position.Mission#'
				  AND    MandateNo   = '#Position.MandateNo#' 
	  	   </cfquery>				
						
		   <cfif LevelUp.recordcount eq "1">
		   
		   	   <cfif accessList eq "">
					<cfset accessList = "'#LevelUp.OrgUnit#'">
			   <cfelse>
			        <cfset accessList = "#accessList#,'#LevelUp.OrgUnit#'">
			   </cfif>
		       		
			</cfif>
		     
		   <cfset Parent = LevelUp.ParentOrgUnit>
	   
	</cfloop>

	<cfquery name="Schedule" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT * 
		  
		  FROM   WorkSchedule
		  WHERE  Operational = 1
		  AND    Code IN     (
		                       SELECT WorkSchedule 
		                       FROM   WorkScheduleOrganization 
						       WHERE  OrgUnit IN (#preservesingleQuotes(accesslist)#)
							  )
						  
		  AND    Code NOT IN ( 
		  					   SELECT WorkSchedule
		                       FROM   WorkSchedulePosition 
							   WHERE  PositionNo   = '#url.positionNo#' 							
							   AND    CalendarDate >= #url.selecteddate#  
							  )				  
		  
	</cfquery>
		
	<cfif schedule.recordcount eq "0">
	
	<!---
	<tr><td colspan="6" style="padding-top:10px" align="center" class="labelmedium">
	   <font color="FF0000">Position not associated to a unit which is enabled for a workschedule</td>
     </tr>		
	 --->
	
	<cfelse>
	
	<cfoutput>

	<tr><td colspan="6" style="padding-top:10px">
	
		<table>
		<tr>
		
			<td style="padding-left:10px">
					
				<select id="workscheduleselect" class="regularxl">
					<cfloop query="schedule">
					<option value="#Code#">#Description#</option>
					</cfloop>		
				</select>
				
			</td>
			
			<td style="padding-left:10px">
				
				<input type="button" 
				     name="Add" 
					 value="Add this schedule" 
					 style="width:130;height:25"
					 onClick="javascript:workscheduleaction('add',document.getElementById('workscheduleselect').value,'#positionno#','#urlencodedformat(url.selecteddate)#','add this schedule as of this date')">
			
			</td>
		
		</tr>
		
		</table>
	
	</td>
	</tr>
	
	<tr><td colspan="6" class="linedotted"></td></tr>
	
	</cfoutput>	
	
	</cfif>
	
</cfif>	

</table>
