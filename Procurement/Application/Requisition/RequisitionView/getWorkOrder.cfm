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

<cfparam name="url.workorderid" default="">
<cfparam name="url.doFilter" 	default="0">

<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  W.WorkOrderId, 
          C.CustomerName, 
		  W.Reference, 
		  W.OrderDate, 
		  W.ActionStatus, 
		  I.Description AS Item

  FROM    Workorder W, Customer C, ServiceItem I
  WHERE   W.CustomerId  = C.CustomerId 
  AND     W.Serviceitem = I.Code
  <cfif url.workorderid eq "">
  AND     1=0	
  <cfelse>
  AND     WorkorderId = '#url.workorderid#'  	
  </cfif>
  
</cfquery>

<cfoutput>
<table width="100%" height="18">
	<tr>
		<td>
		<input type="text" name="CustomerName" class="regularxxl" size="30" maxlength="80" value="#get.CustomerName# #get.Reference#" readonly>
		<input type="hidden" name="workorderid" id="workorderid" size="40" maxlength="60" value="'#url.workorderid#'" readonly>		
		</td>
	</tr>		
</table>
</cfoutput>

<cfif URL.doFilter eq 1>
	<cfset AjaxOnLoad("filter")>
</cfif>	