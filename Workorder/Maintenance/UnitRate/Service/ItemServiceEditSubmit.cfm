

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