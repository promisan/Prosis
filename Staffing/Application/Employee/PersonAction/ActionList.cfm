<!--- ---------------------------------------------------- --->
<!--- clean document action record that do no longer exist --->
<!--- We can make this work just for the selected person   --->
<!--- ---------------------------------------------------- --->

<!--- clean document action record that do no longer exist --->
<!--- We can make this work just for the selected person   --->
<!--- ---------------------------------------------------- --->

<!--- Attention the below cleaning was moved to the daily process of staffing stats  

<cfset FileNo = round(Rand()*20)>

<cfif fileno eq "4">

 <cfquery name="Cleansing1" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE EmployeeAction	
	 WHERE  ActionSource = 'Contract'
	 AND    ActionSourceId NOT IN (SELECT ContractId
	                               FROM   PersonContract
								   WHERE  ContractId = ActionSourceId)	
	 AND    ActionSourceid is not NULL				 
</cfquery>

<cfquery name="Cleansing2" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE EmployeeAction	
	 WHERE  ActionSource = 'Dependent'
	 AND    ActionSourceId NOT IN (SELECT DependentId
	                               FROM   PersonDependent
								   WHERE  DependentId = ActionSourceId)	
	 AND    ActionSourceid is not NULL									 
</cfquery>

<cfquery name="Cleansing3" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE EmployeeAction	
	 WHERE  ActionSource = 'SPA'
	 AND    ActionSourceId NOT IN (SELECT PostAdjustmentId
	                               FROM   PersonContractAdjustment
								   WHERE  PostAdjustmentId = ActionSourceId)	
	 AND    ActionSourceid is not NULL									 
</cfquery>

<cfquery name="Cleansing4" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE EmployeeAction
	 WHERE  ActionSource = 'Leave'
	 AND    ActionSourceId NOT IN (SELECT LeaveId
	                               FROM   PersonLeave
								   WHERE  Leaveid = ActionSourceId)			
	 AND    ActionSourceid is not NULL							 
</cfquery>

<cfquery name="Cleansing5" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE EmployeeAction
	 WHERE  ActionSource = 'Entitlement'
	 AND    ActionSourceId NOT IN (SELECT EntitlementId
	                               FROM   Payroll.dbo.PersonEntitlement
								   WHERE  EntitlementId = ActionSourceId)			
	 AND    ActionSourceId is not NULL							 
</cfquery>

</cfif>

--->

<!--- we create a temp user file with the last workflow date --->

<cfinclude template="ActionListContent.cfm">
