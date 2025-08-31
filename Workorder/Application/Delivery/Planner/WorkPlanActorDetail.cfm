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
<cfparam name="url.mode"      default="standard">
<cfparam name="url.personno"  default="">
<cfparam name="url.lastname"  default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfquery name="WorkPlan"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT WorkPlanId, 
	       (SELECT COUNT(*)       FROM WorkPlanDetail WHERE WorkPlanId = W.WorkPlanId) as Total, 
		   (SELECT MAX(PlanOrder) FROM WorkPlanDetail WHERE WorkPlanId = W.WorkPlanId) as Last
    FROM   WorkPlan W
    WHERE  DateEffective  <= #dts# 
    AND    DateExpiration >= #dts# 
	AND    W.Mission      = '#url.mission#'
	AND    W.PositionNo   = '#url.PositionNo#'
</cfquery>	

<cfloop query="workplan">
		
	<cfif Total neq Last>
			
		<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
			   method           = "setWorkPlanOrder" 
			   WorkPlanId       = "#workplanid#">   	
			
	</cfif>

</cfloop>	
	
<cfquery name="DeliveryDetails"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT     P.WorkPlanId,
	             P.WorkPlanDetailId,
	             P.PlanOrder, 
	             P.PlanOrderCode,
				 O.ListingOrder,
				 O.Description as Schedule,  
				 P.DateTimePlanning, 
				 WA.DateTimeActual, 
				 P.OrgUnitOwner,
                 (SELECT   OrgUnitName
                  FROM     Organization.dbo.Organization
                  WHERE    OrgUnit = P.OrgUnitOwner) AS OrgUnitName, 
				 P.WorkActionId, 
				 C.PostalCode, 
				 C.City, 
				 C.Address,
				 C.CustomerName, 
                 C.PhoneNumber, 
				 C.MobileNumber, 
				 C.eMailAddress, 
				 WA.DateTimeActual,
				 WL.WorkOrderLineId
     FROM        WorkOrder AS W INNER JOIN
                 Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
                 WorkOrderLineAction AS WA ON W.WorkOrderId = WA.WorkOrderId AND WA.ActionClass = 'Delivery' INNER JOIN
                 WorkOrderLine AS WL ON WA.WorkOrderId = WL.WorkOrderId AND WA.WorkOrderLine = WL.WorkOrderLine RIGHT OUTER JOIN
                 WorkPlanDetail AS P ON WA.WorkActionId = P.WorkActionId INNER JOIN
				 Ref_PlanOrder O ON O.Code = P.PlanOrderCode
	  <cfif quotedValueList(WorkPlan.WorkPlanId) neq "">					 
      WHERE      P.WorkPlanId IN (#quotedValueList(WorkPlan.WorkPlanId)#) 	 	 
	  <cfelse>
	  WHERE      1=0
	  </cfif>
      ORDER BY   P.WorkPlanId, 
	  			 O.ListingOrder,				 
	             P.PlanOrder	  
</cfquery>

<cfif url.mode eq "standard">

	<table width="99%" align="center" cellspacing="0" cellpadding="0"> 
	
	<tr class="labelit fixlengthlist">
	    <td></td>
	    <td><cf_tl id="Branch"></td>
		<td height="18" width="70"><cf_tl id="Schedule"></td>	
	    <td>Customer</td>
		<td>Address</td>
		<td>Postal Code</td>    	
	    <td>City</td>	
		<td>Phone</td>	
		<td>Delivery</td>	
	</tr>	
	
	<cfset cols = "9">
	
<cfelse>

	<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0" class="navigation_table"> 	
	
	<cfset cols = "5">

</cfif>


<cfparam name="form.workplandetailid" default="">


<cfif DeliveryDetails.recordcount eq "0">

	 <tr><td colspan="9" class="labelit" style="padding-top:10px;padding-bottom:10px" align="center" height="1"><font color="808080"><b>No records to show for <cfoutput>#url.dts#</cfoutput></td></tr>

</cfif>

<cfoutput query="DeliveryDetails" group="WorkPlanid">

		<cfquery name="Summary" dbtype="query">
			SELECT     *
	        FROM       DeliveryDetails
			WHERE      WorkPlanId = '#workplanId#'
			AND        WorkActionId is not NULL
		 </cfquery>
		
		 <tr class="fixlengthlist">		
		 	
		 	<td colspan="4" style="height:36px">				
			     <table><tr><td style="padding-right:1px;padding-left:15px">
				 <button type="button" class="button3" style="border:1px solid silver" onclick="ptoken.navigate('Planner/WorkPlanMove.cfm?direction=up&positionno=#positionno#&dts=#url.dts#&mission=#url.mission#','positioncontent_#positionno#','','','POST','mapform')">
				 <img style="cursor:pointer" onclick="" src="#session.root#/images/up6.png" alt="" border="0">
				 </button>
			     
				 </td>
				 <td>|</td>
				 <td style="padding-left:1px">
				 <button type="button" class="button3" style="border:1px solid silver" onclick="ptoken.navigate('Planner/WorkPlanMove.cfm?direction=down&positionno=#positionno#&dts=#url.dts#&mission=#url.mission#','positioncontent_#positionno#','','','POST','mapform')">
				 <img style="cursor:pointer" 
				       src="#session.root#/images/down6.png" 
					  alt="" 
					  border="0">
					  </button>
					  </td></tr>
				  </table>
			</td>									 
						 
		   
			<td align="right" style="width:20px;padding-left:4px">
			  <table>
			  <tr>
			  <td>
		 		<a href="javascript:ptoken.navigate('Planner/PlannerReportPrint.cfm?dts=#URL.dts#&mission=#URL.Mission#&planid=#WorkPlanid#&scope=','process','','','POST','mapform')">
		 			<img src="#SESSION.root#/images/print.png" height="16" width="16" align="absmiddle" alt="" border="0"></a>
			  </td>
			  <td class="labellarge" align="right" style="padding-right:20px" colspan="#cols-3#"> <font size="2">#summary.recordcount#</td>			
			  </tr>	
			  </table>
		 	</td>
		 	
		 </tr>
		 
		 <cfset row = "0">

	<cfoutput>   		

	    <cfif url.mode eq "standard">
			   
			<tr class="line fixlengthlist labelmedium">
				<td style="padding-left:10px">#planorder#.</td>			
				<cfif workactionid eq "">
				<td width="70">#Schedule# <!--- #dateformat(DateTimePlanning,client.dateformatshow)# #timeformat(DateTimePlanning,"HH")# ---></td>				
				<td colspan="6">#left(OrgUnitName,50)#</b></td>
				<cfelse>
				<cfset row = row+1>
				<td width="70">#Schedule# <!--- #dateformat(DateTimePlanning,client.dateformatshow)# #timeformat(DateTimePlanning,"HH")# ---></td>
				<td>#CustomerName#</td>
				<td>#Address#</td>
				<td>#PostalCode#</td>
				<td>#City#</td>   
				<td><cfif len(MobileNumber) gte "5">#MobileNumber#<cfelse>#PhoneNumber#</cfif></td>   
				<td><cfif DateTimeActual eq ""><font color="FF8000">Not confirmed</font><cfelse>#dateformat(DateTimeActual,client.dateformatshow)# #timeformat(DateTimeActual, "HH:MM")#</cfif></td>  	
				</cfif>
			</tr>		
		
		<cfelse>
		
			 <!--- short version for planning screen only --->
			 <tr class="navigation_row line fixlengthlist">
			     
				 <td height="16" align="center" style="padding-left:10px"><cfif currentrow eq "1"><cf_space spaces="4"></cfif><font size="1">#planorder#.</td>
				 
				  <td style="padding-top:3px;padding-right:6px;padding-left:4px">				 
				  					 
				  <cfif datetimeactual eq "">
					 
					 <table>	
					 			 
						 <cfset link = "_cf_loadingtexthtml='';ptoken.navigate('Planner/WorkPlanDelete.cfm?action=revert&personno=#personno#&workactionid=#workactionid#&dts=#url.dts#&mission=#url.mission#','positioncontent_#url.positionno#')">													  
						 <tr>
						 	<cfif find(workplandetailid,form.workplandetailid)>						
							 <td><input type="checkbox" style="height:12px;width:12px" checked name="workplandetailid" value="'#workplandetailid#'"></td>
							<cfelse>
						     <td><input type="checkbox" style="height:12px;width:12px" name="workplandetailid" value="'#workplandetailid#'"></td>
							</cfif> 
							
							<cfif orgunitName eq "">
						     <td style="padding-left:4px"><cf_img icon="delete" onclick="#link#"></td>
							</cfif> 							
						 </tr>
					 </table>
					 					
				   </cfif>
				 
				 </td>
					
				 <cfif workactionid eq "">				 
					 <td colspan="3" class="labelmedium"><b>#left(OrgUnitName,50)# #OrgUnitOwner# </b>&nbsp;<font size="2" color="gray">[#Schedule#]</td>				
				 <cfelse>		
				     <td class="labelit">
						 <cfif workorderlineid neq "">					 
							 <a class="navigation_action" href="javascript:detail('#workorderlineid#','workplan_#positionno#')">#Schedule#</a>
						 </cfif>
					 </td>					
					 <td class="labelit">#PostalCode#</td>
					 <td class="labelit"><cfif currentrow eq "1"><cf_space spaces="16"></cfif>#City#</td>   
				 </cfif>
			 </tr>
		 		
		</cfif>	
	
	</cfoutput>
	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>