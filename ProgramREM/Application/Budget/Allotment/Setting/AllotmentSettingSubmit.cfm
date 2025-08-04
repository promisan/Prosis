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
				   ModeMappingTransaction = '#form.ModeMappingTransaction#',
			   </cfif>
			   SupportPercentage = '#form.SupportPercentage#', 
			   SupportObjectCode = '#form.SupportObjectCode#',
			   DueCalculation    = '#form.DueCalculation#',
			   Fund              = '#form.Fund#',
			   FundEnforce       = '#form.FundEnforce#',
			   AmountRounding    = '#form.AmountRounding#'
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

