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