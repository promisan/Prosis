<cfquery name="getCustomers" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	SC.*,
				C.CustomerName
		FROM  	ServiceItemCustomer SC
				INNER JOIN Customer C
					ON SC.CustomerId = C.CustomerId
		WHERE	SC.ServiceItem = '#url.serviceItem#'
</cfquery>

<table width="98%" align="center">
	<tr><td height="5"></td></tr>
	<tr>
		<td class="labellarge"><cf_tl id="Customers">:</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="5"></td></tr>
	
	<cfif getCustomers.recordCount eq 0>
		<tr>
			<td class="labelmedium">[ <cf_tl id="No customers for this service"> ]</td>
		</tr>
	</cfif>
	
	<cfoutput query="getCustomers">
		<tr>
			<td class="labelmedium">
				<input type="Radio" name="customerid" id="customerid_#customerid#" value="#CustomerId#" onclick="ColdFusion.navigate('ForecastEntry.cfm?serviceItem=#url.serviceItem#&customerid=#CustomerId#','divForecastEntry');"> <label for="customerid_#customerid#">#CustomerName#</label>
			</td>
		</tr>
	</cfoutput>
</table>