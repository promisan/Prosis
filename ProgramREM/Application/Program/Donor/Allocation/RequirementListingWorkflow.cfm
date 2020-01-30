

<!--- determine action --->



<cfquery name="get"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT   C.Mission, CL.*, O.OrgunitName
    FROM     Contribution C, ContributionLine CL, Organization.dbo.Organization O
    WHERE    ContributionLineId = '#url.ajaxid#'
	AND      O.Orgunit = C.OrgUnitDonor
	AND      C.ContributionId = CL.Contributionid
</cfquery>	

<!--- pending for dynamic class definition 
													
<cfquery name="getClass"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemWarehouseLocationTransaction 
	WHERE    Warehouse       = '#get.warehouse#'
	AND      Location        = '#get.Location#'
	AND      ItemNo          = '#get.itemno#'
	AND      UoM             = '#get.transactionuom#'
	AND      TransactionType = '#get.transactiontype#'
</cfquery>

--->
	
<cfset link = "ProgramREM/Application/Program/Donor/Contribution/ContributionWorkflow.cfm?AjaxId=#get.ContributionId#">
			
<cf_ActionListing 
	    EntityCode       = "EntTrench"		
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""		
		Mission          = "#get.Mission#"															
		ObjectReference  = "#get.OrgUnitName#"
		ObjectReference2 = "#get.Reference#" 											   
		ObjectKey4       = "#url.ajaxid#"
		ObjectURL        = "#link#"
		Ajaxid           = "#url.ajaxid#"
		Show             = "Yes">
	
