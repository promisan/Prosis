
<cfquery name="verifyDelete" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   WorkOrderLineBillingDetail
	WHERE  ServiceItem     = '#URL.ID1#'
	AND    ServiceItemUnit = '#URL.ID2#'
</cfquery>	


<cfquery name="verifyBaseLine" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   WorkOrderBaseLineDetail
	WHERE  ServiceItem     = '#URL.ID1#'
	AND    ServiceItemUnit = '#URL.ID2#'
</cfquery>	

<cfif verifyDelete.recordCount eq "0" and verifyBaseLine.recordcount eq "0">	
		
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ServiceItemUnit
		WHERE  ServiceItem = '#URL.ID1#'
		AND    Unit        = '#URL.ID2#'
	</cfquery>
	
<cfelse>

	<script>
		alert("Service unit record is in use. Action aborted")
	</script>	
	<!---- records is in use --->	
	
</cfif>

<cfoutput>

	<script language="JavaScript">   
		ColdFusion.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitListing.cfm?ID1=#URL.ID1#','contentbox2')
	</script> 
	
</cfoutput>