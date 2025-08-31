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
<cfparam name="url.delete" default="">
<cfparam name="url.mode"   default="detail">

<cfif url.delete neq "">

	<cfquery name="Action" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramAllotmentDetail
			WHERE    ActionId = '#url.delete#'	
		</cfquery>

	<cfquery name="Action" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ProgramAllotmentAction
			WHERE    ActionId = '#url.delete#'	
	</cfquery>
				
</cfif>

<!--- perform a sync --->

<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.ProgramCode#" 
	   Period           = "#url.period#"
	   EditionId        = "#url.Edition#">	
	
<cfif url.mode eq "detail">  
	
	<!--- refreshes the details --->		  
	
	<cfinclude template="AllotmentInquiryDetail.cfm">			 
	
	<!--- refresh the main screen used for data entry this is only for the processing screen --->
	<cfoutput>
		<script>
			ptoken.navigate('#SESSION.root#/programrem/application/budget/allotment/AllotmentInquiryAmount.cfm?scope=detail&programcode=#url.programcode#&period=#url.period#&editionid=#url.edition#&objectcode=#url.object#','moveresult') 	
		</script>
	</cfoutput>		
	
<cfelse>

	<script>
		 history.go()	
	</script>
	
</cfif>	 
