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

<!--- activate / deactivate the requirement --->


<cfquery name="Action" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProgramAllotmentRequest		
		SET    ActionStatus        = '#url.action#',
		       ActionStatusDate    = getDate(),
			   ActionStatusOfficer = '#session.acc#'			   
		WHERE  RequirementId = '#url.requirementid#'	
</cfquery>

<!--- logging --->

<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
	   method           = "LogRequirement" 
	   RequirementId    = "#url.RequirementId#">	

<!--- amount --->

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.period#"
	   EditionId        = "#url.Edition#"
	   ObjectCode       = "#url.Object#">	

<!--- refreshes the details --->	

<cfoutput>

<cfif url.action eq "1">

	<cf_space spaces="12">

	<img src="#SESSION.root#/images/light_green2.gif" style="cursor:pointer" width="25" height="16"
    onclick="ColdFusion.navigate('#SESSION.root#/programrem/application/budget/allotment/setAllotmentBlock.cfm?requirementid=#url.requirementid#&action=0&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#&execution='+document.getElementById('exec_#url.edition#').value,'s_#url.requirementid#')" height="13" width="20" alt="Lock Requirement" style="border:1px solid silver">
	
	<script>
		document.getElementById('x_#requirementid#').className = "regular"
		document.getElementById('y_#requirementid#').className = "regular"
	</script>
					
<cfelse>

	<cf_space spaces="12">
	
	<img src="#SESSION.root#/images/light_red3.gif" style="cursor:pointer" width="25" height="16"
    onclick="ColdFusion.navigate('#SESSION.root#/programrem/application/budget/allotment/setAllotmentBlock.cfm?requirementid=#url.requirementid#&action=1&isParent=#url.isParent#&programcode=#url.programcode#&period=#url.period#&edition=#url.edition#&fund=#url.fund#&object=#url.object#&execution='+document.getElementById('exec_#url.edition#').value,'s_#url.requirementid#')" height="13" width="20" alt="Unlock Requirement" style="border:1px solid silver">
	
	<script>
		document.getElementById('x_#requirementid#').className = "hide"
		document.getElementById('y_#requirementid#').className = "hide"
	</script>
				
</cfif>	  

</cfoutput>	

<cfif url.action eq "0">
	<cfset dec = "blocked labelmedium">
<cfelse>
    <cfset dec = "labelmedium">
</cfif>

<!--- refresh the main screen --->
<cfoutput>

	<script language="JavaScript">
		
		<cfif url.action eq "0">
			try { document.getElementById('t#url.requirementid#').className = "hide" } catch(e) {}
		</cfif>
		
		document.getElementById('#url.requirementid#_des').className = '#dec#'	
		document.getElementById('#url.requirementid#_qty').className = '#dec#'	
		document.getElementById('#url.requirementid#_prc').className = '#dec#'	
		document.getElementById('#url.requirementid#_amt').className = '#dec#'	
		document.getElementById('#url.requirementid#_off').className = '#dec#'	
		document.getElementById('#url.requirementid#_dte').className = '#dec#'	
			
		if (document.getElementById('box#url.edition#')) {
			ptoken.navigate('AllotmentClear.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#','box#url.edition#')	
			ptoken.navigate('AllotmentInquiryAmount.cfm?scope=detail&programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#&objectcode=#url.object#&execution=#url.execution#','moveresult') 	
		}
		
	</script>
	
</cfoutput>	
	
	