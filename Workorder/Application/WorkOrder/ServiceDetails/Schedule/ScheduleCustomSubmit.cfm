
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder W
		WHERE   WorkOrderId = '#url.workorderid#'		
</cfquery>

<!--- update the topics entered --->

<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic 
  WHERE  (Mission = '#workorder.Mission#' or Mission is NULL)				 
  AND    Code IN (SELECT Code 
                  FROM   Ref_TopicServiceItem
				  WHERE  ServiceItem = '#workorder.ServiceItem#'
				 )
  AND    Operational = 1   
  AND    TopicClass = 'Schedule'
</cfquery>

<cfloop query="getTopics">
				
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
			  SELECT   * 
			  FROM     WorkorderLineScheduleTopic
			  WHERE    ScheduleId   = '#url.scheduleid#'		  			  
			  AND      Topic        = '#Code#'			 
		    </cfquery>		
		
	        <!--- check if new value = last value --->
			
			<cfif getList.ListValue eq SelectCurrentValue.TopicValue>
									
			    <!--- nada --->
				
			<cfelse>
					  		
				<cfquery name="CleanSameDateEntries" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">						 
				  DELETE  FROM WorkorderLineScheduleTopic
				  WHERE   ScheduleId      = '#url.scheduleid#' 	  				
				  AND     Topic           = '#Code#'				 			
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  WorkorderLineScheduleTopic
				 		 (ScheduleId,						
						  Topic,						
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.scheduleid#',				         
				          '#Code#',						
						  '#value#',
						  '#getList.ListValue#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
				</cfquery>
				
			</cfif>	
		
		</cfif>
			
	<cfelse>
	
		<cfquery name="SelectCurrentValue" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT   * 
			  FROM     WorkorderLineScheduleTopic
			  <cfif url.scheduleid neq "">
			  WHERE    ScheduleId  = '#url.scheduleid#'		  			
			  <cfelse>
			  WHERE  1=0
			  </cfif>
			  AND      Topic       = '#Code#'			 
		    </cfquery>		
		
		<cfif ValueClass eq "Boolean">					
			<cfparam name="FORM.Topic_#Code#" default="0">						
		</cfif>
		
		<cfset value  = Evaluate("FORM.Topic_#Code#")>
		
		<cfif value neq "">
		
			<cfif value eq SelectCurrentValue.TopicValue>
			
			     <!--- nada --->
						 
			<cfelse>
		
				<cfquery name="CleanSameDateValues" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE  FROM    WorkorderLineScheduleTopic
				  <cfif url.scheduleid neq "">
				  WHERE    ScheduleId  = '#url.scheduleid#'		  			
				  <cfelse>
				  WHERE  1=0
				  </cfif>  				 
				  AND     Topic         = '#Code#'				  		  
			    </cfquery>
			
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO WorkorderLineScheduleTopic
				 			 (ScheduleId,							
							  Topic, 							
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#url.scheduleid#',				            
							  '#Code#',							
							  '#value#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>	
				
			</cfif>	
		
		</cfif>
		
	</cfif>	

</cfloop>

