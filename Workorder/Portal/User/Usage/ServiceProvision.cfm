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

<!--- provisioning --->

<cfset url.scope = "portal">
	
<cfquery name="workorder" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT  *
	     FROM    Workorder W,WorkOrderLine WL
		 WHERE   W.WorkOrderId = WL.WorkOrderId
		 AND     WL.WorkOrderLineId = '#url.workorderLineid#'	 
</cfquery>

<cfset url.workorderid   = workorder.workorderid>
<cfset url.workorderline = workorder.workorderline>

<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td height="4"></td></tr>
	<tr><td style="height:30;padding-left:15px"><font face="Verdana" size="4"><b>My Plans</font></td></tr>
	<tr><td height="4" style="padding-left:15px; padding-top:20px" class="line"></td></tr>		
	
	<tr><td height="4" id="billingdata" height="100%" valign="top" style="padding-left:15px;padding-right:15px">	
		<cfinclude template="../../../../WorkOrder/Application/WorkOrder/ServiceDetails/Billing/DetailBillingList.cfm">		
	</td></tr>	
	
	<cfset url.serviceitem = workorder.serviceitem>
	
	<tr><td style="padding-left:15px; padding-top:20px"><font face="Verdana" size="2">Assigned Devices and/or equipment</font></td></tr>
	<tr><td style="padding-left:15px; padding-top:20px" height="4" class="line"></td></tr>		
	
	<tr><td id="assetbox" style="padding-left:15px;padding-right:15px">
		<cfinclude template="../../../../WorkOrder/Application/WorkOrder/Assets/Line.cfm">		
	</td></tr>
		
	<tr><td id="contentbox1" style="padding-left:15px;padding-right:15px; padding-top:10px">
		<cfinclude template="../../../../WorkOrder/Application/WorkOrder/ServiceDetails/Charges/ChargesWorkOrderLine.cfm">		
	</td></tr>
			
</table>

<script>
  document.getElementById('calendar').className = "hide"	    
</script>
