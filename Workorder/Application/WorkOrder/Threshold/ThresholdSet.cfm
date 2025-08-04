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

<!--- apply gl account --->

<cfquery name="clear" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE  WorkOrderThreshold			
		WHERE   WorkOrderId   = '#url.workorderid#'			
		AND     WorkorderLine = '#url.workorderline#'
</cfquery>

<cfif Form.thresholddateeffective neq "">
	    <CF_DateConvert Value="#Form.thresholddateeffective#">
		<cfset eff = dateValue>
	<cfelse>
	    <cfset eff = "">
	</cfif>	

<cfif LSIsNumeric(form.thresholdamount) 
    AND eff neq "" 
	AND form.thresholdamount neq "0">
	
	<cfquery name="insert" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO WorkOrderThreshold			
				(WorkOrderId, 
				 WorkOrderLine, 
				 DateEffective, 
				 Charged, 
				 Threshold, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	           VALUES (
			   '#url.workorderid#',
			   '#url.workorderline#',
			   #eff#,
			   '1',
			   '#form.thresholdamount#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
			   )			
	</cfquery>
	
	<font color="008000">Saved!</font>
	
<cfelse>

	<cfoutput><font color="FF0000">Revoked</font></cfoutput>	

</cfif>

				
	
