
<cfquery name="Delete" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE ContractBehavior
		  WHERE  ContractId   = '#URL.ContractId#' 
		   AND  BehaviorCode    = '#URL.ID2#' 
</cfquery>

<cfquery name="Delete" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE ContractTraining
		  WHERE  ContractId   = '#URL.ContractId#' 
		   AND  BehaviorCode    = '#URL.ID2#' 
</cfquery>

<cfset URL.ID2 = "new">

<cfinclude template="BehaviorRecord.cfm">
