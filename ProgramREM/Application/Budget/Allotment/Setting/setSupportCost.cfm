
<!--- recalculate the support costs for allotment per project --->

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE ProgramAllotment
	SET    SupportPercentage = '#url.Percentage#', 
		   SupportObjectCode = '#url.ObjectCode#'
	WHERE  ProgramCode = '#url.programcode#' 
	AND    Period      = '#url.period#' 
	AND    EditionId   = '#url.editionid#'				
</cfquery>	

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.Period#"
	   EditionId        = "#url.EditionId#"
	   Mode             = "Support">	<!--- this might affect the support costs per unit --->	   
	   
<!--- recalculate the generated supportcost financial transactions per project and contribution --->

<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method            = "generateSupportCost" 
	   ProgramCode       = "#url.programcode#" 
	   Period            = "#url.period#"
	   EditionId         = "#url.editionid#">	
	   
<font color="008000">Completed!</font> 