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

<cftransaction>

	<cfquery name="checkRequest" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM RequestWorkorder
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
	</cfquery>
	
	<cfquery name="checkItem" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * FROM WorkorderLineItem
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
	</cfquery>
	
	<cfif checkrequest.recordcount eq "0" and checkItem.recordcount eq "0">
		
		<cfquery name="DeleteLines" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE WorkOrderLine
				 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
		</cfquery>
		
		<cfquery name="DeleteHeader" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     DELETE WorkOrder
				 WHERE  WorkOrderId = '#URL.WorkOrderId#'			
		</cfquery>
		
		
		<cfoutput>
			<script>	    
				history.go()
			</script>
		</cfoutput>
		
	<cfelse>
	
		<cfoutput>
			<script>	    
				alert('Operation not allowed')
			</script>
		</cfoutput>	
	
	</cfif>

</cftransaction>

