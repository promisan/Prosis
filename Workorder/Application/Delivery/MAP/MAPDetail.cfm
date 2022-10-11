
<!--- drill down feature from the map click --->

<cfparam name="url.mode" default="standard">

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>

<cfif isValid("guid",url.cfmapname)>

<cfquery name="Customer"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
			SELECT   TOP 1 
					 W.WorkOrderId,
					 W.ServiceItem,
					 WL.WorkOrderLine,
					 C.PostalCode,
					 C.Address,
					 C.City,
					 C.MobileNumber,
					 C.PhoneNumber,
			         C.CustomerName,		
			         A.DateTimePlanning, 	
			         A.DateTimeActual,			         
					 PL.PersonNo,      
			         PL.LastName, 
					 PL.Description as Schedule, 				 
					 1 as Planned,
					 (CASE WHEN A.DateTimeActual is NULL THEN 0 ELSE 1 END) as Actual
					 
		    FROM     WorkOrder AS W INNER JOIN
	                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN  
					 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine INNER JOIN 
					 Customer as C ON W.CustomerId = C.CustomerId  LEFT OUTER JOIN 
					 
					 <!--- check if planned for today --->
					 (
				 
					    SELECT  W.WorkPlanId, 
						        D.PlanOrder, 
								D.PlanOrderCode, 
								R.Description, 
								W.PersonNo, 
								P.LastName, 
								P.FirstName, 
								D.DateTimePlanning, 
								D.WorkActionId
					    FROM    WorkPlan AS W INNER JOIN
	                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
	                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN
								Ref_PlanOrder R ON R.Code = D.PlanOrderCode
						WHERE   W.Mission = '#url.mission#' 
						AND     W.DateEffective  <= #dts# 
						AND     W.DateExpiration >= #dts# 					
						AND     D.WorkActionId IS NOT NULL 
						
					 ) PL ON A.WorkActionId = PL.WorkActionId
					
					 
		   WHERE     WL.WorkOrderLineId = '#url.cfmapname#' 	
		   AND       W.Mission          = '#url.mission#'		  
		   AND       A.ActionClass      = 'Delivery'
		   AND       A.DateTimePlanning = #dts# 
		   AND       WL.Operational     = '1'  	  
		   AND       W.ActionStatus    != 9	
</cfquery>	

<cfif url.mode eq "standard">
	<cfset cl = "labelmedium">
<cfelse>
	<cfset cl = "labelit">
</cfif>
	
<cfform name="formdelivery" method="POST">			

<table cellspacing="0" cellpadding="0">
			
	<cfoutput query="Customer">
	
		<cfif actual eq "0" or DateTimeActual gte now()-1>
			<cfset edit = "Yes">
		<cfelse>
			<cfset edit = "No">	
		</cfif>
					
		<tr>
			<td colspan="2" align="left" style="padding-left:2px;padding-bottom:2px;" class="#cl#">
				<a href="javascript:detail('#url.cfmapname#')"><cf_tl id="Click for more details"></a>
			</td>
			</tr>
		
			<tr><td class="#cl#"><cf_tl id="Name">:</td><td class="#cl#">#CustomerName#</td></tr>
			<tr><td class="#cl#"><cf_tl id="Address">:</td><td class="#cl#">#Address#, #PostalCode#</td></tr>
			<tr><td class="#cl#"><cf_tl id="City">:</td><td class="#cl#">#City#</td></tr>
			
			<cfif MobileNumber eq "">
			<tr><td class="#cl#"><cf_tl id="Phone">:</td><td class="#cl#">#PhoneNumber#</td></tr>
			<cfelse>
			<tr><td class="#cl#"><cf_tl id="Mobile">:</td><td class="#cl#">#MobileNumber#</td></tr>
			</cfif>
												
			<tr><td class="#cl#"><cf_tl id="Status">:</td>
			    <td class="#cl#">
			
				<cfif Actual eq "1"><cf_tl id="Delivered"> #dateformat(DateTimeActual,CLIENT.DateFormatShow)# #timeformat(DateTimeActual,"HH:MM")#
				<cfelseif Schedule neq ""><cf_tl id="Scheduled">
				<cfelse><font color="gray"><cf_tl id="Pending"></font></cfif>
				
			</td>
			</tr>		
			
			<cfif Schedule neq "">						
				
				<tr><td style="width:100px" class="#cl#"><cf_tl id="Schedule">:</td>
				<td class="#cl#">#Schedule#
				<!---			
				<cfif Edit eq "No">					
				#DagDeel#
				<cfelse>
							
				<!--- Custom classification fields --->
				<cfset url.topic = "f002p">		
				<cfset url.inputclass    = "regularxl">
				<cfset url.workorderid   = workorderid>
				<cfset url.workorderline = workorderline>
				<cfset url.serviceitem   = serviceitem>			
				<cfinclude template="../../WorkOrder/Create/CustomFields.cfm">	
										
				</cfif>
				--->
				</td></tr>
				<tr>
				<td class="#cl#"><cf_tl id="Driver">:</td>
				<td class="#cl#">#LastName#
				
				<!---
				<cfif Edit eq "No">	
				#LastName#
				<cfelse>
				
				<select name="PersonNo" id="PersonNo" class="regularxl">
				<option value=""></option>
				    <cfloop query="Person">
					<option value="#PersonNo#" <cfif Customer.PersonNo eq PersonNo>selected</cfif>>#FullName#</option>
					</cfloop>
				</select>
				
				</cfif>
				--->
				</td></tr>
			
			</cfif>	
						
			<cfif Edit eq "Yes" and url.mode eq "standard">	
							
				<tr><td colspan="2">
				
					<table width="99%" align="center">				
					<tr>
								
					<td class="labelmedium">
					Done
					</td>
					<td style="padding-left:3px">
					<input type="checkbox" name="Complete" value="1">
					</td>			
					<td style="padding-left:5px">		
						
						<cf_setCalendarDate
							name     = "transaction" 							
							timeZone = "6"	
							font     = "15"				
							mode     = "datetime">	
										
					</td>
										
					</tr>						
					
					<tr>
						<td colspan="2" id="status#url.cfmapname#"></td>
					
						<td colspan="1" align="right" height="26">
						
						<input type="button" 
						       name="Apply" 
							   value="Apply" 
							   class="button10g" 
							   style="width:100;height:27" 
							   onclick="ptoken.navigate('MAP/setDelivery.cfm?cfmapname=#url.cfmapname#','status#url.cfmapname#','','','POST','formdelivery')">
					
						</td>
				    </tr>					
					</table>	
									
				</td></tr>
				
				<tr><td height="4"></td></tr>
							
			</cfif>		
				
	</cfoutput>
	
</table>

</cfform>	

<cfelse>

	<cftry>
		
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset DTS = dateValue>
	
	<cfquery name="Org"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT   *
		    FROM     Organization.dbo.Organization
		   WHERE     OrgUnit = #url.cfmapname# 	       	  
	</cfquery>	
		
	<cfoutput>
		<table style="width:400px">
		   <tr><td height="5"></td></tr>
		   <tr class="line">
		   <td style="padding-right:15px;height:35px" colspan="4" class="labellarge"><b>#Org.OrgUnitName# </td></tr>
		   
		   <tr><td height="5"></td></tr>
		   		  
		   <cfquery name="Deliveries"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				
				SELECT   A.DateTimePlanning, 	
				         A.DateTimeActual,
				         W.WorkOrderId,
						 W.ServiceItem,
						 WL.WorkOrderLine,
						 WL.WorkOrderLineId,
						 C.PostalCode,
						 C.Address,
						 C.City,
						 C.MobileNumber,
				         C.CustomerName,	
						 Drv.PersonNo,      
				         Drv.LastName, 
						 T.TopicValue as DagDeel, 				 
						 1 as Planned,
						 (CASE WHEN A.DateTimeActual is NULL THEN 0 ELSE 1 END) as Actual
			    FROM     WorkOrder AS W INNER JOIN
		                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
						 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
						 <!--- planning data --->
						 LEFT OUTER JOIN  WorkOrderLineTopic AS T ON WL.WorkOrderId  = T.WorkOrderId AND WL.WorkOrderLine = T.WorkOrderLine AND (T.Topic = 'f002p' AND T.Operational = 1) 
						 LEFT OUTER JOIN  Employee.dbo.Person AS Drv ON WL.PersonNo = Drv.PersonNo 
						 INNER JOIN Customer as C ON W.CustomerId = C.CustomerId 
			   WHERE     W.Mission          = '#url.mission#'		
			   AND       W.OrgUnitOwner     = '#url.cfmapname#' 	
			   AND       WL.Operational     = '1'  	
			   AND       A.DateTimePlanning = #dts#       
			   AND       A.ActionClass      = 'Delivery' 		
			   ORDER BY T.TopicValue
		     
	 	</cfquery>	
				 
		<cfloop query="deliveries">
		   <tr class="labelmedium" style="height:20px">
		    <td style="padding-left:10px">#City#</td>
		   	<td><a href="javascript:detail('#workorderlineid#')">#CustomerName#</a></td>			
			<td>#DagDeel#</td>	
			<td>#LastName#</td>			   
		   </tr>
		</cfloop>		
		
		 <tr><td height="5"></td></tr> 	   
		   
	   </table>
	   
	</cfoutput>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfif>