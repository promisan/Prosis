
<!--- define settings for the project, period and edition --->

<cfparam name="form.lockentry" default="0">
<cfparam name="form.duecalculation" default="0">

<cfquery name="getProgram" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program
	WHERE     ProgramCode = '#url.ProgramCode#' 	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#getProgram.mission#' 	
</cfquery>

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM ProgramAllotment		
		WHERE  ProgramCode = '#url.programcode#' 
		AND    Period      = '#url.period#' 
		AND    EditionId   = '#url.editionid#'				
	</cfquery>	
	
	
<cfparam name="Form.FundEnforce" default="0">	

<cfif isNumeric(form.SupportPercentage)>
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProgramAllotment
		SET    <cfif Parameter.EnableDonor eq "1">
				   SupportPercentage = '#form.SupportPercentage#', 
				   SupportObjectCode = '#form.SupportObjectCode#',
				   ModeMappingTransaction = '#form.ModeMappingTransaction#',
			   </cfif>
			   DueCalculation = '#form.DueCalculation#',
			   Fund           = '#form.Fund#',
			   FundEnforce    = '#form.FundEnforce#',
			   AmountRounding = '#form.AmountRounding#'
			   <cfif get.LockEntry neq form.LockEntry>
			   , LockEntry      = '#form.LockEntry#' 	
			   , LockEntryOfficer = '#session.acc#'
			   , LockEntryDate    = getDate()			   
			   </cfif>
		WHERE  ProgramCode = '#url.programcode#' 
		AND    Period      = '#url.period#' 
		AND    EditionId   = '#url.editionid#'				
	</cfquery>	
	
	<cfif form.DueCalculation eq "0">
			
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ProgramAllotmentRequest
			SET    AmountBasePercentageDue = 1		
			WHERE  ProgramCode = '#url.programcode#' 
			AND    Period      = '#url.period#' 
			AND    EditionId   = '#url.editionid#'				
		</cfquery>	
		
	</cfif>
	
	
<cfif get.AmountRounding neq Form.AmountRounding>

<!--- reset the allotment --->

<cfquery name="clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramAllotmentDetail
		WHERE  ProgramCode = '#url.programcode#' 
		AND    Period      = '#url.period#' 
		AND    EditionId   = '#url.editionid#'				
		AND    Status IN ('0','P')
	</cfquery>	
	
	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.Period#"
	   EditionId        = "#url.EditionId#"
	   Mode             = "All">	
	
</cfif>
	
	<font color="gray">Saved</font>

<cfelse>

	<font color="red">Incorrect percentage</font>

</cfif>

