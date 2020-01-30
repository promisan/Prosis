<cfif url.customerid eq "">
	<cfset url.customerid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT   *
	FROM      WorkOrder W, ServiceItem S
	WHERE     Customerid = '#url.customerid#'
	AND       W.ServiceItem = S.Code
	AND       Mission = '#url.mission#'
	AND       ActionStatus = '1'
	ORDER By  OrderDate
</cfquery>	

<cfoutput>

<table width="100%" cellspacing="6" cellpadding="6">

	<input type="hidden" id="workorderid" name="workorderid" value="#workorder.workorderid#">
	
	<cfloop query="workorder">
	
	<tr>
		<td><input type="radio" name="selected" id="selected" style="width:18;height:18"
		           onclick="document.getElementById('workorderid').value='#workorderid#'" 
				   value="#workorderid#" <cfif currentrow eq "1">checked</cfif>>
	    </td>
		<td class="labellarge"><i>#Description#</td>
		<td class="labellarge"><i>#Reference#</td>
		<td class="labellarge" align="center"><i>#dateformat(OrderDate,CLIENT.DateFormatShow)#</td>
	</tr>
	
	</cfloop>

</table>

</cfoutput>