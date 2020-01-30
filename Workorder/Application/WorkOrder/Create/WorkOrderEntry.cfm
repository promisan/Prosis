
<cfparam name="url.mission" default="">

<cfquery name="Customer" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
	WHERE Customerid = '#URL.Customerid#'			
</cfquery>

<cfquery name="Type" 
datasource="appsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT *
		    FROM  ServiceItem
			WHERE Code IN (SELECT ServiceItem 
			               FROM   ServiceItemMission 
						   WHERE  Mission = '#url.mission#')
			AND   Operational = 1
			ORDER By ListingOrder
</cfquery>

<cfoutput>
<tr><td class="labelit"><cf_tl id="Customer"></td>
	<td class="labelit">#Customer.CustomerName#</td>
</tr>
</cfoutput>
<tr>
   <td height="24" width="20%" class="labelit"><cf_tl id="New Order for">:</td>
   <td>   
   <select name="ordertype_entry" id="ordertype_entry" style="font:10px">   
	   <cfoutput query="Type">
	   	<option value="#Code#">#Description#</option>
	   </cfoutput>
   </select>
      
   </td>
</tr>

<tr><td colspan="2">
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
	   <td colspan="2" bgcolor="F5FBFE" style="border: 1px solid silver;">
	  
	       <cfdiv bind="url:#SESSION.root#/workorder/application/workorder/create/workorderform.cfm?scope=entry&mode=edit&mission=#url.mission#&ordertype={ordertype_entry}"
		     id="content">
	   </td>
	</tr>
	
	</table>

	</td>
</tr>
