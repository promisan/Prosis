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

<!--- show the relevant months --->

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    * 
	FROM      WorkorderLine 
	WHERE     WorkorderLineId = '#url.workorderlineid#'
</cfquery>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT    * 
		FROM      Workorder 
		WHERE     WorkorderId = '#get.workorderid#'
</cfquery>

<cfquery name="hasPlannedUnits"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#"> 						  
	  SELECT  DISTINCT U.Unit		
	  FROM    WorkOrderLineBillingDetail BD INNER JOIN
              WorkOrderLineBilling B ON BD.WorkOrderId = B.WorkOrderId AND BD.WorkOrderLine = B.WorkOrderLine AND 
              BD.BillingEffective = B.BillingEffective INNER JOIN
              WorkOrderLine L ON B.WorkOrderId = L.WorkOrderId AND B.WorkOrderLine = L.WorkOrderLine INNER JOIN		  
			  ServiceItemUnit U ON BD.ServiceItem = U.ServiceItem AND BD.ServiceItemUnit = U.Unit					  		   
	  WHERE   L.WorkOrderId   = '#get.workorderid#'	 
      AND     L.WorkOrderLine = '#get.workorderline#'	
	  UNION
	  SELECT  DISTINCT U.Unit
	  FROM    ServiceItemUnit U, Ref_UnitClass R
	  WHERE   U.ServiceItem = '#workorder.serviceitem#'
	  AND     R.Code = U.UnitClass
	  AND     R.isPlanned = 1  <!--- even if provisionin = 0, it is considered as planned --->		   						  	  
</cfquery>	

<!--- get a lits of all items to be shown under planned --->
<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>

<cfif url.content eq "NonBillable">
	 <cfset dbselect = "NonBillable">
<cfelse>
    <cfset dbselect = "">		
</cfif>

<cfquery name="getMonth" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    DISTINCT MONTH(TransactionDate) AS Month
	FROM      WorkOrderLineDetail#dbselect# D
    	INNER JOIN ServiceItemUnit U ON D.ServiceItem = U.ServiceItem and D.ServiceItemUnit = U.Unit		
	WHERE     WorkOrderId = '#get.workorderid#' 
	AND       WorkOrderLine = '#get.workorderline#'
	AND       year(TransactionDate) = '#url.year#'
	ORDER BY  Month DESC
</cfquery>

	<cfset monthStart =1>
	<cfif url.year eq Year(now())>
		<cfset monthEnd = Month(now())>
	<cfelse>
		<cfset monthEnd = 12>
	</cfif>
	

<cfoutput>

<!---
	<cfparam name="client.selectedmonth" default="#getMonth.month#">
--->
<!---
	<cfif client.selectedmonth eq "0" >
		<cfset client.selectedmonth = getMonth.month>	
	</cfif>			
	
	<cfset setMonth = getMonth.month>
--->
	<cfif client.selectedmonth eq "0" or client.selectedmonth eq "" >
	 <!---or (client.selectedmonth eq month(now()) and url.year neq year(now())) >--->
		<cfset client.selectedmonth = monthEnd>	
		<!---<cfset client.selectedmonth = getMonth.Month>--->
	</cfif>			

	<cfset setMonth = monthEnd>

	<select name="selectmonth" id="selectmonth" class="regularxl" style="width:100%"
	   onchange="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/getDates.cfm?mode=select&content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month='+this.value,'boxdates');">
	   <!---
	   <cfloop query="getMonth">	   
	     <option value="#Month#" <cfif client.selectedmonth eq getMonth.month>selected</cfif>>#MonthAsString(month)#</option>
		 <cfif client.selectedmonth eq getMonth.Month>
		   <cfset setMonth = getMonth.Month>
		 </cfif>
	   </cfloop>
	   --->	

	   <cfloop index = "idxMonth" from = "1" to = #monthEnd#>
	     <option value="#idxMonth#" <cfif client.selectedmonth eq idxMonth>selected</cfif>>#MonthAsString(idxMonth)#</option>
		 <cfif client.selectedmonth eq idxMonth>
		   <cfset setMonth = idxMonth>
		 </cfif>
	   </cfloop>	   
   
	</select>
	
	<cfif client.selectedmonth neq setMonth>
		<cfset client.selectedmonth = setMonth>
	</cfif>

	<input type="hidden" id="yearselected"  value="#url.year#">
	<input type="hidden" id="monthselected" value="#setMonth#">
	<input type="hidden" id="dayselected"   value="">
	
	<script>
		ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/getDates.cfm?mode=#url.mode#&content=#url.content#&workorderlineid=#url.workorderlineid#&year=#url.year#&month=#setMonth#','boxdates')		
	</script>
	
</cfoutput>


