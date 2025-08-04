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

<!--- routine to transfer lines to another lines --->

<!--- input a table with the following fields

     WorkorderOrderId
	 WorkOrderLine
	 WorkOrderIdTo
	 PersonNo
	 DateEffective
	 
--->

<cfquery name="getSource" 
datasource="NovaWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  _ChangeRespBatchList
	WHERE WorkOrderLineTo is NULL
	ORDER BY WorkOrderId, WorkOrderLine	
</cfquery>	 

<cfloop query="getSource">

  <!--- check if workorder exists --->
    
	<cfquery name="check" 
	datasource="NovaWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  WorkOrderLine
		WHERE WorkOrderId   = '#workorderid#'
		AND   WorkOrderLine = '#workorderline#'
	</cfquery>	 
	
	<cfquery name="checkTo" 
	datasource="NovaWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  WorkOrder
		WHERE WorkOrderId = '#workorderidto#'		
	</cfquery>	 
	
	<cfif check.recordcount eq "1" and checkto.recordcount eq "1">
	
	    <!---
		<cfoutput>#workorderid# - #workorderline#</cfoutput>
		--->

    	<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
			method           = "ApplyTransfer" 
			requestid        = "{00000000-0000-0000-0000-04A0BCDB02BF}"	
			workorderid      = "#workorderid#"	
			workorderline    = "#workorderline#"	 
			workorderidTo    = "#workorderidto#" 
			effectivedate    = "#dateformat(DateEffective,CLIENT.DateFormatShow)#"
			personno         = "#PersonNo#"
			billing          = "Y"
			assets           = "Y"
			returnvariable   = "to">							   
						
		<cfquery name="getBatch" 
			datasource="NovaWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE _ChangeRespBatchList
				SET   Processed = getDate(), 
				      WorkOrderLineTo = '#to#'
				WHERE WorkOrderId   = '#workorderid#'
				AND   WorkOrderLine = '#workorderline#'  
		</cfquery>	  
							   
	</cfif>		   

</cfloop> 