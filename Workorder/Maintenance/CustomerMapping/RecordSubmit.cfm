
<cfquery name="validate" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT 	*
	FROM	stCustomerMapping
	WHERE 	convert(varchar(50),CustomerId) = '#Form.CustomerId#'
<!--- 	AND		ServiceItem = '#Form.ServiceItem#' --->
	AND		MappingCode = '#Form.MappingCode#'
	
</cfquery>


<cfif url.id1 eq "new">
	
	<cfif validate.recordCount eq 0>

		<cfquery name="insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			INSERT stCustomerMapping
			(
				CustomerId,
				MappingCode,
				Created
			)
			VALUES
			(
				'#Form.CustomerId#',
				'#Form.MappingCode#',
				getDate()
			)
			
		</cfquery>
		
		<script>
			parent.window.close();
			parent.opener.location.reload();
		</script>
	
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('This combination of customer, service item and mapping code already exists!');
			</script>
		</cfoutput>
	
	</cfif>	
	
<cfelse>

	<cfif validate.recordCount eq 0 or (form.customerId eq form.customerIdOld and form.serviceItem eq form.serviceItemOld and form.mappingCode eq form.mappingCodeOld)>

		<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE stCustomerMapping
			SET 
				CustomerId  = '#Form.CustomerId#',
				MappingCode = '#Form.MappingCode#'
			WHERE
				TransactionId = '#url.id1#'
			
		</cfquery>
		
		<script>
			parent.window.close();
			parent.opener.location.reload();
		</script>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('This combination of customer, service item and mapping code already exists!');
			</script>
		</cfoutput>
	
	</cfif>	

</cfif>

