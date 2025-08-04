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

<!--- assign the request header fields to a user and a service id --->

<cfparam name="Form.PersonNo"   default="">
<cfparam name="Form.CustomerId" default="">

<cfif form.customerId eq "">

  <table align="center">
    <tr><td align="center" class="labelit">Customer was not defined</td></tr>
  </table>
  <cfabort>

</cfif>

<cfquery name="setstatus"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE  Request
   SET     PersonNoUser    = '#Form.PersonNo#', 
           DomainReference = '#Form.DomainReference#',
		   CustomerId      = '#Form.CustomerId#'   
   WHERE   RequestId       = '#Object.ObjectKeyValue4#'	
</cfquery>		

<!--- update the Request topics entered into the Request --->

<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Request
	 WHERE   requestId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfquery name="getLine" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    RequestLine
	 WHERE   requestId = '#Object.ObjectKeyValue4#'
</cfquery>

<cfquery name="GetTopics" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic 
  WHERE  (Mission = '#get.Mission#' or Mission is NULL)				 
  AND    Code IN (SELECT Code 
                  FROM   Ref_TopicServiceItem
				  WHERE  ServiceItem = '#getLine.ServiceItem#'
				 )
  AND    Operational = 1   
  AND    TopicClass = 'Request'
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
			  FROM     RequestTopic
			  WHERE    Requestid     = #Object.ObjectKeyValue4#		  			  
			  AND      Topic         = '#Code#'			 
		    </cfquery>		
		
	        <!--- check if new value = last value --->
			
			<cfif getList.ListValue eq SelectCurrentValue.TopicValue>
									
			    <!--- nada --->
				
			<cfelse>
					  		
				<cfquery name="CleanSameDateEntries" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">						 
				  DELETE  FROM RequestTopic
				  WHERE   Requestid       = '#Object.ObjectKeyValue4#' 	  				
				  AND     Topic           = '#Code#'				 			
			    </cfquery>
						
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  RequestTopic
				 		 (Requestid,						
						  Topic,						
						  ListCode,
						  TopicValue,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#Object.ObjectKeyValue4#',				         
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
			  FROM     RequestTopic
			  WHERE    RequestId   = '#Object.ObjectKeyValue4#'		  			
			  AND      Topic         = '#Code#'			 
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
				  DELETE  FROM    RequestTopic
				  WHERE   RequestId     = '#Object.ObjectKeyValue4#'		  				 
				  AND     Topic         = '#Code#'				  		  
			    </cfquery>
			
				<cfquery name="InsertTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO RequestTopic
				 			 (RequestId,							
							  Topic, 							
							  TopicValue,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
				  VALUES 	 ('#Object.ObjectKeyValue4#',				            
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

