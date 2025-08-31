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
<table width="100%" height="100%">
	
	<tr><td>
		
		<cfquery name="get" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT  *
		     FROM    Request
			 WHERE   Requestid = '#url.ajaxid#'	 
		</cfquery>
		
		<cfquery name="check" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		     SELECT  R.*, WL.WorkOrderLineId AS WorkOrderLineId
			 FROM    RequestWorkOrder R INNER JOIN
		             WorkOrderLine WL ON R.WorkOrderId = WL.WorkOrderId AND R.WorkOrderLine = WL.WorkOrderLine
			 WHERE   Requestid = '#url.ajaxid#'			
		</cfquery>
		
		<cfif check.recordcount gte "1">
		    
			<!--- show as part of the workflow --->
			<table width="100%" align="center">
				<tr><td width="100%" style="padding-left:30px;font-size:23px;padding-top:30px" class="labellarge">
				    
					<a href="javascript:lineopen('#check.workorderlineid#')">
					<font color="6688aa"><cf_tl id="Request has been fullfilled"></font>
					</a>
					
					</td>
				</tr>
			</table>	
		
		<cfelse>
			
			<cfoutput>
			
			<iframe src="#session.root#/workorder/application/WorkOrder/Create/WorkOrderAdd.cfm?context=workflow&customerid=#get.customerid#&mission=#get.mission#&requestid=#url.ajaxid#&systemfunctionid="
			 width="100%" height="100%" frameborder="0"></iframe>
			
			 </cfoutput>
			 
		</cfif>	 
	
	</td></tr>

</table>
