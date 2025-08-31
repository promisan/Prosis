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
<cfquery name="workorder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE  WorkOrderLineItem 
	FROM    WorkOrderLineItem I
	WHERE     UoM NOT IN
                    (SELECT   UoM
                     FROM     Materials.dbo.ItemUoM
                     WHERE    ItemNo = I.ItemNo)
	AND     WorkOrderId = '#url.workorderid#'							
</cfquery>							

<cfquery name="workorder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId  = '#url.workorderid#'	
</cfquery>


<cfoutput>
<table height="100%" width="98%" align="center">

<tr><td height="20" style="padding-top:4px" class="labellarge"><cf_tl id="Production recapitulation in"> #application.BaseCurrency#</td></tr>

<tr><td class="line"></td></tr>

<tr><td height="100%">

    <cf_divscroll>

	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr><td width="50%" valign="top" style="padding:15px">
		<cfinclude template="PlanningView.cfm">
		</td>
		<td style="border-left:1px solid silver;padding:15px" width="50%" valign="top">
		<cfinclude template="ActualsView.cfm">
		</td>
	</tr>	
	</table>	
	
	</cf_divscroll>
	

</td></tr>

</table>

</cfoutput>
