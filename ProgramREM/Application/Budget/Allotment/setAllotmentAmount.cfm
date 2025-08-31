<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.value" default="0">

<cfset val = replaceNoCase(url.value,",","","ALL")>

<cfif isNumeric(val)>

	<cfquery name="get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ProgramAllotmentRequest					   
			WHERE  RequirementId = '#url.requirementid#'	
	</cfquery>
	
	<cfset threshold = get.RequestAmountBase+get.RequestAmountBase*0.1>
	
	<cfif val gte threshold>	
		 <cfset val = threshold>		 
	</cfif>
	
	<!--- Also we need to check that if the amount entered for allotment it is not
	lower than the amount already allotted --->
		
	<cfquery name="prior" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ISNULL(SUM(Amount),0) as Amount
			FROM   ProgramAllotmentDetailRequest S					   
			WHERE  RequirementId = '#url.requirementid#'	
			AND    TransactionId IN (SELECT Transactionid FROM ProgramAllotmentDetail
			                         WHERE TransactionId = S.Transactionid
									 AND   Status = '1')
	</cfquery>
	
	<cfif val lt prior.amount and val eq "0">
		<cfset val = prior.amount>
	</cfif>
			
	<cfquery name="Action" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ProgramAllotmentRequest		
			SET    ActionStatus        = '1',
			       ActionStatusDate    = getDate(),
				   ActionStatusOfficer = '#session.acc#',
				   AmountBaseAllotment = '#val#'			   
			WHERE  RequirementId       = '#url.requirementid#'	
	</cfquery>	
	
	 <cfoutput>
		 <script language="JavaScript">		
			document.getElementById('releaseallotment#url.requirementid#').value = '#numberformat(val,",__")#'					
		 </script>
	 </cfoutput>
	 	 	
	 <!--- logging of allotment release amount --->
	 <cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "LogRequirement" 
	   RequirementId    = "#url.RequirementId#">	

	 <!--- define amounts --->
	 <cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#get.ProgramCode#" 
	   Period           = "#get.period#"
	   EditionId        = "#get.EditionId#"
	   ObjectCode       = "#get.ObjectCode#">	

<cfelse>

	<script>
		alert("You entered an incorrect value.")
	</script>	

</cfif>
