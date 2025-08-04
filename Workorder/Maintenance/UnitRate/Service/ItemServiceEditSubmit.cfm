<!--
    Copyright © 2025 Promisan

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


<!--- remove service item --->

<!--- saving and reload --->

<cfparam name="Form.EnableSetDefault" default="0">

<cfif url.id eq "">

	<cfquery name="check" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   ServiceItemUnitWorkorderService 
		WHERE  ServiceItem    = '#url.id1#'
		AND    Unit           = '#url.id2#'
		AND    ServiceDomain  = '#form.ServiceDomain#' 
		AND    Reference      = '#Form.Reference#'
	</cfquery>
	
	<cfif check.recordcount eq "0">

		<cfquery name="set" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ServiceItemUnitWorkorderService 
			( ServiceItem, Unit, 
			   ServiceDomain, Reference, Mission, ListingOrder, EnableSetDefault, 
			   OfficerUserId, OfficerLastName, OfficerFirstName )
	        VALUES 
			('#url.id1#','#url.id2#',
			 '#Form.ServiceDomain#','#Form.Reference#','#Form.Mission#','#Form.ListingOrder#','#Form.EnableSetDefault#',
			 '#session.acc#','#session.last#','#session.first#')		
		</cfquery>	
	
	</cfif>	

<cfelse>

	<cfquery name="set" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ServiceItemUnitWorkorderService 
		SET    ServiceDomain    = '#form.ServiceDomain#', 
		       Reference        = '#Form.Reference#', 
			   ListingOrder     = '#Form.ListingOrder#',
			   EnableSetDefault = '#Form.EnableSetDefault#'		
		WHERE UsageId = '#url.id#'		
	</cfquery>		

</cfif>


<cfoutput>

<script>
	ProsisUI.closeWindow('mysetting')
	_cf_loadingtexthtml='';
	ptoken.navigate('Service/ItemUnitServiceListingDetail.cfm?ID1=#url.id1#&id2=#url.id2#','servicelisting')
</script>

</cfoutput>