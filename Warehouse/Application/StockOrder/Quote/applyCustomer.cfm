

<!--- apply customer --->

<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   *
	FROM     Customer
	WHERE    CustomerId = '#url.customerid#'					
</cfquery>

<table>
<cfoutput query="getHeader">
<tr class="labelmedium2"><td><a href="javascript:editCustomer('#getHeader.customerid#')">#CustomerSerialNo#</a></td></tr>
<tr class="labelmedium2"><td>#CustomerName#</td></tr>
</cfoutput>
</table>

<cfquery name="setHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	UPDATE   CustomerRequest
	SET      CustomerId = '#url.customerid#', 
	         CustomerMail = '#getHeader.eMailAddress#'
	WHERE    RequestNo = '#url.requestno#'				
</cfquery>

<cfoutput>

	<script>
		 document.getElementById('customermail').value = '#getHeader.eMailAddress#'
	</script>
	
</cfoutput>
