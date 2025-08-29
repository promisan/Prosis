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
<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *			 
     FROM    WorkOrder W
	 WHERE   WorkOrderId = '#url.workorderid#'					
</cfquery>
			
<!--- processstatus of the line --->				
<cfquery name="WorkOrderLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  Operational, ActionStatus, R.*			 
     FROM    WorkOrderLine WL, Ref_ServiceItemDomain R		 
	 WHERE   WorkOrderId      = '#url.workorderid#'		
	 AND     WorkOrderLine    = '#url.workorderline#'	
	  AND    WL.ServiceDomain = R.Code			
</cfquery>
		
 <cfquery name="Children" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *			 
     FROM    WorkOrderLine		 
	 WHERE   ParentWorkOrderId   = '#url.workorderid#'
	 AND     ParentWorkorderLine = '#url.workorderline#'					
</cfquery>


<cfif (children.recordcount gte "1" and workorderline.AllowConcurrent eq "0")
     or workorderline.actionstatus gte "3" 
	 or workorderline.operational eq "0">
   
   <cfset billingedit = "0"> 
   
<cfelseif workorderline.actionstatus gte "3" or workorderline.operational eq "0">   
	 
   <cfset billingedit = "0">
      
<cfelse>

   <cfset billingedit = "1">
   
</cfif>		

<table width="100%">			
			
	<tr><td height="7"></td></tr>		
	<tr><td height="4" id="billingdata">		
		<cfinclude template="DetailBillingList.cfm">		
	</td>
	</tr>	
			
	<cfquery name="CheckSupply" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItemMaterials
		 WHERE   ServiceItem   = '#workorder.serviceitem#'	
		 AND     MaterialsClass = 'Supply'
	</cfquery>					
	
	<cfif CheckSupply.MaterialsCategory neq "">	
				
		<tr><td style="padding-left:20px;border:0px solid silver">							
			<cfinclude template="../Supplies/SuppliesListingView.cfm">				
		</td></tr>
			
	</cfif>	
	
</table>


	