<cfquery name="RequestTypeList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Ref_Request P
		WHERE    Operational = '1'	
		AND      Code IN (SELECT RequestType 
		                  FROM   Ref_RequestWorkflowWarehouse 
						  WHERE  Code = P.Code 
						  AND    Warehouse = '#url.warehouse#')
		ORDER BY ListingOrder						
</cfquery>

<cfif RequestTypeList.recordcount eq "0">

	<cfquery name="RequestTypeList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_Request P
			WHERE    Operational = '1'							
			ORDER BY ListingOrder						
	</cfquery>
			
</cfif>
			
<cfoutput>			

	<select name="requesttype" id="requesttype" class="regularxl"  onchange="ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Checkout/getRequestAction.cfm?warehouse=#url.warehouse#&requesttype='+this.value+'&width=&RequestAction=','divRequestAction');">
		<cfloop query="RequestTypeList">
			<option value="#Code#" <cfif url.RequestType eq Code>selected</cfif>>#Description#</option>
		</cfloop>
	</select>
	
	<cfif url.requestAction neq "">
		<script>
			ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Checkout/getRequestAction.cfm?warehouse=#url.warehouse#&requesttype=#url.requestType#&width=&RequestAction=#url.RequestAction#','divRequestAction');
		</script>
	</cfif> 
	
	<cfif url.requestType eq "">
		<script>
			ColdFusion.navigate('#SESSION.root#/Warehouse/Portal/Checkout/getRequestAction.cfm?warehouse=#url.warehouse#&requesttype=#RequestTypeList.code#&width=&RequestAction=','divRequestAction');
		</script>
	</cfif> 

</cfoutput>