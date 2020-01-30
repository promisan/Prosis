
<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse  = '#url.warehouse#'			
</cfquery>

<cfinvoke component = "Service.Access"  
     method             = "roleaccess"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 missionorgunitid   = "#getWarehouse.MissionOrgUnitId#"
	 Parameter          = "#url.SystemFunctionId#" 
	 AccessLevel        = "'1','2'"
	 returnvariable     = "access">	 
	 
<cfif url.transactiontype eq "8">
  <cfinclude template="PendingDetailTransfer.cfm">
<cfelse>
  <cfinclude template="PendingDetailAsset.cfm">
</cfif>
