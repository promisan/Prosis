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
<table width="100%" height="100%" cellspacing="1" cellpadding="1">

	<tr><td height="5"></td></tr>	
	<tr><td height="4" colspan="2" id="billingdata">		   
		<cfinclude template="#client.virtualdir#/WorkOrder/Application/WorkOrder/ServiceDetails/Billing/DetailBillingList.cfm">		
	</td></tr>	
			
	<cfquery name="workorder" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT  *
	     FROM    Workorder
		 WHERE   WorkOrderId = '#url.workorderid#'	 
	</cfquery>
		
	<cfset url.serviceitem = workorder.serviceitem>
	
	<tr><td height="6" colspan="2"></td></tr>	
	<tr><td width="230" valign="top" class="labelmedium" style="padding-top:5px"><font size="3"><font color="808080">Requested Devices and Supplies</font></td>
	<td id="devicebox" width="75%" style="padding-top;5px">
		<cfinclude template="../Templates/RequestDevice.cfm">		
	</td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>		
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="labelmedium">Assigned Devices and/or equipment</font></td></tr>
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td colspan="2" id="assetbox">
		<cfinclude template="#client.virtualdir#/WorkOrder/Application/WorkOrder/Assets/Line.cfm">		
	</td></tr>	
	
	<tr><td colspan="2" class="labelmedium">Assigned accessories and other ad-hoc costs</font></td></tr>
	<tr><td colspan="2"class="line"></td></tr>		
	<tr><td id="adhoc" height="170" colspan="2">
		<cfinclude template="#client.virtualdir#/WorkOrder/Application/WorkOrder/ServiceDetails/Supplies/SuppliesListing.cfm">		
	</td></tr>

</table>