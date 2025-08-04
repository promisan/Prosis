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

<cfquery name="Status" 
  datasource="AppsWorkorder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   E.EntityStatus, 
	         E.StatusDescription, 
			 
			 (SELECT count(*)  
	              FROM   Request R
				  WHERE  R.Mission  = '#url.mission#' 	
				  AND  R. Requestid IN (
				                       SELECT  Requestid 
				                       FROM    RequestLine RL
									   WHERE   RL.ServiceItem IN (SELECT Code 
											                      FROM   ServiceItem 
															      WHERE  ServiceDomain = '#url.domain#')
									   AND    Requestid = R.RequestId

									   UNION
									   
									   SELECT  Requestid 
				                       FROM    RequestWorkorderDetail RL
									   WHERE   Amendment = 'Serviceitem'
									   AND     ValueFrom IN (SELECT Code 
											                      FROM   ServiceItem 
															      WHERE  ServiceDomain = '#url.domain#')
									   AND    Requestid = R.RequestId						  
								  	  )		
				   					  					 
				  AND  R.ActionStatus = E.EntityStatus
						
					<cfif getAdministrator(url.mission) eq "0">				 
									
			
						AND  ( 
						
							     <!--- requester if he has access to that request unit as requester --->
							
								 R.OrgUnit IN (SELECT OrgUnit 
						                       FROM   Organization.dbo.OrganizationAuthorization 
											   WHERE  UserAccount = '#SESSION.acc#'
											   AND    Role = 'ServiceRequester'
											 )
											 
								OR 
								
								(
				
								R.RequestId IN (
								
				                SELECT RequestId 
	                       		FROM   RequestLine 
								WHERE  ServiceItem IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#' 
													 )
								UNION
								
								SELECT RequestId 
	                       		FROM   RequestWorkOrderDetail
								WHERE  Amendment = 'ServiceItem' 
								AND    ValueFrom IN (
								                      SELECT ClassParameter
									                  FROM   Organization.dbo.OrganizationAuthorization
											          WHERE  UserAccount = '#SESSION.acc#'
													  AND    Role        = 'WorkOrderProcessor'
													  AND    Mission     = '#url.mission#'
													 )								
													 
							     )
							   
							  )		
							  
							  )		 
										
					</cfif>			 											 
									 
			 ) AS counted
				 
    FROM     Organization.dbo.Ref_EntityStatus E
    WHERE    E.EntityCode = 'WrkRequest'	
    GROUP BY E.EntityStatus, E.StatusDescription
	ORDER BY E.EntityStatus, E.StatusDescription
  </cfquery>
  
  <script language="JavaScript">
  
  <cfoutput query="Status">
	  document.getElementById('treestatus_#entityStatus#').innerHTML    = "#counted#"		
  </cfoutput>
  
  </script>
  