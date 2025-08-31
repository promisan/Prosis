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
<cfparam name="url.date" default="">

<cfif url.date eq "">
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#dateformat(now()+1,client.dateformatshow)#">
	<cfset DTS = dateValue>		
	
<cfelse>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.date#">
	<cfset DTS = dateValue>		
	
</cfif>


<cfquery name="Lock"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	UPDATE Workorder
	SET    ActionStatus = '1'
	WHERE  WorkorderId IN (
	SELECT WorkOrderId		  
	FROM (  	   
			
		SELECT   W.WorkOrderId
				 
	    FROM     WorkOrder AS W INNER JOIN						
                 WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
                 WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine LEFT OUTER JOIN 
			     Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit LEFT OUTER JOIN
			     Organization.dbo.OrganizationCategory OC ON O.OrgUnit = OC.Orgunit LEFT OUTER JOIN 
			     Organization.dbo.Ref_OrganizationCategory ROC ON ROC.Code = OC.OrganizationCategory AND ROC.Area ='Location'
				 
	    WHERE    W.Mission          = '#url.mission#'
		AND      A.ActionClass      = 'Delivery' 
		AND      A.DateTimePlanning = #dts#  			    	
		AND      WL.Operational     = '1'
		AND      W.ActionStatus    != '9' 
	
	) F  )
			   
</cfquery>	

<script>
    try {
	document.getElementById('lock').className = "hide"
	} catch(e) {}
</script>
	