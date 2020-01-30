
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

	