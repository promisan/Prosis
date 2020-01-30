	<cfquery name="getAction"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ServiceItem 
		WHERE  Code = '#url.serviceitem#'
	</cfquery>	
	
	<cfquery name="getSerial"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	    SELECT MAX(ServiceUsageSerialNo) as Last 
		FROM   ServiceItemLoad 
		WHERE  ServiceItem = '#url.serviceitem#'
	</cfquery>	
	
	<!--- close the workorder lines --->
	
	<cfquery name="getLines"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   WorkOrderLine WL
	   WHERE  WL.PersonNo  = '#client.personno#'
	   AND    WL.WorkOrderId IN (SELECT WorkorderId 
		                         FROM   WorkOrder 
								 WHERE  WorkorderId = WL.Workorderid 
								 AND    ServiceItem = '#url.serviceitem#')	
	</cfquery>		

<!---	
	<cfquery name="LastSerialApproved"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
	    SELECT MAX(SerialNo) as Last 
		FROM   WorkOrderLineAction A
		INNER JOIN WorkOrderLine L ON A.WorkOrderid = L.WorkOrderId AND A.WorkOrderLine = L.WorkOrderLine
		WHERE  L.PersonNo  = '#client.personno#'
	    AND    L.WorkOrderId IN (SELECT WorkorderId 
		                         FROM   WorkOrder 
								 WHERE  WorkorderId = WL.Workorderid 
								 AND    ServiceItem = '#url.serviceitem#')
		AND A.Actionclass = 'Close'
	</cfquery>		
--->
<cftransaction>
	
	
	<!--- the below seals the transactions in workorderlinedetail & workorderlinedetailcharge that lie before the closing and put these
	as final --->
	
	<cfloop query="getLines">
	
		<!--- check of the line already exists --->
		
		<cfquery name="get"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT *
		   FROM  WorkOrderLineAction
		   WHERE WorkOrderId   = '#workorderid#'
		   AND   WorkOrderLine = '#workorderline#'
		   AND   ActionClass   = '#getAction.UsageActionClose#'
		   AND   SerialNo      = '#getSerial.Last#'
		   AND   ActionStatus  != '9'
		</cfquery>
		
		<cfif get.recordcount eq "1">
		
			<cfquery name="set"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
				   UPDATE WorkOrderLineAction
				   SET    DateTimePlanning = getDate()
				   WHERE  WorkActionId = '#get.WorkActionId#'				  
			</cfquery>		
		
		<cfelse>    		
		
			<cfquery name="insert"
			   datasource="AppsWorkOrder"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			   INSERT INTO WorkOrderLineAction
				   ( WorkOrderId,
				     WorkOrderLine,
					 ActionClass,
					 SerialNo,
					 DateTimePlanning,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			   VALUES
				   ('#workorderid#',
				    '#workorderline#',
					'#getAction.UsageActionClose#',
					'#getSerial.Last#',
					getDate(),
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')		
	       </cfquery>		
		   
		 </cfif>  			
	
	</cfloop>
	
</cftransaction>	

<!--- Send approval notification --->
<cfinvoke component = "Service.Process.WorkOrder.WorkOrderNotification"  
   	method          = "ProcessNotification" 
    mission         = "#url.mission#" 
    serviceItem     = "#url.serviceitem#"
	Action			= "Close"
	Notification	= "Approval"
 	PersonNo        = "#client.personno#"
	SerialNo		= "#getSerial.Last#"> 		

<!--- reload the base screen --->
<cfset url.scope    = "clearance">

<cfinclude template = "../../../../Portal/User/Submission/SubmissionPending.cfm">

