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

<!--- saving custom fields --->

<cfparam name="url.requestid"   default="">
<cfparam name="url.context"     default="Backoffice">
<cfparam name="url.action"      default="record">
<cfparam name="url.topicclass"  default="workorder">
<cfparam name="url.domainclass" default="">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder W, ServiceItem S
	 WHERE   W.ServiceItem = S.Code
	 AND     WorkOrderId     = '#id#'		 
</cfquery>

<cfif url.context eq "backoffice">

	<cfquery name="set" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 UPDATE  WorkOrder
		 SET     ActionStatus = '1'  <!--- this will lock the access for the selfservice --->
		 WHERE   WorkOrderId     = '#id#'		 
	</cfquery>

</cfif>

<cfparam name="url.topicselect" default="">

<cfif url.requestid neq "">

    <!--- disabled by hanno 3/11/2015 
		
	<cfquery name="Line" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrderLine
		 WHERE   WorkOrderId    = '#id#'	
		 AND     WorkOrderLine  = '#url.workorderline#'
	</cfquery>
	
	<cfquery name="Reset" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 UPDATE  WorkorderService
		 SET     Reference      = '#Form.reference#'
		 WHERE   Reference      = '#Line.reference#'
		 AND     ServiceDomain  = '#Line.ServiceDomain#'		 
	</cfquery>
	
	--->
	
	<cfquery name="Update" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 UPDATE  WorkorderLine
		 SET     PersonNo = '#Form.PersonNo#'    
		 WHERE   WorkOrderId    = '#id#'	
		 AND     WorkOrderLine  = '#url.workorderline#'
	</cfquery>

</cfif>

<!--- define custom topics --->

<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  <cfif url.topicselect eq "">
  WHERE  Code IN (SELECT Code 
                  FROM   Ref_TopicServiceItem 
				  WHERE  ServiceItem = '#workorder.serviceitem#' )
  <cfelse>
  WHERE  Code = '#url.topicselect#'				 
  </cfif>
  AND    (Mission = '#workorder.Mission#' or Mission is NULL)				 
  AND    Operational = 1     
  AND    TopicClass = '#url.topicclass#'  
 
</cfquery>


<cfloop query="getTopics">
		
	<!--- check if this topic has classes defined for the service item --->
	
	<cfquery name="hasClassFilter" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_TopicDomainClass					
		WHERE    Code             = '#Code#'
		AND      ServiceDomain    = '#WorkOrder.ServiceDomain#' 			
	 </cfquery> 
	 
	<cfif hasClassFilter.recordcount eq "0">
	
			<cfset show = "1">
			
	<cfelse>
		
		<cfquery name="checkClass" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_TopicDomainClass					
			WHERE  Code               = '#Code#'
			AND    ServiceDomain      = '#WorkOrder.ServiceDomain#' 	
			AND    ServiceDomainClass = '#url.DomainClass#' 
		 </cfquery> 
		 
		 <cfif checkclass.recordcount eq "1">
				 	
		 	<cfset show = "1">
			
		 <cfelse>
		 
		 	<cfset show = "0">
		 
		 </cfif>
	
	</cfif> 
			
	<cfif show eq "1">
		
	     <cfparam name="FORM.Topic_#Code#" default="">
		
			  <cfquery name="DeactivateValues" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				
				 <cfif url.topicclass eq "Request">
				 UPDATE  WorkOrderTopic
				 SET     Operational   = 0
				 WHERE   WorkOrderId   = '#id#'		  			
				 AND     Topic         = '#Code#'		
				 <cfelse>
				 UPDATE  WorkOrderLineTopic
				 SET     Operational   = 0
				 WHERE   WorkOrderId   = '#id#'		  
				 AND     WorkOrderLine = '#url.workorderline#'
				 AND     Topic         = '#Code#'		
				 </cfif>			 	
		        </cfquery>			 
						
		 <cfif ValueClass eq "List">
	
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
			 <cfquery name="GetList" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Ref_TopicList
				  WHERE  Code     = '#Code#'
				  AND    ListCode = '#value#'				  
			</cfquery>	
								
			<cfif value neq "">
								
				<cfquery name="SelectCurrentValue" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  				  
				  <cfif url.topicclass eq "Request">
					  SELECT   TOP 1 * 
					  FROM     WorkOrderTopic
					  WHERE    WorkOrderId   = '#id#'		  					  					 
				  <cfelse>
					  SELECT   TOP 1 * 
					  FROM     WorkOrderLineTopic
					  WHERE    WorkOrderId   = '#id#'		  
					  AND      WorkOrderLine = '#url.workorderline#'					 
				  </cfif>	 
				  AND      Topic         = '#Code#'
				  ORDER BY DateEffective DESC, Created DESC 
			    </cfquery>		
				
			
		        <!--- check if new value = last value --->
				
				<cfif url.action neq "purge">
				
					<cfif getList.ListValue eq SelectCurrentValue.TopicValue>
											
					     <!--- reactivate --->
						 
						<cfquery name="CheckLast" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">	
						  
						  <cfif url.topicclass eq "Request">						  			  	
							  UPDATE  WorkOrderTopic 
							  SET     Operational   = 1
							  WHERE   WorkOrderId   = '#id#'		  							 
							  AND     Topic         = '#Code#'
							  AND     DateEffective = '#SelectCurrentValue.DateEffective#'		
						   <cfelse>
						      UPDATE  WorkOrderLineTopic 
							  SET     Operational   = 1
							  WHERE   WorkOrderId   = '#id#'		  
							  AND     WorkOrderLine = '#url.workorderline#'
							  AND     Topic         = '#Code#'
							  AND     DateEffective = '#SelectCurrentValue.DateEffective#'								   
						   </cfif>	  		
						   			  
					   </cfquery>		
				 
					<cfelse>
							  		
						<cfquery name="CleanSameDateEntries" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">	
						  
							  <cfif url.topicclass eq "Request">						  				 
								  DELETE  FROM WorkOrderTopic
								  WHERE   WorkOrderId     = '#id#'								 	
							  <cfelse>
							      DELETE  FROM WorkOrderLineTopic
								  WHERE   WorkOrderId     = '#id#'		  
								  AND     WorkOrderLine   = '#url.workorderline#'							 				  
							  </cfif>	 
						  
							  AND     Topic           = '#Code#'
							  AND     DateEffective   >  '#dateformat(now()-1,client.dateSQL)#'	 	
					    </cfquery>
								
						<cfquery name="InsertTopics" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  						  
						  <cfif url.topicclass eq "Request">
						   
							  INSERT INTO  WorkOrderTopic
							 		 (WorkOrderId,	
								 
						  <cfelse>
						  
							  INSERT INTO  WorkOrderLineTopic
							 		 (WorkOrderId,
									  WorkOrderLine,
								  
						  </cfif> 		  
						  		 							 
								  Topic,
								  DateEffective,
								  ListCode,
								  TopicValue,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
								  
								  
						  VALUES ('#id#',	
						  		   <cfif url.topicclass eq "WorkOrder">						          
								   '#url.workorderline#',
								   </cfif>
						          '#Code#',
								  '#dateformat(now(),client.dateSQL)#',
								  '#value#',
								  '#getList.ListValue#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#') 						
															  
						</cfquery>
						
					</cfif>	
					
				<cfelse>
				
						<!--- deactivate --->
						 
						<cfquery name="CheckLast" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">	
						  
						  <cfif url.topicclass eq "Request">
						  
							  UPDATE  WorkOrderTopic 
							  SET     Operational   = 0
							  WHERE   WorkOrderId   = '#id#'	
							  
						  <cfelse>
						  
						  	  UPDATE  WorkOrderLineTopic 
							  SET     Operational   = 0
							  WHERE   WorkOrderId   = '#id#'		  
							  AND     WorkOrderLine = '#url.workorderline#'
						  
						  </cfif>
						  	  	  						 
							  AND     Topic         = '#Code#'
							  AND     DateEffective = '#SelectCurrentValue.DateEffective#'							  
						 						  
					   </cfquery>					
				
				</cfif>			
					
			</cfif>
				
		<cfelse>
		
			<cfquery name="SelectCurrentValue" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">				  
				 				  
					  SELECT   TOP 1 * 
					  <cfif url.topicclass eq "Request">
					  FROM     WorkOrderTopic
					  WHERE    WorkOrderId   = '#id#'		  
					  <cfelse>	
					  FROM     WorkOrderLineTopic
					  WHERE    WorkOrderId   = '#id#'					  
					  AND      WorkOrderLine = '#url.workorderline#'
					  </cfif>
					  AND      Topic         = '#Code#'
					  ORDER BY DateEffective DESC, Created DESC
			    </cfquery>		
			
			<cfif ValueClass eq "Boolean">					
				<cfparam name="FORM.Topic_#Code#" default="0">						
			</cfif>
			
			<cfset value  = Evaluate("FORM.Topic_#Code#")>
			
					
			<cfif value neq "">
									
				<cfif url.action neq "purge">
											
					<cfif value eq SelectCurrentValue.TopicValue>
				
										
					     <!-- reactivate --->
						 
						<cfquery name="UpdateLast" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  
						  <cfif url.topicclass eq "Request">
							  UPDATE  WorkOrderTopic
							  SET     Operational = 1
							  WHERE   WorkOrderId   = '#id#'		  						 
							  AND     Topic         = '#Code#'
							  AND     DateEffective = '#SelectCurrentValue.DateEffective#'	
						  <cfelse>
							  UPDATE  WorkOrderLineTopic
							  SET     Operational = 1
							  WHERE   WorkOrderId   = '#id#'		  
							  AND     WorkOrderLine = '#url.workorderline#'
							  AND     Topic         = '#Code#'
							  AND     DateEffective = '#SelectCurrentValue.DateEffective#'	
						  </cfif>		 
						  
					   </cfquery>		
				 
					<cfelse>
									
					
				
						<cfquery name="CleanSameDateValues" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">						 
						  DELETE  
						  <cfif url.topicclass eq "Request">
						  FROM    WorkOrderTopic
						  WHERE   WorkOrderId   = '#id#'		  						  
						  <cfelse>
						  FROM    WorkOrderLineTopic
						  WHERE   WorkOrderId   = '#id#'		  
						  AND     WorkOrderLine = '#url.workorderline#'
						  </cfif>
						  AND     Topic         = '#Code#'
						  AND     DateEffective =  '#dateformat(now(),client.dateSQL)#'							    
					    </cfquery>
					
						<cfquery name="InsertTopics" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  
						  <cfif url.topicclass eq "Request">
						  
						  INSERT INTO WorkOrderTopic
						 			 (WorkOrderId,									 
						  <cfelse>		
						  
						  INSERT INTO WorkOrderLineTopic
						 			 (WorkOrderId,
									  WorkOrderLine, 	  									  
						  </cfif>			  
									  
									  Topic, 
									  DateEffective, 
									  TopicValue,
									  OfficerUserId,
									  OfficerLastName,
									  OfficerFirstName)
									  
						  VALUES 	 ('#id#',
						             <cfif url.topicclass eq "WorkOrder">
						              '#URL.workorderline#',
									 </cfif>  
									  '#Code#',
									  '#dateformat(now(),client.dateSQL)#',
									  '#value#', 
									  '#SESSION.acc#',
									  '#SESSION.last#',
									  '#SESSION.first#')						  
						  
						</cfquery>	
						
					</cfif>	
				
				<cfelse>
			
					<!--- reset --->
					
					<!--- deactivate --->
						 
					<cfquery name="CheckLast" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">	
					  
					  <cfif url.topicclass eq "Request">
					  
						  UPDATE  WorkOrderTopic 
						  SET     Operational   = 0
						  WHERE   WorkOrderId   = '#id#'	
						  
					  <cfelse>
					  
					  	  UPDATE  WorkOrderLineTopic 
						  SET     Operational   = 0
						  WHERE   WorkOrderId   = '#id#'		  
						  AND     WorkOrderLine = '#url.workorderline#'
					  
					  </cfif>
					  	  	  						 
						  AND     Topic         = '#Code#'
						  AND     DateEffective = '#SelectCurrentValue.DateEffective#'							  
					 						  
				   </cfquery>				
			
			
				</cfif>
				
			</cfif>	
			
		</cfif>	
		
	</cfif>	

</cfloop>
