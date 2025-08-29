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
<cfif url.mode eq "Usage">

   <cfparam name="url.content" default="">

    <cfif url.content eq "NonBillable">
	    <cfset dbselect = "NonBillable">
	<cfelse>
	    <cfset dbselect = "">		
	</cfif>
	
	<script>
		document.getElementById('calendar').className = "regular"
	</script>	
	
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
		  FROM    WorkOrderLineBillingDetail#dbselect# BD INNER JOIN
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
	<cfset billableUsage = "0">
	<cfset NonbillableUsage = "0">	
	
	<cfquery name="getBillableCount" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">	
		SELECT count(*) as Billable
		FROM      WorkOrderLineDetail D
		WHERE     WorkOrderId = '#get.workorderid#' 
		AND       WorkOrderLine = '#get.workorderline#'		
	</cfquery>	
	
	<cfquery name="getNonBillableCount" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">	
		SELECT count(*) as NonBillable
		FROM      WorkOrderLineDetailNonBillable D
		WHERE     WorkOrderId = '#get.workorderid#' 
		AND       WorkOrderLine = '#get.workorderline#'		
	</cfquery>		
	
	<cfset billableUsage = getBillableCount.Billable>
	<cfset NonbillableUsage = getNonBillableCount.NonBillable>	
<!---			
	<cfquery name="getYear" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
		SELECT    DISTINCT YEAR(TransactionDate) AS Year
		FROM      WorkOrderLineDetail#dbselect# D
		WHERE     WorkOrderId = '#get.workorderid#' 
		AND       WorkOrderLine = '#get.workorderline#'
		ORDER BY  Year DESC
	</cfquery>
	
	<!--- if there is no billable usage try with non-billable usage -> RTU mostly non-billable --->	
	<cfif getYear.recordcount eq "0" and dbselect eq "">
	
		<cfset dbselect = "NonBillable">
		<cfset url.content = "NonBillable">	

		<cfquery name="getYear" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#"
			password="#SESSION.dbpw#">		
			SELECT    DISTINCT YEAR(TransactionDate) AS Year
			FROM      WorkOrderLineDetail#dbselect# D
			WHERE     WorkOrderId = '#get.workorderid#' 
			AND       WorkOrderLine = '#get.workorderline#'
			ORDER BY  Year DESC
		</cfquery>	

	</cfif>	
--->
	<!---replace the above with the below. If there is no billable usage in the current year it now shows the current year --->
	<cfquery name="getYear" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">		
		SELECT    DISTINCT YEAR(TransactionDate) AS Year
		FROM      WorkOrderLineDetail D
		WHERE     WorkOrderId = '#get.workorderid#' 
		AND       WorkOrderLine = '#get.workorderline#'
		UNION 
		SELECT    DISTINCT YEAR(TransactionDate) AS Year
		FROM      WorkOrderLineDetailNonBillable 
		WHERE     WorkOrderId = '#get.workorderid#' 
		AND       WorkOrderLine = '#get.workorderline#'
		
		ORDER BY  Year DESC
	</cfquery>
		
	<script>
	   document.getElementById('calendar').className = "hide"
	</script>	
	
	<cfif getYear.Year neq "">
	
	<cfoutput>
	<table cellspacing="0" cellpadding="0">
	<tr>
	<td style="padding-left:0px">
			<select name="selectcontent" id="selectcontent" class="regularxl" onchange="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/getMonth.cfm?mode=usageselect&content='+this.value+'&workorderlineid=#url.workorderlineid#&year='+document.getElementById('selectyear').value,'boxmonth')">
				<cfif billableUsage gt "0"><option value="" <cfif dbselect eq "">selected</cfif>>Billable</option></cfif>
				<cfif NonbillableUsage gt "0"><option value="NonBillable" <cfif dbselect eq "NonBillable">selected</cfif>>Not Billable</option></cfif>
			 </select>		
	</td>	
	<td style="padding-left:2px">	
			<select name="selectyear" id="selectyear" class="regularxl" onchange="ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/getMonth.cfm?mode=select&content='+document.getElementById('selectcontent').value+'&#url.content#&workorderlineid=#url.workorderlineid#&year='+this.value,'boxmonth')">
				<cfloop query="getYear">
					<option value="#Year#">#Year#</option>
				</cfloop>
			</select>
		
	</td></tr>
	</table>
	
	<!--- initial populate --->
	
	<script>
	    document.getElementById('calendar').className = "regular"
		ColdFusion.navigate('#SESSION.root#/workorder/portal/user/usage/getMonth.cfm?mode=init&content=#url.content#&&workorderlineid=#url.workorderlineid#&year=#getYear.year#','boxmonth')
	</script>
	</cfoutput>
	
	</cfif>
	
</cfif>

