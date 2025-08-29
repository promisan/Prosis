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