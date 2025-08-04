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

<!--- check reference --->

<cfif url.reference neq "">
	
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder
			WHERE  Mission   = '#URL.Mission#'					  
			AND    ServiceItem = '#url.serviceitem#'
			AND    Reference = '#url.reference#'
	</cfquery>			
	
	<cfif workorder.recordcount gte "1">
	
	<font color="FF0000"><b><cf_tl id="Reference exists"></font>
	
	</cfif>
	
</cfif>	