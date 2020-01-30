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
