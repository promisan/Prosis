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

<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
   	  WHERE Mission = '#URL.Mission#' 	 
</cfquery>

<cfquery name="Status" 
  datasource="AppsWorkorder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   E.EntityStatus, 
	         E.StatusDescription, 
			 
				 (SELECT count(*)  
	              FROM   Request R
				  WHERE  R.Mission  = '#url.mission#' 	
				  AND    R.Requestid IN (
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
							  
					<cfelse>
					
					 	  <!--- no filtering ---> 
										
					</cfif>			 					 
										 
				 ) AS counted
				 
    FROM     Organization.dbo.Ref_EntityStatus E
    WHERE    E.EntityCode = 'WrkRequest'	
    GROUP BY E.EntityStatus, E.StatusDescription
	ORDER BY E.EntityStatus, E.StatusDescription
  </cfquery>
  
<cfif status.recordcount eq "0">

<table width="100%" height="100%" class="formpadding">
 				
	<tr><td colspan="2" align="center" height="60" class="labelit">No records</td></tr>
	
	<cfabort>

<cfelse>

<table width="100%" height="100%" class="formpadding">

	<cfinvoke component = "Service.Access"  
	   method           = "ServiceRequester" 
	   mission          = "#Param.TreeCustomer#"  
	   returnvariable   = "access">		   

    <cfoutput>	 
		  		
	<cfif access eq "EDIT" or access eq "ALL">		
	
      <tr>
	  <td height="20" colspan="2" class="labelmedium">
	  	<a href="javascript:addworkorderrequest('#url.mission#','#url.domain#','0','','');javascript:showrequest('#url.mission#','#url.domain#','#status.entitystatus#','')">
		  <cf_tl id="Add New Request">
		</a>
	  </td>
	  </tr>			  
	  <tr><td height="6"></td></tr>											
	  
	</cfif>	
		
	</cfoutput>
	
	<cfoutput>
		<tr class="hide">
		<td id="treerefresh" onclick="ptoken.navigate('#SESSION.root#/System/Organization/Customer/CustomerSearchRequestTreeRefresh.cfm?mission=#url.mission#&domain=#url.domain#','treerefresh')">xxx</td>
		</tr>		
	</cfoutput>
			
	<tr><td colspan="2" valign="top">   
			
		<cf_UItree
			id="root"
			title="<span style='font-size:16px;color:gray;padding-bottom:1px'>Filter and views</span>"	
			expand="Yes"
			Root="No">		
					
			<cfoutput query="status">
			
				<cf_UItreeitem value="#entitystatus#"
			        display="<span style='font-size:14px' class='labelit'>#StatusDescription# (<a id='treestatus_#entityStatus#'>#counted#</a>)</span>"
					parent="root"						
					target="right"
					href="javascript:showrequest('#url.mission#','#url.domain#','#entitystatus#','')">				
															
						<cfquery name="RequestType" 
						  datasource="AppsWorkorder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						    SELECT   R.Code, 
									 R.Description
						    FROM     Request AS S INNER JOIN
						             Ref_Request AS R ON S.RequestType = R.Code 
							WHERE    S.ServiceDomain = '#url.domain#'												
						    AND      S.ActionStatus  = '#entitystatus#'							
						    GROUP BY R.Code, R.Description
							ORDER BY R.Code, R.Description
						 </cfquery>
  
  						 <cfset st= entitystatus>
				
				         <cfloop query="RequestType">
						 
						 		<cf_UItreeitem value="#st#_#code#"
						        display="<span style='font-size:13px' class='labelit'>#Description#</span>"
								parent="#st#"						
								target="right"
								href="javascript:showrequest('#url.mission#','#url.domain#','#st#','#code#')">					
												
						 </cfloop>				
							
			</cfoutput>
			
		</cf_UItree>		
		
	</td></tr>

</table>

</cfif>  