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

