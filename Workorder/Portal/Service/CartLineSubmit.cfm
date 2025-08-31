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
 <cfquery name="Rate" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT  * 
		  FROM    ServiceItemUnitMission
		  WHERE   ServiceItem = '#URL.ServiceItem#'
		  AND     ServiceItemUnit = '#Form.ServiceItemUnit#'
		  AND     Mission = '#URL.Mission#' 
   	</cfquery>

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE  Cart
		  SET     ServiceItemUnit = '#Form.ServiceItemUnit#',
 		          Reference       = '#Form.Reference#',
				  Currency        = '#Rate.Currency#',
				  Amount          = '#Rate.StandardCost#'				 
		  WHERE   Cartid = '#URL.ID2#'			 
   	</cfquery>
			
	<cfset url.id2 = "new">
    <cfinclude template="CartLine.cfm">		
		
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="AppsWorkOrder" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Cart
	         (Mission,
			 ServiceItem,
			 ServiceItemUnit,
			 Reference,
			 Currency,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.Mission#',
		      '#url.serviceitem#',
			  '#Form.ServiceItemUnit#',
			  '#Form.Reference#',
			  '#Rate.Currency#',
			  '#Rate.StandardCost#',
			  '#Client.acc#',
			  '#client.last#',
			  '#client.first#') 
	</cfquery>
	
	<cfset url.id2 = "new">
    <cfinclude template="CartLine.cfm">		
	   	
</cfif>
 	

  
