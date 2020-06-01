
<cfparam name="criteria" default="">
	
<cfif Form.Crit2_Value neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
	    Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">

</cfif>

<cfif Form.ServiceDomain neq "">
   <cfif criteria eq "">
    <cfset criteria = "P.ServiceDomainClass = '#Form.ServiceDomain#'">
   <cfelse>
   <cfset criteria = "#criteria# AND P.ServiceDomainClass = '#Form.ServiceDomain#'">
   </cfif>
</cfif>


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
FROM    Workorder W, WorkOrderLine P, Customer C, ServiceItem I
WHERE   W.Workorderid = P.WorkorderId  
AND     W.CustomerId = C.CustomerId 
AND     W.Serviceitem = I.Code
		<cfif url.filter1value neq "">
		  AND #url.filter1# = '#url.filter1value#'
		</cfif>		
		<cfif url.filter2value neq "">
		  AND #url.filter2# = '#url.filter2value#'
		</cfif>		
		<cfif url.filter3value neq "">
			  AND #url.filter3# = '#url.filter3value#' 
			</cfif>		
		<cfif criteria neq "">
		  AND #preserveSingleQuotes(criteria)# 	
		</cfif> 
AND     P.Reference > '' 
AND     P.DateEffective = (
                         SELECT  MAX(DateEffective)
                         FROM    WorkOrderLine
                         WHERE   Reference     = P.Reference
						 AND     ServiceDomain = I.ServiceDomain  	
						)
AND     (P.DateExpiration > getDate() or P.DateExpiration is NULL)		
AND     P.Operational = 1			

</cfquery>

<cf_pagecountN show="25" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="SearchResult" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# P.*, CustomerName, S.Description,   
	        		
			(SELECT PersonNo FROM Employee.dbo.Person WHERE PersonNo = P.PersonNo)   as PersonNo,
			(SELECT IndexNo FROM Employee.dbo.Person WHERE PersonNo = P.PersonNo)    as IndexNo,
			(SELECT FirstName+' '+LastName FROM Employee.dbo.Person WHERE PersonNo = P.PersonNo) as Name

	FROM    Workorder W, 
	        WorkOrderLine P, 
			WorkOrderService S,
			Customer C, 
			ServiceItem I
	WHERE   W.Workorderid = P.WorkorderId  
	AND     W.CustomerId = C.CustomerId 
	AND     W.Serviceitem = I.Code
	AND     S.ServiceDomain = P.ServiceDomain
	AND     S.Reference = P.Reference
			<cfif url.filter1value neq "">
			  AND #url.filter1# = '#url.filter1value#' 
			</cfif>		
			<cfif url.filter2value neq "">
			  AND #url.filter2# = '#url.filter2value#' 
			</cfif>		
			<cfif url.filter3value neq "">
			  AND #url.filter3# = '#url.filter3value#' 
			</cfif>		
			<cfif criteria neq "">
			  AND #preserveSingleQuotes(criteria)# 	
			</cfif> 
    AND     P.Reference > '' 
    AND     P.DateEffective = (
                         SELECT  MAX(DateEffective) 
                         FROM    WorkOrderLine						
						 WHERE   Reference     = P.Reference
						 AND     ServiceDomain = I.ServiceDomain  						 
						 
						  <!--- remove as this would show the last line within a service 
						 for the same reference and not globally --->
						 
						 <!---
                         WHERE   WorkOrderId IN
                                         (SELECT  WorkOrderId
							              FROM    WorkOrder WHERE 1 = 1
										  <cfif url.filter1value neq "">
										  AND #url.filter1# = '#url.filter1value#'
										  </cfif>		
										  <cfif url.filter2value neq "">
										  AND #url.filter2# = '#url.filter2value#'
										  </cfif>		
										  <cfif criteria neq "">
										  AND #preserveSingleQuotes(criteria)# 	
										  </cfif>)  
					      AND    Reference = P.Reference
						  --->
						)
						
		AND     (P.DateExpiration > getDate() or P.DateExpiration is NULL)	
		AND     P.Operational = 1							

	ORDER BY P.Reference
	
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">

<tr><td height="14" colspan="7">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

 <cfquery name="Format" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#SearchResult.serviceDomain#'			
	</cfquery>

<cfoutput query="SearchResult">

<cfif currentrow gte first>

	<tr class="navigation_row">
	  
	    <td height="18" style="padding-left:4px" width="30" class="navigation_action" onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#workorderlineid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">
			
			<cf_img icon="open">	  					   
		 	
		</td>
		<td width="20%" style="padding-left:4px" class="labelit">
				
	   	<cfif Format.displayformat eq "">
			<cfset val = reference>
		<cfelse>
		    <cf_stringtoformat value="#reference#" format="#Format.DisplayFormat#">						
		</cfif>
		#val#
		
		</td>
		<TD width="110" class="labelit" style="padding-left:3px;padding-right:3px">#dateformat(dateeffective,CLIENT.DateFormatShow)#</TD>
		<TD width="110" class="labelit" style="padding-left:3px;padding-right:3px">#dateformat(dateexpiration,CLIENT.DateFormatShow)#</TD>		
		<td width="25%" class="labelit" style="padding-left:3px">#CustomerName#</td>
		<cfif Description neq "">
		<TD colspan="2" class="labelit" width="40%" style="padding-left:3px">#Description#</TD>		
		<cfelse>
		<TD width="70"  class="labelit" style="padding-left:3px">#IndexNo#</TD>
		<TD width="35%" class="labelit" style="padding-left:6px">#Name#</TD>
		</cfif>
	</tr>
	
</cfif>	
		     
</CFOUTPUT>

<tr><td height="2"></td></tr>
<tr><td colspan="7" class="linedotted"></td></tr>

<tr><td height="14" colspan="7">
						 
	 <cfinclude template="Navigation.cfm">
	 				 
</td></tr>

</TABLE>

</td></tr>
 
</table>


<cfset AjaxOnLoad("doHighlight")>