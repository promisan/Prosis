
<!--- decide if entry or inquiry screen is shown --->
<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_AllotmentEdition E
	WHERE      EditionId = '#URL.EditionId#'
</cfquery>

<cfparam name="URL.Mode" default="Header">
<cfparam name="URL.Fund" default="">

<cfif Edition.status eq "1">

	<!--- edition is open --->
	
	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.Program#"
		Period         = "#URL.Period#"	
		EditionId      = "'#URL.editionId#'"  
		Role           = "'BudgetManager','BudgetOfficer'"
		ReturnVariable = "BudgetAccess">	

<cfelse>

	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.Program#"
		Period         = "#URL.Period#"	
		EditionId      = "#URL.editionId#"  
		Role           = "'BudgetManager'"
		ReturnVariable = "BudgetAccess">	
		
</cfif>

<cfoutput>

<script language="JavaScript">
   	window.location = "AllotmentInquiry.cfm?Mode=#url.mode#&Program=#URL.Program#&Version=#Edition.Version#&EditionId=#URL.EditionId#&Period=#URL.Period#"
</script>

<!---

<cfif (BudgetAccess eq "ALL" or BudgetAccess eq "EDIT")>

    <script language="JavaScript">
    	window.location = "AllotmentEntry.cfm?Mode=#url.mode#&Program=#URL.Program#&EditionId=#URL.EditionId#&Period=#URL.Period#"
	</script>

<cfelse>

	<script language="JavaScript">
    	window.location = "AllotmentInquiry.cfm?Mode=#url.mode#&Program=#URL.Program#&EditionId=#URL.EditionId#&Period=#URL.Period#"
	</script>

</cfif>

--->

</cfoutput>