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

<!--- update orgunit and show --->

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ProgramAllotmentDetail 		
		WHERE  Transactionid = '#URL.TransactionId#'		
</cfquery>

<cfif url.orgunit neq get.OrgUnit>
	
	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ProgramAllotmentDetail 
			SET    OrgUnit = '#url.orgunit#'
			WHERE  Transactionid = '#URL.TransactionId#'		
	</cfquery>
	
	<cfquery name="getUnit" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT OrgUnitNameShort 
			FROM   Organization.dbo.Organization
			WHERE  OrgUnit =  '#url.orgunit#'
	</cfquery>
	
	<!--- reevaluste the allotments as it might affect the support generation --->
	 	
	<!--- checkes the allotment entry and calculates the defined program support cost --->	  
	
	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#get.ProgramCode#" 
	   Period           = "#get.Period#"
	   EditionId        = "#get.EditionId#"
	   Mode             = "Support">	<!--- this might affect the support costs per unit --->	   
	   
	   <cfoutput>
		   <script>
		        Prosis.busy('no')
			    ColdFusion.navigate('AllotmentViewContent.cfm?mode=reload&program=#get.ProgramCode#&period=#get.Period#&edition=#get.EditionId#','content')
	   	</script>
	   </cfoutput>
	   
<cfelse>	

	<cfquery name="getUnit" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT OrgUnitNameShort 
			FROM   Organization.dbo.Organization
			WHERE  OrgUnit =  '#url.orgunit#'
	</cfquery> 

	<cfoutput>#getUnit.OrgUnitNameShort#</cfoutput>	  	  
		   
</cfif>	   

<script>
Prosis.busy('no')
</script>

	