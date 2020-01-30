
<cfquery name="validate" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseLocationCapacity
		WHERE    Warehouse = '#url.warehouse#'
		AND		 Location = '#url.location#'
		AND		 ItemNo = '#form.itemno#'
		AND		 UoM = '#form.uom#'
		ORDER BY Created DESC	
</cfquery>

<!--- <cfif validate.recordcount eq 0> --->

	<cf_AssignId>
	<cfset vFunctionId = rowguid>
	
	<cfset vCapacity = replace(form.capacity, ",", "", "ALL")>

	<cfquery name="insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WarehouseLocationCapacity
				(
					Warehouse,
					Location,
					DetailId,
					DetailDescription,
					<cfif trim(form.DetailStorageCode) neq "">DetailStorageCode,</cfif>
					ItemNo,
					UoM,
					Capacity,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName
				)
			VALUES
				(
					'#url.warehouse#',
					'#url.location#',
					'#vFunctionId#',
					'#form.detailDescription#',
					<cfif trim(form.DetailStorageCode) neq "">'#form.DetailStorageCode#',</cfif>
					'#form.itemno#',
					'#form.uom#',
					#vCapacity#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
	</cfquery>

<!--- <cfelse>

	<script>
		alert('This item and uom already exist.');
	</script>

</cfif> --->

<cfinclude template="Details.cfm">