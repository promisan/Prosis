
<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract C 
		WHERE    ContractId = '#URL.ContractId#'
</cfquery>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractActor C 
		WHERE    ContractId = '#URL.ContractId#'
		AND      ActionStatus = '1' 
		AND      Role = 'Evaluation'
</cfquery>

<cfloop query="Role">
	<cfset url.personNo = PersonNo>
	<cfinclude template="../PASView/CreatePASAccessWorkflow.cfm">
</cfloop>	

<cfif Contract.ActionStatus gte "2">

 <cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#URL.ContractId#"
	 BackEnable    = "0"
	 HomeEnable    = "0"
	 ResetEnable   = "0"
	 ProcessEnable = "0"
	 NextEnable    = "1"
	 ButtonWidth   = "300"
	 NextName      = "Open for Midterm review"
	 NextMode      = "1"
	 SetNext       = "1">		
	 
</cfif>	 
