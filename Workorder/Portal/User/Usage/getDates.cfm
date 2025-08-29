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
<cfset client.selectedmonth =  "#url.month#">

<cfif url.content eq "NonBillable">
	 <cfset dbselect = "NonBillable">
<cfelse>
	 <cfset dbselect = "">		
</cfif>
	
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
	  AND     R.isPlanned = 1  <!--- even if provisioning = 0, it is considered as planned --->		   						  	  
</cfquery>	

<!--- get a lits of all items to be shown under planned --->
<cfset plannedunits = quotedvaluelist(hasPlannedUnits.unit)>


<cfquery name="getDays" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">		
	SELECT    DISTINCT DAY(TransactionDate) AS Days

	FROM      WorkOrderLineDetail#dbselect# W
			  INNER JOIN ServiceItemUnit U ON W.ServiceItemUnit = U.Unit
			  INNER JOIN WorkOrder WO ON WO.WorkOrderId = W.WorkOrderId 
			  INNER JOIN ServiceItemLoad IL ON IL.Mission = WO.Mission AND IL.ServiceItem = W.ServiceItem AND IL.ServiceUsageSerialNo = W.ServiceUsageSerialNo  			  

	WHERE     W.WorkOrderId   = '#get.workorderid#' 
	AND       W.WorkOrderLine = '#get.workorderline#'
	AND       year(TransactionDate)  = '#url.year#'
	AND       month(TransactionDate) = '#url.month#'
	AND		  IL.ActionStatus = '1'
	
	<cfif dbselect eq "">
	AND       W.ActionStatus != '9'
	</cfif>
	
<!---
	AND		  U.Unit NOT IN (#preservesinglequotes(plannedunits)#)		
	--->
</cfquery>

<cfset detail = "0">

<cfoutput>

	<cfset DateOb=CreateDate(URL.year,URL.month,1)>
	<cfset days = daysInMonth(DateOb)> 
	<cfset url.day = "1">
	
	<table width="95%" style="border:1px solid c0c0c0;padding:1px" cellspacing="0" cellpadding="0">
	
		<tr class="labelitline" style="height:15px;background-color:e4e4e4">
		<td width="14%" height="15" align="center">S</td>
		<td width="14%" align="center">M</td>
		<td width="14%" align="center">T</td>
		<td width="14%" align="center">W</td>
		<td width="14%" align="center">T</td>
		<td width="14%" align="center">F</td>
		<td width="14%" align="center">S</td>
		</tr>
		
		<!--- Now we need to display the weeks of the month. --->
		<!---  The logic here is not too complex. We know that every 7 days we need to start a new table row. 
		The only hard part is figuring out how much we need to pad the first and last row. 
		To figure out how much we need to pad, we just figure out what day of the week the first of the month is. if it is wednesday, 
		then we need to pad for sunday,monday, and tuesday. 3 days. --->			
		<tr>
		<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
		<cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
		<cfset PADSTR=RepeatString("<td width=10 height=15>&nbsp;</td>",TOPAD)>
		<cfoutput>#PADSTR#</cfoutput>
		<cfset DW=TOPAD>
		<cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">
			
				<cfquery name="get" dbtype="query">
					SELECT    * 
					FROM      getDays 
					WHERE     Days = #x#
				</cfquery>			
				
	 			<cfif get.recordcount eq "0">
				
				 	<td align="center" class="label" bgcolor="white" height="100%" style="border-right:1px dotted d3d3d3;border-bottom:1px dotted d3d3d3" id="selectday" name="selectday">#X#</td>
				
				<cfelse>
				
					 <td bgcolor="ffffaf" class="label" align="center" style="padding;2px;cursor:pointer; border:1px solid silver;" 
					 onclick="dayselect('#url.workorderlineid#','#year#','#month#','#x#','#url.content#','','')" 
					 height="100%" id="selectday" name="selectday">#x#</td>
				
				</cfif>
					
		<cfset DW=DW + 1>
		<cfif DW EQ 7>
		</tr>
		<cfset DW=0>
		<cfif X LT DaysInMonth(DateOb)><tr></cfif>
		</cfif>
		</cfloop>
		<!--- Now we need to do a pad at the end, just to make our table "proper"  we can figure out how much the pad should be by examining DW --->
		<cfset TOPAD=7 - DW>
		<cfif TOPAD LT 7>
			<cfset PADSTR=RepeatString("<td width=10 height=15>&nbsp;</td>",TOPAD)>
			<cfoutput>#PADSTR#</cfoutput>
		</cfif>
		</tr>
		
	</table>
	
	
<!--- show the summary --->

<cfif url.mode neq "init">
	
	<cfif detail eq "1">
	
		<script>	
		   _cf_loadingtexthtml='';	 
		   showusage('#url.workorderlineid#','#url.year#','#url.month#','','#url.content#','#client.selectedmonth#');
		   // showusageDetail ('#url.content#','#url.workorderlineid#','#url.year#','#url.month#','');
		</script>
		
	<cfelseif detail eq "0">
	
		<script>	
		 _cf_loadingtexthtml='';		
		 ColdFusion.navigate('ServiceLayoutBody.cfm?workorderlineid=','body');		
		 showusage('#url.workorderlineid#','#url.year#','#url.month#','','#url.content#','#client.selectedmonth#');		 	
		</script>  
		
	</cfif>

</cfif>

</cfoutput>
