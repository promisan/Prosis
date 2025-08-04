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
<!--- handles the workorder lines for amendment which means

change of service : porting
change of responsibility
termination (end) -

--->

<!--- retrieve the line of the request which has just one record for this --->

<cfquery name="get"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT   *
	FROM     Request
	WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>	

<cfquery name="getOrder"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT   *
	FROM     RequestWorkOrder
	WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfif getOrder.recordcount eq "0">

  <table align="center"><tr><td class="labelit"><font color="FF0000">Problem as the service line could NOT be located.</font></td></tr></table>
  <cfabort>

<cfelse>
	
	<cfquery name="Current" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   L.*, 
			         W.CustomerId, 
				     W.ServiceItem
			FROM     Workorder W, WorkOrderLine L
			WHERE    W.Workorderid   = L.WorkOrderId
			AND      L.WorkorderId   = '#getOrder.workorderid#'			
			AND      L.Workorderline = '#getOrder.workorderline#'
	</cfquery>  
	
	<!--- retrieve the move of asset pointer --->
	
	<cfquery name="getAsset"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	SELECT   *
			FROM     RequestWorkOrderDetail
			WHERE    RequestId     = '#Object.ObjectKeyValue4#'	
			AND      WorkorderId   = '#getOrder.workorderid#'			
			AND      Workorderline = '#getOrder.workorderline#'
			AND      Amendment = 'Asset'
	</cfquery>		
	
	<!--- this is determined a termination --->
		
	<cfinvoke component    = "Service.Process.Workorder.PostWorkorder"  
		  method           = "ApplyTermination"   
		  requestid        = "#Object.ObjectKeyValue4#"	
		  effectivedate    = "#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
		  workorderid      = "#current.workorderid#"	
		  workorderline    = "#current.workorderline#">	
		  
</cfif>		  
