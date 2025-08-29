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
<cfquery name="qConfirm"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   A.DateTimePlanning, 	
		         A.WorkActionId, 
				 A.DateTimeActual
				 
	    FROM     WorkOrder AS W 
				 INNER JOIN Customer as C ON W.CustomerId = C.CustomerId  
		         INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId 
				 INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
	   WHERE     A.ActionClass = 'Delivery' 
	   AND       A.DateTimePlanning = '#URL.date#'
	   AND       W.Mission = '#url.mission#'	
	   AND       WL.Operational = '1'
	   AND       W.ActionStatus != 9
	   AND       A.DateTimeActual IS NULL	
	   ORDER BY  A.DateTimePlanning 
</cfquery>	   

<!--- going line by line --->
<cftransaction>
	
	<cfloop query="qConfirm">
		<cfquery name="qUpdate"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE WorkOrderLineAction
			SET    DateTimeActual = DateTimePlanning
	   		WHERE  WorkActionId   = '#qConfirm.WorkActionId#'
		</cfquery>	   
	</cfloop>
	
</cftransaction>


<cfquery name="qRefreshLines"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   PL.PersonNo, COUNT(1) as total
				 
	    FROM     WorkOrder AS W 
				 INNER JOIN Customer as C ON W.CustomerId = C.CustomerId  
		         INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId 
				 INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 
 			     LEFT OUTER JOIN 
				 	(
				 
				    SELECT  W.WorkPlanId, D.PlanOrder, D.PlanOrderCode, W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning, D.WorkActionId
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo
					WHERE   W.Mission = '#url.mission#'	
					AND     W.DateEffective  <= '#URL.date#'
					AND     W.DateExpiration >= '#URL.date#'
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
					
					LEFT OUTER JOIN Ref_PlanOrder OP ON OP.Code = PL.PlanOrderCode  
												
	   WHERE     A.ActionClass = 'Delivery' 
	   AND       A.DateTimePlanning = '#URL.date#'
	   AND       W.Mission = '#url.mission#'			   	
	   AND       WL.Operational = '1'
	   AND       W.ActionStatus != 9	
   	   AND       A.DateTimeActual IS NOT NULL	
	   GROUP BY  PL.PersonNo
</cfquery>




<cfoutput>
<script>
var id;

var total=0;
<cfloop query="qRefreshLines">
	try {
		id = 'total_#PersonNo#_#dateformat(URL.date,"DDMMYYYY")#';
		document.getElementById(id).innerHTML = '<b>#Total#</b>';
		total = total + #Total#;
	}
	catch(e){}
</cfloop>	

if (total == #qConfirm.recordcount#) {
	id = 'btnConfirm_#dateformat(URL.date,"DDMMYYYY")#';
	document.getElementById(id).className = "hide";	
}

alert(total+' deliveries have been confirmed!');	

</script>
</cfoutput>
