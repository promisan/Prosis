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