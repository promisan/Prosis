
<cfparam name="url.mode"      default="standard">
<cfparam name="url.personno"  default="">
<cfparam name="url.lastname"  default="">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfquery name="DeliveryDetails"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	
	  SELECT     P.WorkPlanId,
	             P.PlanOrder, 
	             P.PlanOrderCode,
				 (SELECT   Description
				  FROM     Ref_PlanOrder
                  WHERE    Code = P.PlanOrderCode) AS Schedule,  
				 P.DateTimePlanning, 
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
     FROM         WorkOrder AS W INNER JOIN
                      Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
                      WorkOrderLineAction AS WA ON W.WorkOrderId = WA.WorkOrderId INNER JOIN
                      WorkOrderLine AS WL ON WA.WorkOrderId = WL.WorkOrderId AND WA.WorkOrderLine = WL.WorkOrderLine RIGHT OUTER JOIN
                      WorkPlanDetail AS P ON WA.WorkActionId = P.WorkActionId
      WHERE      P.WorkPlanId IN (SELECT WorkPlanId 
	                              FROM   WorkPlan W
	                              WHERE  DateEffective  <= #dts# 
	                              AND    DateExpiration >= #dts# 
								  AND    W.Mission      = '#url.mission#'
								  AND    W.PositionNo   = '#url.PositionNo#')
      ORDER BY   P.WorkPlanId, P.PlanOrder, P.DateTimePlanning
</cfquery>
	
<cfif url.mode eq "standard">

	<table width="99%" align="center" cellspacing="0" cellpadding="0"> 
	
	<tr class="labelit">
	    <td></td>
	    <td><cf_tl id="Branch"></td>
		<td height="18" width="70"><cf_tl id="Schedule"></td>	
	    <td><cf_tl id="Customer"></td>
		<td><cf_tl id="Address"></td>
		<td><cf_tl id="Postal Code"></td>    	
	    <td><cf_tl id="City"></td>	
		<td><cf_tl id="Phone"></td>	
		<td><cf_tl id="Delivery"></td>	
	</tr>	
	
<cfelse>

	<table width="99%" bgcolor="white" align="center" cellspacing="0" cellpadding="0" class="navigation_table"> 	

</cfif>

<cfif DeliveryDetails.recordcount eq "0">

	 <tr><td colspan="9" class="labelit" style="padding-top:10px;padding-bottom:10px" align="center" height="1"><font color="808080">No records to show for <cfoutput>#url.dts#</cfoutput></td></tr>

</cfif>

<cfoutput query="DeliveryDetails" group="WorkPlanid">

		<cfquery name="Summary" dbtype="query">
			SELECT     *
	        FROM       DeliveryDetails
			WHERE      WorkPlanId = '#workplanId#'
			AND        WorkActionId is not NULL
		 </cfquery>

		 <tr>		
		 
		    <td class="labelmedium" style="padding-top:5px;padding-left:10px" colspan="3"><b>#summary.recordcount#</b> <cf_tl id="deliveries"></td>
		     	
		 	<td style="padding-top:5px;padding-right:5px">
		 		<a href="javascript:ColdFusion.navigate('Planner/PlannerReportPrint.cfm?dts=#URL.dts#&mission=#URL.Mission#&planid=#WorkPlanid#','process','','','POST','mapform')">
		 			<img src="#SESSION.root#/images/print.png" height="15" width="15" align="absmiddle" alt="" border="0"></a>
		 	<td>
		 </tr>

	<cfoutput>    

	    <cfif url.mode eq "standard">
			   
			<tr class="line labelmedium2">
			<td>#planorder#.</td>
			
			<cfif orgunitName neq "">
			<td colspan="7">#left(OrgUnitName,50)#</b></td>
			<cfelse>
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
		 <tr class="navigation_row line labelmedium2">
			 <td height="16" align="center"><cf_space spaces="10"><font size="1">#planorder#.</td>
			 <cfif orgunitName neq "">
			 <td colspan="3"><b>#left(OrgUnitName,50)#</b></td>
			 <cfelse>
			 <td><cf_space spaces="20"><a class="navigation_action" href="javascript:detail('#workorderlineid#','#url.dts#','#personno#')">#Schedule# <!--- #dateformat(DateTimePlanning,client.dateformatshow)# #timeformat(DateTimePlanning,"HH")# ---></a></td>
			 <td>#PostalCode#</td>
			 <td><cf_space spaces="30">#City#</td>   
			 </cfif>
		 </tr>
		 		
		</cfif>	
	
	</cfoutput>
	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>