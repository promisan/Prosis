
<cfquery name="removePayerLine" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE [dbo].[ServiceItemUnitMissionCharge]
		WHERE costid = '#url.costid#'
		AND PayerOrgUnit = '#url.unit#'
		AND Destination = '#url.Destination#'
</cfquery>


<cfoutput>
	<script>
		ptoken.navigate('ItemUnitMissionCharge.cfm?costId=#url.costid#&mission=#url.mission#', 'divCharge');
	</script>
</cfoutput>