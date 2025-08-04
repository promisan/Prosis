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
		
<cfquery name="Request" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request		
		WHERE  Requestid = '#url.ajaxid#'	
</cfquery>

	
<cfquery name="children" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   RW.RequestId, RW.WorkOrderLine, WL.Reference
		FROM     RequestWorkOrder AS RW INNER JOIN
                 WorkOrderLine AS WL ON RW.WorkOrderId = WL.ParentWorkOrderId AND RW.WorkOrderLine = WL.ParentWorkOrderLine
		WHERE    WL.Operational = 1
		AND      RW.Requestid = '#url.ajaxid#'	
		
		
</cfquery>

<cfoutput>

<!---

<textarea>
SELECT   RW.RequestId, RW.WorkOrderLine, WL.Reference
		FROM     RequestWorkOrder AS RW INNER JOIN
                 WorkOrderLine AS WL ON RW.WorkOrderId = WL.ParentWorkOrderId AND RW.WorkOrderLine = WL.ParentWorkOrderLine
		WHERE    WL.Operational = 1
		AND      RW.Requestid = '#url.ajaxid#'		

</textarea>

--->

<table width="96%" cellspacing="0" cellpadding="0" align="center">

<!--- if request is not completed (we can make it workflow dependent) and if we find children records anyways --->

<cfif Request.actionStatus lt "3" and children.recordcount gte "1">

<tr><td style="height:30;padding-top:3px;padding-left:4px" align="center" class="labelmedium">
	<font color="FF0000"><b>Attention:</b> It appears that this service line under No #children.reference#/#children.workorderline# has been (partially) processed. Please contact your administrator before you continue !</font>
</td></tr>

<tr><td class="line"></td></tr>

<tr><td height="4"></td></tr>

</cfif>

<tr><td id="#url.ajaxid#">
	<cfinclude template="DocumentWorkflowContent.cfm">
</td></tr>
</cfoutput>
</table>


			