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
<cfparam name="url.year"   default="#year(now())#">
<cfparam name="url.month"  default="0">

<cfloop index="mt" from="1" to="12">
	<cfif left(monthasstring(mt),3) eq url.month>
		 <cfset url.month = mt>
	</cfif> 
</cfloop> 
<!--- 
<cfif url.month gt month(now())>
	 <cfset url.year = url.year-1> 
</cfif> --->

<cfset vdays = DaysInMonth(CreateDate(url.year,url.month,1))>

	<cfset str = CreateDate(url.year, url.month, "1")>
	<cfset end = CreateDate(url.year,url.month,daysinmonth(str))>	


<!--- get all lines for this service --->

<cfquery name="SelectLines"
   datasource="AppsWorkOrder"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">

   SELECT     DISTINCT C.WorkorderId,
              C.WorkorderLine as Line, 
			  L.Reference,
			  D.DisplayFormat
   FROM       WorkOrderLineDetail C INNER JOIN
	            WorkorderLine L ON C.WorkOrderid = L.Workorderid and C.WorkOrderLine = L.WorkorderLine INNER JOIN
				ServiceItem S ON C.ServiceItem = S.Code INNER JOIN
				 Ref_ServiceItemDomain D ON D.Code = S.ServiceDomain
   WHERE      C.TransactionDate >= #str# 
   AND        C.TransactionDate <= #end#	
   AND        C.ServiceItem = '#url.serviceitem#'	
   AND        L.PersonNo    = '#client.personno#'	   
</cfquery>

<table width="98%" cellspacing="0" cellpadding="0" align="center">
<cfset cnt = "0">
  <cfoutput query="selectlines">
  <cfset cnt = cnt+1>
  
    <cfset url.scope = "summary">
    <cfset url.mode  = "all">
    <cfset url.workorderid   = workorderid>
	<cfset url.workorderline = line>
	
	
	<cfset end = DateAdd("h","23", end)>
	<cfset end = DateAdd("n","59", end)>
	<cfset end = DateAdd("s","59", end)>
				
	<cfquery name="LineCharges"
	   datasource="AppsWorkOrder"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">	

	   SELECT   C.ServiceItem, 
	            C.ServiceItemUnit, 
				C.Amount, 
				UnitDescription, 
				U.BillingMode,
	   			(SELECT COUNT(1)
					FROM WorkOrderLineDetail D
					WHERE D.WorkorderId = C.WorkorderId
					AND   D.WorkorderLine = C.WorkorderLine
					AND   D.TransactionDate > = #str#
					AND   D.TransactionDate <= #end#
					AND	  D.ActionStatus != '9'
					AND D.ServiceItemUnit = C.ServiceItemUnit) AS DetailCount
	   FROM     WorkOrderLineDetail AS C INNER JOIN
	            ServiceItemUnit U ON C.ServiceItem = U.ServiceItem AND C.ServiceItemUnit = U.Unit INNER JOIN
	            WorkorderLine L ON C.WorkOrderid = L.Workorderid and C.WorkOrderLine = L.WorkorderLine
	   WHERE  	C.WorkOrderId   = '#url.workorderid#'		
	   AND    	C.WorkOrderLine = '#url.workorderline#'	
	   AND		C.ActionStatus != '9'
 	   AND      C.TransactionDate >= #str#	 
	   AND      C.TransactionDate <= #end#	  	
	   
	</cfquery>
	
	<cfif LineCharges.recordcount gte "1">

		<cfquery name="LineChargesSummary" dbtype="query">
			SELECT ServiceItem, 
			       ServiceItemUnit, 
				   UnitDescription, 
				   BillingMode, 
				   SUM(Amount) as Amount, 
				   SUM(DetailCount) AS DetailCount
			FROM LineCharges
			GROUP BY ServiceItem, ServiceItemUnit, UnitDescription, BillingMode
		</cfquery>
			
		<tr><td height="5"></td></tr>
		<tr><td height="27" class="labelmedium" size="3" style="padding-left:20px">
			<cf_stringtoformat value="#reference#" format="#DisplayFormat#"><b>#val#</b>
		    </td>
		</tr>
		
		<tr>
		<td colspan="2" align="center" style="padding-top:3px">
		
			<table width="100%" cellspacing="0" cellpadding="1" align="center" style="border:0px dotted silver">

				<cfloop query="LineChargesSummary">
				
				<cfset cnt = cnt+1>
					<tr>
						<td width="10px"></td>
						<td id="itm#cnt#" name="itm#cnt#" <cfif DetailCount gt "1">class="itemregular" onclick="itmselect('itm#cnt#'); detshow('det#cnt#');" </cfif>>
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>
									<td width="10px"></td>
									<td width="70%" class="labelit">#UnitDescription# </td>
									<td align="right" class="labelit" width="120" style="padding-right:15px">#numberformat(amount,"__,__.__")#</td>
								</tr>
								
							</table>
						</td>
					</tr>
					<tr>
						<td width="10px"></td>
						<td id="det#cnt#" name="det#cnt#"  style="display:none">
						
							<cfset url.ServiceItemUnit ="#ServiceItemUnit#"> 
							<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Charges/ChargesUsageDetail.cfm">
							
						</td>
					</tr>
					<tr><td colspan="2" height="1px"></td></tr>
					
				</cfloop>	
				
			</table>
		
		</td>
		</tr>	
	
	</cfif>
  
	
</cfoutput>
</table>