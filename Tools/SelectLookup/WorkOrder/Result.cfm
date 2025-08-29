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
<cfparam name="criteria" default="">

<cfif Form.Crit1_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="W.#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">

</cfif>

<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="W.#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>
	
<!---	

<cfif Form.ServiceDomain neq "">
   <cfif criteria eq "">
    <cfset criteria = "P.ServiceDomainClass = '#Form.ServiceDomain#'">
   <cfelse>
   <cfset criteria = "#criteria# AND P.ServiceDomainClass = '#Form.ServiceDomain#'">
   </cfif>
</cfif>

--->

<cfset link    = replace(url.link,"||","&","ALL")>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">


SELECT  count(*) as Total
FROM    Workorder W, Customer C, ServiceItem I
WHERE   W.CustomerId = C.CustomerId 
AND     W.Serviceitem = I.Code
		<cfif url.filter1value neq "">
		  AND #url.filter1# = '#url.filter1value#'
		</cfif>		
		<!---
		<cfif url.filter2value neq "">
		  AND #url.filter2# = '#url.filter2value#'
		</cfif>		
		--->
		
		<cfif url.filter2 eq "FinishedProduct">
		AND  WorkOrderId IN (SELECT WorkorderId FROM WorkorderLineItem WHERE WorkOrderId = W.Workorderid)	
		<cfelseif url.filter2value neq "">
		AND #url.filter1# = '#url.filter1value#'
		</cfif>		
		
		<cfif url.filter3value neq "">
		  AND #url.filter3# = '#url.filter3value#'
		</cfif>		
		
		<cfif criteria neq "">
		  AND #preserveSingleQuotes(criteria)# 	
		</cfif> 

<!--- active workorder --->
AND     W.ActionStatus = '1'			

</cfquery>

<cf_pagecountN show="22" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  TOP #last# W.WorkOrderId, 
          C.CustomerName, 
		  W.Reference, 
		  W.OrderDate, 
		  W.ActionStatus, 
		  I.Description AS Item

  FROM    Workorder W, Customer C, ServiceItem I
  WHERE   W.CustomerId = C.CustomerId 
  AND     W.Serviceitem = I.Code  
 
		<cfif url.filter1value neq "">
		  AND #url.filter1# = '#url.filter1value#'
		</cfif>		
		
		<cfif url.filter2 eq "FinishedProduct">
		  AND  WorkOrderId IN (SELECT WorkorderId FROM WorkorderLineItem WHERE WorkOrderId = W.Workorderid)		
		</cfif>		
	
		<cfif criteria neq "">
		  AND #preserveSingleQuotes(criteria)# 	
		</cfif> 

		 <!--- active workorder --->		
		  AND     W.ActionStatus = '1'			
		  
  ORDER BY CustomerName
	
</cfquery>

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<tr><td height="14" colspan="7">
							 
		 <cfinclude template="Navigation.cfm">
		 				 
	</td></tr>
	
	<tr class="fixlengthlist line labelmedium2">
		<td></td>
		<td>Customer</td>		
		<td>Item</td>
		<td>Order</td>
		<td>Date</td>
	</tr>
			
	<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr class="navigation_row fixlengthlist line labelmedium2">
		  
		    <td style="padding-left:4px" width="25" class="navigation_action" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#workorderid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">				  	
				<cf_img icon="edit">				
			</td>			
			<TD>#CustomerName#</TD>
			<td>#left(Item,30)#</td>
			<TD>#Reference#</TD>					
			<TD>#dateformat(OrderDate,client.dateformatshow)#</TD>		
		</tr>
				
	</cfif>	
			     
	</CFOUTPUT>
	
	
	<tr><td height="14" colspan="5">							 
		 <cfinclude template="Navigation.cfm">		 				 
	</td></tr>
	
	</TABLE>

</td></tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>