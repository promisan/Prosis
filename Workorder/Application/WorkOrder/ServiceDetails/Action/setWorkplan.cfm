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

<cfquery name="WorkPlan" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   WorkPlanDetail WPD, WorkPlan WP
	WHERE  WPD.WorkPlanId = WP.WorkPlanId
	AND    WorkActionid = '#url.workactionid#'
	AND    Operational = 1
</cfquery>

<cfquery name="WorkAction" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   WorkOrderLineAction
	WHERE  WorkActionid = '#url.workactionid#'
</cfquery>

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   WorkOrder
	WHERE  WorkOrderId = '#workaction.workorderid#'
</cfquery>

<!--- define access --->

<cfinvoke component = "Service.Access"  
   method           = "WorkorderManager" 
   mission          = "#workorder.mission#"    <!--- check for the create option --->
   returnvariable   = "access">	
   
<cfif Access eq "NONE" or access eq "READ">   

	<!--- it not then check if the person is a processor --->

	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#" 
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	   
   
</cfif> 

<cfoutput>  
	
	<cfif WorkPlan.DateTimePlanning neq "">
						
		  <table>
		  <tr class="labelmedium">
		  <td>		
			  <a href="javascript:workplan('#workactionid#')">
			  #dateformat(WorkPlan.DateTimePlanning,client.dateformatshow)# <font size="5">#timeformat(WorkPlan.DateTimePlanning,"HH:MM")#</font>
			  </a>
			  
			    <cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
				    FROM    Person
					WHERE   PersonNo  = '#WorkPlan.PersonNo#'						
			  </cfquery>
			  <font color="0080C0">
					#Person.LastName#		
			  </font>				
			  
		  </td>
		  <td style="padding-top:1px;padding-left:3px">
		  
		  <cfif access eq "EDIT" or access eq "ALL">					  
		     <cf_img icon="delete" onclick="ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Action/deleteWorkPlan.cfm?workactionid=#workactionid#','plan#workactionid#')">					  
		  </cfif>
		  
		  </td>
		  </tr>
		  </table>	
						 			
		 <cfelse>
		  			  	  
		  <u>
		  <a href="javascript:workplan('#workactionid#')">		  
			  <font color="FF0000">#dateformat(WorkAction.DateTimePlanning,client.dateformatshow)# <font size="2">#timeformat(WorkAction.DateTimePlanning,"HH:MM")#</font> 
		  </a>
		  </u>
		  
	</cfif>

</cfoutput>
