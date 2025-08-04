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

<!--- log file --->

<table width="100%" height="100%">

<cfloop index="itm" list="1f,1p">

 	<cfquery name="Requisition" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    L.*, 
			          I.Description, 
					 					  
					  (  SELECT count(*) 
						 FROM RequisitionLineTravel
						 WHERE RequisitionNo = L.RequisitionNo						 
					  )  as IndTravel,			  
					  
					  (  SELECT count(*)
						 FROM Employee.dbo.PositionParentFunding
				         WHERE RequisitionNo = L.RequisitionNo
					  )  as IndPosition,
					  	
					  (  SELECT count(*)
				         FROM RequisitionLineService
				         WHERE RequisitionNo = L.RequisitionNo
			          )  as IndService,		
					  
					  (  SELECT count(*)
						 FROM   RequisitionLineTopic R, Ref_Topic S
						 WHERE  R.Topic = S.Code
					     AND    S.Operational   = 1
					     AND    R.RequisitionNo = L.RequisitionNo
					   ) as CountedTopics,	  	  	  					  
					  
					  Org.Mission, 
					  Org.MandateNo, 
					  Org.HierarchyCode, 
					  Org.OrgUnitName
			FROM      RequisitionLine L, 
			          ItemMaster I, 
					  Organization.dbo.Organization Org
			WHERE     L.OrgUnit = Org.OrgUnit
			AND       L.RequisitionNo IN (SELECT RequisitionNo 
			                              FROM   RequisitionLineAction 
										  WHERE  OfficerUserId = '#SESSION.acc#'
										  AND    ActionStatus = '#itm#'
										  AND    ActionDate > getdate()-1
										 )										
			AND       I.Code         =  L.ItemMaster   	
			AND       L.Period       = '#URL.Period#'	
			AND       Org.Mission    = '#URL.Mission#'			
			AND       RequestType   != 'Purchase'		
			AND       L.ActionStatus >= '#itm#'			
			ORDER BY  Reference, L.Created DESC	
								
						
			</cfquery>			
						
			<tr><td height="5"></td></tr>
			
			<tr class="labelmedium line">
				<td align="left" style="padding-left:10px;font-size:24px;font-weight:200">
				<cfif itm eq "1f">Moved to forecast
				<cfelse>Sent to reviewer
				</cfif>
				</td>
			</tr>
			
			<cfif Requisition.recordcount eq "0">
			
			<cfelse>
								
			<tr><td>
									
				<cfset mode = "Done">
				<cfset md = "Reference">								
				<cfinclude template="../Process/RequisitionListing.cfm">
				
			</td></tr>	
			
			</cfif>
			
</cfloop>			

</td></tr></table>