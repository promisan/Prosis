
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
	
	<tr>
		<td></td>
		<td class="labelit">Customer</td>		
		<td class="labelit">Item</td>
		<td class="labelit">Order</td>
		<td class="labelit">Date</td>
	</tr>
	<tr><td colspan="5" class="linedotted"></td></tr>
		
	<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr class="navigation_row">
		  
		    <td style="padding-left:4px" width="25" class="navigation_action" onclick="ColdFusion.navigate('#link#&action=insert&#url.des1#=#workorderid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">				  	
				<cf_img icon="edit">				
			</td>			
			<TD class="labelit" width="30%" style="padding-left:3px;padding-right:3px">#CustomerName#</TD>
			<td class="labelit" width="30%" style="padding-left:3px">#left(Item,30)#</td>
			<TD class="labelit" width="80" style="padding-left:3px;padding-right:3px">#Reference#</TD>					
			<TD class="labelit" width="80" style="padding-left:3px">#dateformat(OrderDate,client.dateformatshow)#</TD>		
		</tr>
		<tr><td colspan="5" class="linedotted"></td></tr>	
		
	</cfif>	
			     
	</CFOUTPUT>
	
	
	<tr><td height="14" colspan="5">							 
		 <cfinclude template="Navigation.cfm">		 				 
	</td></tr>
	
	</TABLE>

</td></tr>
 
</table>

<cfset AjaxOnLoad("doHighlight")>