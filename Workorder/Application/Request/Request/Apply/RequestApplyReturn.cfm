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
		WHERE    RequestId = '#Object.ObjectKeyValue4#'	
</cfquery>		

<cfquery name="getPersonFrom"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    	SELECT   *
		FROM     RequestWorkOrderDetail
		WHERE    RequestId      = '#Object.ObjectKeyValue4#'			
		AND      Amendment      = 'PersonNo'
</cfquery>	

<cfif get.DateExpiration neq "" AND
      get.DateExpiration gt get.DateEffective>
	  
	<cfset dt = "#dateformat(get.DateExpiration,CLIENT.DateFormatShow)#">  
 
<cfelse>

	<cfset dt = "#dateformat(now(),CLIENT.DateFormatShow)#">
	
</cfif>

<!--- Safeguard applied 10/4/2012 --->

<cfif getOrder.workorderidto neq "">

	<cfset returnfrom      =  getOrder.WorkorderIdTo>
	<cfset returnfromline  =  getOrder.WorkorderLineTo>
	<cfset returnto        =  getOrder.WorkorderId>

<cfelse>

	<cfset returnfrom      =  getOrder.WorkorderId>
	<cfset returnfromline  =  getOrder.WorkorderLine>
	
	<cfquery name="getOrder"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    	SELECT   ParentWorkOrderId 		         
			FROM     WorkOrderLine
			WHERE    WorkOrderId   = '#getOrder.workorderid#'	
			AND      WorkOrderLine = '#getOrder.workorderline#'	
	</cfquery>		
	
	<cfset returnto        =  getOrder.ParentWorkOrderId>

</cfif>
		
<cfif returnto eq "">	

	<font face="Calibri" size="3" color="FF0000">There is no current return workorder available</font>

<cfelse>
	
	<!--- return to old order --->
	
	<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	   method           = "ApplyTransfer" 
	   mode             = "return"
	   requestid        = "#get.requestid#"	
	   workorderid      = "#returnfrom#"	
	   workorderline    = "#returnfromline#"	 
	   workorderidTo    = "#returnto#" 
	   effectivedate    = "#dt#"
	   personno         = "#getPersonFrom.ValueFrom#">	
   
</cfif>   