<!--
    Copyright © 2025 Promisan

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
<cfparam name="url.mission"   default="Kuntz">

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfquery name="DeliveriesDetails"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	   SELECT   WL.WorkOrderId,WL.WorkOrderLineid, 
	            C.*, 
				PL.Schedule, 
				O.OrgUnit, 
				A.DateTimeActual, 
				O.OrgUnitName
	   FROM     WorkOrder AS W INNER JOIN
                WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine INNER JOIN

				  <!--- planned for today --->
			 				 
				 	(
				 
				    SELECT  W.WorkPlanId, 
					        D.PlanOrder, 
							D.PlanOrderCode, 
							R.Description as Schedule,		
							P.PersonNo,					
							P.LastName, 							
							P.FirstName,
							D.DateTimePlanning, 
							D.WorkActionId
							
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN
							Ref_PlanOrder AS R ON R.Code = D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  >= #dts#
					AND     W.DateExpiration <= #dts#  		
					<cfif url.personno neq "">
				    AND     P.PersonNo       = '#url.personno#'		 
			        <cfelse>
				    AND     P.LastName       = '#url.lastName#'		  
				    </cfif>
								
					AND     D.WorkActionId IS NOT NULL 
					
					) PL ON A.WorkActionId = PL.WorkActionId  INNER JOIN				
								
                Customer AS C ON W.CustomerId = C.CustomerId LEFT OUTER JOIN 
			    Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit
				
	   WHERE    A.ActionClass      = 'Delivery' 
	   AND      A.DateTimePlanning = #dts#
	   AND      W.Mission          = '#url.Mission#'		  
	   AND      WL.Operational  = '1'
	   AND      W.ActionStatus != '9'
	   ORDER BY A.DateTimePlanning,PL.Schedule, City			   

</cfquery>

<cfif url.mode eq "standard">

	<table width="99%" align="center" cellspacing="0" cellpadding="0" class="navigation_table"> 
	
	<tr class="labelmedium">
	    <td></td>
	    <td >Branch</td>
		<td height="18" width="70" >Schedule</td>	
	    <td>Customer</td>
		<td>Address</td>
		<td>Postal Code</td>    	
	    <td>City</td>	
		<td>Phone</td>	
		<td>Delivery</td>	
	</tr>	
	
<cfelse>

	<table width="99%" bgcolor="white" align="center" cellspacing="0" cellpadding="0" border="0"  class="navigation_table"> 	

</cfif>

<cfif DeliveriesDetails.recordcount eq "0">

	 <tr><td colspan="8" class="labelmedium" style="height:40px" align="center" height="1">No records to show in this view  <cfoutput>#url.dts#</cfoutput></td></tr>

</cfif>

<cfoutput query="DeliveriesDetails">

    <cfif url.mode eq "standard">
		  
		<tr class="labelit linedotted navigation_row">
		<td>#currentrow#.</td>
		<td>#left(OrgUnitName,40)#</td>
		<td height="16" width="70"><cf_space spaces="26">#Schedule#</td>
		<td>#CustomerName#</td>
		<td>#Address#</td>
		<td>#PostalCode#</td>
		<td>#City#</td>   
		<td><cfif len(MobileNumber) gte "5">#MobileNumber#<cfelse>#PhoneNumber#</cfif></td>   
		<td><cfif DateTimeActual eq ""><font color="FF8000">Not confirmed</font><cfelse>#dateformat(DateTimeActual,client.dateformatshow)# #timeformat(DateTimeActual, "HH:MM")#</cfif></td>  	
		</tr>		
	
	<cfelse>
	
	 <!--- short version for planning screen only --->
		
	 <tr class="labelit linedotted navigation_row">
		 <td height="16" align="center"><cf_space spaces="10"><font size="1">#currentrow#.</td>
		 <td><cf_space spaces="60">#left(OrgUnitName,35)#</td>
		 <td><cf_space spaces="24"><a class="navigation_action" href="javascript:detail('#workorderlineid#','#url.dts#','#personno#')"><font color="0080C0">#Schedule#</a></td>
		 <td><cf_space spaces="40">#City#</td>   
	 </tr>
		
	</cfif>	
	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>