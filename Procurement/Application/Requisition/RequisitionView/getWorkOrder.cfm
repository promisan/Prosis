
<cfparam name="url.workorderid" default="">
<cfparam name="url.doFilter" 	default="0">

<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  W.WorkOrderId, 
          C.CustomerName, 
		  W.Reference, 
		  W.OrderDate, 
		  W.ActionStatus, 
		  I.Description AS Item

  FROM    Workorder W, Customer C, ServiceItem I
  WHERE   W.CustomerId  = C.CustomerId 
  AND     W.Serviceitem = I.Code
  <cfif url.workorderid eq "">
  AND     1=0	
  <cfelse>
  AND     WorkorderId = '#url.workorderid#'  	
  </cfif>
  
</cfquery>

<cfoutput>
<table cellspacing="0" cellpadding="0" height="18">
	<tr>
		<td>
		<input type="text" name="CustomerName" class="regularxl" size="30" maxlength="80" value="#get.CustomerName# #get.Reference#" readonly>
		<input type="hidden" name="workorderid" id="workorderid" size="40" maxlength="60" value="'#url.workorderid#'" readonly>		
		</td>
	</tr>		
</table>
</cfoutput>

<cfif URL.doFilter eq 1>
	<cfset AjaxOnLoad("filter")>
</cfif>	