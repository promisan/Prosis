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

<cfajaximport tags="cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
	
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   	SELECT 	  L.Mission, 
	          L.ServiceItem,
			  S.Description AS ServiceItemDescription,
			  L.ServiceUsageSerialNo,
			  L.SelectionDateStart,
			  L.SelectionDateEnd,
			  L.Memo,
			  L.ActionStatus,
			  L.UsageLoadId
	FROM 	  ServiceItemLoad L
	INNER JOIN ServiceItem S ON S.Code = L.ServiceItem
	INNER JOIN ServiceItemMission M ON M.Mission = L.Mission AND M.ServiceItem = L.ServiceItem
	WHERE	  L.ActionStatus = '0' 
	AND		  M.EntityClass IS NOT NULL
	ORDER BY  S.ListingOrder, L.SelectionDateStart, L.SelectionDateEnd
</cfquery>

<cfset add = 0>

<cfinclude template = "../HeaderMaintain.cfm"> 

<cf_divscroll>

 <table width="90%" border="0" align="center">  	

<cfset columns = 8>
<tr><td>

	<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center" class="navigation_table">
	<tr><td height="10"></td></tr>

	<cfoutput>
	<tr><td height="50" colspan="#columns#" class="labellarge">Service Usage Upload</td></tr>
	<tr><td height="5"></td></tr>
	<tr class="labelmedium line">
	    <td width="3%"></td> 
		<td width="15%">Service</td>
		<td width="5%">Id</td>
		<td width="9%">Period Start</td>	
		<td width="9%">Period End</td>	
		<td width="24%">Remarks</td>
		<td width="20%" align="right">Transactions</td>
		<td width="15%" align="right">Amount</td>
	</TR>
	
	</cfoutput>
	
	<cfoutput query="SearchResult" group="mission">
	
			<tr><td height="5" colspan="#columns#"></td></tr>
			<tr class="line labelmedium"><td height="33" colspan="#columns#"><b>#mission#</td></tr>
			
			<cfoutput>
							
					<cfquery name="getData"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   	SELECT 	P.*					 
								 
						FROM 	ServiceItemLoad P
						WHERE 	P.ServiceItem	= '#serviceItem#'
						AND		P.Mission = '#mission#'
						AND		P.ServiceUsageSerialNo = '#ServiceUsageSerialNo#'
					</cfquery>
							
					<cfquery name="getBilUsage"
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT 	COUNT(1) AS Transactions,
								SUM(Amount) AS Amount
						FROM WorkOrderLineDetail
						WHERE ServiceItem = '#ServiceItem#'
						AND ServiceUsageSerialNo = '#ServiceUsageSerialNo#'
								
					</cfquery>

															
				    <TR class="line labelmedium navigation_row"> 
					<td></td>
					<td>#ServiceItemDescription# [#ServiceItem#]</td>
					<td>#ServiceUsageSerialNo#</td>
					<td>#dateformat(SelectionDateStart,'#CLIENT.DateFormatShow#')#</td>
					<td>#dateformat(SelectionDateStart,'#CLIENT.DateFormatShow#')#</td>
					<td>#Memo#</td>
					<td align="right">#numberformat(getBilUsage.Transactions,",")#</td>
					<td align="right">$ #numberformat(getBilUsage.Amount,"__,__.__")#</td>
				    </TR>
					
 					<tr><td colspan="#columns#">

 					 <cfset wflnk = "batchWorkflow.cfm">

 					    <input type="hidden" 
					          id="workflowlink_#GetData.UsageLoadId#" 
					          value="#wflnk#"> 
					 
					     <cfdiv id="#GetData.UsageLoadId#"  bind="url:#wflnk#?ajaxid=#GetData.UsageLoadId#"/> 					 
					  					 

					</td></tr> 
					<tr><td colspan="#columns#"><br></td>
					<tr><td colspan="#columns#" class="line"></td></tr>
					<tr><td colspan="#columns#"><br><br></td>
			</cfoutput>
					
	</cfoutput>
	
	</TABLE>

</td>
</tr>

</TABLE>

</cf_divscroll>