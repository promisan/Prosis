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
<cfoutput>
<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   RequestTask
		  WHERE  RequestId = '#URL.id#'
		  AND    TaskSerialNo = '#url.serialno#'		 
</cfquery>

<font face="Calibri" size="1">Tasked to:</font>
<font face="Calibri" size="3">
						
	<cfif get.TaskType eq "Purchase">
	
		<cfquery name="Source" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Organization.dbo.Organization
				  WHERE  OrgUnit = (SELECT OrgUnitVendor 
				                    FROM   Purchase 
									WHERE  PurchaseNo IN (SELECT PurchaseNo 
									                      FROM   PurchaseLine 
														  WHERE  RequisitionNo = '#get.sourceRequisitionno#'))									  
		</cfquery>
		
		#Source.OrgUnitName#
	
	<cfelse>		
				
							
		<cfquery name="Source" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   WarehouseLocation
				  WHERE  Warehouse = '#get.sourcewarehouse#'
				  AND    Location  = '#get.sourcelocation#'		  
		</cfquery>
	
		#get.sourcelocation# #source.Description#
							
	</cfif>		
	
</cfoutput>					
	
	