<!----- custom logic to reset ---->

<cfif Form.MobileNumber eq "">

				<cfset vTime = dateformat(now(),client.dateSQL)>
				
				<cfquery name="CleanSameDateValues" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE  FROM    WorkOrderLineTopic
				  WHERE   WorkOrderId   = '#id#'		  
				  AND     WorkOrderLine = '#url.workorderline#'
				  AND     Topic         = 'f010'
				  AND     DateEffective = '#vTime#' 			  
			    </cfquery>
				
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO WorkOrderLineTopic
				 			 (WorkOrderId,
							  WorkOrderLine, 
							  Topic, 
							  DateEffective, 
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#id#',
				              '#URL.workorderline#',
							  'f010',
							  '#vTime#',
							  '0',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>	
</cfif>				