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

<!--- apply the updated or new service --->

<cfquery name="checkExist"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Request R, WorkOrderService W, WorkOrderLine WL
	WHERE    R.ServiceDomain   = W.ServiceDomain
	AND      R.DomainReference = W.Reference
	AND      W.ServiceDomain   = WL.ServiceDomain 
	AND      W.Reference       = WL.Reference
	AND      WL.Operational    = 1
	AND      RequestId         = '#Object.ObjectKeyValue4#'			
</cfquery>	

<cfif checkexist.recordcount eq "0">
	
	<cfquery name="current"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     RequestWorkorder
			WHERE    RequestId = '#Object.ObjectKeyValue4#'	
	</cfquery>	
	
	<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	   method           = "ApplyService" 
	   requestid        = "#Object.ObjectKeyValue4#"	
	   workorderid      = "#current.workorderid#"	
	   workorderline    = "#current.workorderline#">	

<cfelse>
	
	<!--- it is a transfer so we update the actions first --->
	    
	<cfquery name="clear"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	DELETE FROM RequestWorkOrder
			WHERE  RequestId = '#Object.ObjectKeyValue4#'			
	</cfquery>	
			
	<cfquery name="current"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    TOP 1 *
	    FROM      WorkOrderLine WL
		WHERE     ServiceDomain = '#checkExist.ServiceDomain#'
		AND       Reference     = '#checkExist.DomainReference#'
		AND       Operational = 1  
		<!--- line is not already a parent of a new line for some reason --->
		AND       (WorkOrderLine NOT IN
                            (SELECT   ParentWorkOrderLine
                             FROM     WorkOrderLine
                             WHERE    ParentWorkOrderId = WL.WorkOrderId 
							 AND      ParentWorkOrderLine = ParentWorkOrderLine))
		ORDER BY ISNULL(DateExpiration, '9999-12-31') DESC, DateEffective DESC
		
	</cfquery>	
	
	
	<cfif current.recordcount eq "0">
	
		<table>
		   <tr>
		   <td class="labelit" align="center">
		    <font color="FF0000">Line has been processed already for another request, operation not allowed
		   </td>
		   </tr>
		</table>
		<cfabort>
	
	</cfif>
	
	<cfquery name="workorder"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     WorkOrder
		WHERE    WorkorderId   = '#current.workorderid#'	
	</cfquery>	
	    
	<cfquery name="addLink"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	INSERT INTO RequestWorkOrder
				(RequestId,WorkorderId,WorkOrderLine,WorkOrderAction)
			VALUES
				('#Object.ObjectKeyValue4#',	
				 '#current.workorderid#',			
				 '#current.workorderline#',
				 'Transfer')
	</cfquery>	
	
	<cfquery name="addTransferService"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	INSERT INTO RequestWorkOrderDetail
				(RequestId,WorkorderId,WorkOrderLine,Amendment,ValueFrom,ValueTo)
			VALUES (
			     '#Object.ObjectKeyValue4#',	
				 '#current.workorderid#',			
				 '#current.workorderline#',
				 'ServiceItem',
				 '#workorder.serviceitem#',
				 '#workorder.serviceitem#'				 
				 )
	</cfquery>	
	  
	<cfquery name="addTransferCustomer"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	INSERT INTO RequestWorkOrderDetail
				(RequestId,WorkorderId,WorkOrderLine,Amendment,ValueFrom,ValueTo)
			VALUES (
			     '#Object.ObjectKeyValue4#',	
				 '#current.workorderid#',			
				 '#current.workorderline#',
				 'Customer',
				 '#workorder.CustomerId#',
				 '#checkExist.CustomerId#'				 
				 )
	</cfquery>	
	
	  
	<cfquery name="addTransferPerson"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	INSERT INTO RequestWorkOrderDetail
				(RequestId,WorkorderId,WorkOrderLine,Amendment,ValueFrom,ValueTo)
			VALUES (
			     '#Object.ObjectKeyValue4#',	
				 '#current.workorderid#',			
				 '#current.workorderline#',
				 'PersonNo',
				 '#current.PersonNo#',
				 '#checkExist.PersonNoUser#'
				 )
	</cfquery>	
	
		
	<!--- trigger an asset transfer in case an existing device like a loaner --->
	
	<cfquery name="addTransferAsset"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	INSERT INTO RequestWorkOrderDetail
				(RequestId,WorkorderId,WorkOrderLine,Amendment,ValueFrom,ValueTo)
			VALUES (
			     '#Object.ObjectKeyValue4#',	
				 '#current.workorderid#',			
				 '#current.workorderline#',
				 'Asset',
				 'Y',
				 'Y'
				 )
	</cfquery>	
		
	<cfinclude template="RequestApplyAmendment.cfm">   
  
</cfif>
