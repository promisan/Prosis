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
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		
		<tr><td>
					
		<cfswitch expression="#URL.Sort#">
	
			<cfcase value="Line">
			
			<!--- create selection lines --->
	
				<cfquery name="Requisition" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    L.*, 
				          I.Description AS Description, 
						   (SELECT COUNT(*) 
						    FROM RequisitionLineService 
							WHERE requisitionNo = L.Requisitionno) as Details,
						  Org.Mission AS Mission, 
				          Org.MandateNo AS MandateNo, 
						  Org.HierarchyCode AS HierarchyCode, 
						  Org.OrgUnitName AS OrgUnitName, 
						  (SELECT PurchaseNo FROM PurchaseLine WHERE RequisitionNo = L.RequisitionNo) as PurchaseNo,
	                    
							(SELECT COUNT(*)
							  FROM RequisitionLineTopic RLT INNER JOIN Ref_Topic T ON RLT.Topic = T.Code
							  WHERE RequisitionNo = L.Requisitionno
							  AND T.TopicClass    = 'Requisition') as Topics						   
				FROM      RequisitionLine L INNER JOIN
	                      Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit INNER JOIN
	                      ItemMaster I ON L.ItemMaster = I.Code 
				WHERE     L.ActionStatus NOT IN ('9','0z')
				AND       L.JobNo  = '#URL.ID1#' 
				<!---
				AND       (L.Period = '#URL.Period#')
				--->
				ORDER BY  Org.Mission, 
				          Org.MandateNo, 
						  Org.HierarchyCode, 
						  L.RequisitionNo 		
						  	
				</cfquery>
								
				<cfset fun = "job">		
				<cfinclude template="QuotationListing.cfm"> 
								
			</cfcase>
			
			<cfdefaultcase>
			
				<cfset fun = "job">
				<cfinclude template="VendorListing.cfm">
									
			</cfdefaultcase>
				
		</cfswitch>
				
		</td></tr>
		
	</table>