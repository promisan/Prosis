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
<cfquery name="getCustomTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE  Code IN (SELECT Code 
                  FROM   Ref_TopicServiceItem
				  WHERE  ServiceItem = '#url.customServiceItem#'
				 )
  AND    (Mission = '#url.customMission#' or Mission is NULL)				 
  AND    Operational = 1 
  AND    TopicClass = 'ActionProcess'
</cfquery>

<cfloop query="getCustomTopics">
				
	 <cfif ValueClass eq "List">

		<cfset value  = Evaluate("FORM.Topic_#url.customCode#_#url.customServiceItem#_#Code#")>
		
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
			  FROM     Ref_ActionServiceItemTopic
			  WHERE    Code   = '#url.customCode#'		
			  AND	   ServiceItem = '#url.customServiceItem#'  			  
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
				  DELETE  FROM Ref_ActionServiceItemTopic
				  WHERE    Code   = '#url.customCode#'		
			  		AND	   ServiceItem = '#url.customServiceItem#'  			  
			  		AND      Topic        = '#Code#'			 			
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  Ref_ActionServiceItemTopic
				 		 (Code,
						  ServiceItem,							
						  Topic,						
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.customCode#',				         
				          '#url.customServiceItem#',	
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
			  FROM     Ref_ActionServiceItemTopic
			  <cfif url.customCode neq "">
			  WHERE    Code  = '#url.customCode#'
			  AND      ServiceItem = '#url.customServiceItem#'		  			
			  <cfelse>
			  WHERE  1=0
			  </cfif>
			  AND      Topic       = '#Code#'			 
		    </cfquery>		
		
		<cfif ValueClass eq "Boolean">					
			<cfparam name="FORM.Topic_#url.customCode#_#url.customServiceItem#_#Code#" default="0">						
		</cfif>
		
		<cfset value  = Evaluate("FORM.Topic_#url.customCode#_#url.customServiceItem#_#Code#")>
		
		<cfif value neq "">
		
			<cfif value eq SelectCurrentValue.TopicValue>
			
			     <!--- nada --->
						 
			<cfelse>
		
				<cfquery name="CleanSameDateValues" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE  FROM    Ref_ActionServiceItemTopic
				   <cfif url.customCode neq "">
			  		WHERE    Code  = '#url.customCode#'
			  		AND      ServiceItem = '#url.customServiceItem#'  			
				  <cfelse>
				  WHERE  1=0
				  </cfif>  				 
				  AND     Topic         = '#Code#'				  		  
			    </cfquery>
			
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO Ref_ActionServiceItemTopic
				 			 (Code,
							  ServiceItem,							
							  Topic, 							
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#url.customCode#',				            
							  '#url.customSErviceItem#',	
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

