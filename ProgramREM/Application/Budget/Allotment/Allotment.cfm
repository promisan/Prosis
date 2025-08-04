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