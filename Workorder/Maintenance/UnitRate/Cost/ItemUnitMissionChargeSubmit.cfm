<cfquery name="removePayerLine" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE [dbo].[ServiceItemUnitMissionCharge]
		WHERE costid = '#url.costid#'
		AND PayerOrgUnit = '#url.unit#'
		AND Destination = '#url.Destination#'
</cfquery>

<cfquery name="insertPayerLine" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO [dbo].[ServiceItemUnitMissionCharge]
		           ([CostId]
		           ,[PayerOrgUnit]
		           ,[Destination]
		           ,[Amount]
		           ,[OfficerUserId]
		           ,[OfficerLastName]
		           ,[OfficerFirstName])
		     VALUES
		           ('#url.costid#'
		           ,'#url.unit#'
		           ,'#url.Destination#'
		           ,'#url.amount#'
		           ,'#session.acc#'
		           ,'#session.last#'
		           ,'#session.first#')
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('ItemUnitMissionCharge.cfm?costId=#url.costid#&mission=#url.mission#', 'divCharge');
	</script>
</cfoutput>