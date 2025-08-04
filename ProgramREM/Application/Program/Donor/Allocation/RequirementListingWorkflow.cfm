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
	
