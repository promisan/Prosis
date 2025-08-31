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
<cfquery name="get" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT W.*	
     FROM   WorkOrderLine W, RequestWorkorder R
	 WHERE  R.Requestid     = '#url.requestid#'			
	 AND    W.WorkorderId   = R.WorkOrderId	     
	 AND    W.WorkOrderLine = R.WorkOrderLine			 		
</cfquery>

<cfif get.recordcount gte "1">
	
	<cfquery name="wo" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT *	
	     FROM   WorkOrder W,
				ServiceItem S
		 WHERE  W.ServiceItem = S.Code		
		 AND    W.Workorderid = '#get.workorderid#'		 	 		
	</cfquery>
	
	<cfquery name="domain" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT *	
	     FROM   Ref_ServiceItemDomain 
		 WHERE  Code = '#wo.servicedomain#'				 	 		
	</cfquery>
		
	<cfoutput>
	   <a href="javascript:editworkorderline('#get.workorderlineid#')">
	   <font color="0080FF" size="2"><b>		  
	   <cf_stringtoformat value="#get.reference#" format="#domain.DisplayFormat#">	
		#val#   
	   </font>
	   </a>
	</cfoutput>   
	
<cfelse>

	<cf_compression>	 

</cfif>  

