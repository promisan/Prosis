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
