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

<cfparam name="Object.ObjectKeyValue4"        default="">
<cfparam name="ScriptFile.DocumentStringList" default="Deny">

<cfparam name="attributes.dependentid" default = "#Object.ObjectKeyValue4#">
<cfparam name="attributes.qAction"     default = "#ScriptFile.DocumentStringList#">

<cfset qAction = attributes.qAction>

<cfif qAction eq "Approve">
  <cfset st = "1">
<cfelse>
  <cfset st = "2">
</cfif>

<!--- check if an action exists --->

<cfquery name="ActionSource" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Employee.dbo.EmployeeActionSource
		  WHERE  ActionDocumentNo IN 
					  (SELECT ActionDocumentNo 
					   FROM   Employee.dbo.EmployeeAction 
					   WHERE  ActionSourceId = '#attributes.DependentId#')		
</cfquery>	

<cfif ActionSource.recordcount eq "0">

	<cfquery name="Main" datasource="AppsEmployee">
		UPDATE PersonDependent
		SET    ActionStatus = '#st#' 
		FROM   PersonDependent 
		WHERE  PersonNo    = '#Object.ObjectKeyValue1#'
		AND    DependentId = '#Object.ObjectKeyValue4#'	
		AND    ActionStatus != '9'
	</cfquery>
	
	<cfquery name="Entitlement" datasource="AppsPayroll">
		UPDATE PersonDependentEntitlement
		SET    Status = '#st#'
		FROM   PersonDependentEntitlement
		WHERE  PersonNo    = '#Object.ObjectKeyValue1#'
		AND    DependentId = '#Object.ObjectKeyValue4#'			
	</cfquery>

<cfelse>

      <cfquery name="ResetPA" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    	 UPDATE Employee.dbo.EmployeeAction 
			 SET    ActionStatus      = '1', 					      
					ActionDescription = 'Reinstate [dep]'
			 WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                                 FROM   Employee.dbo.EmployeeAction
									     WHERE  ActionSourceId='#Object.ObjectKeyValue4#')
	</cfquery>		
	
	<cfquery name="One" datasource="AppsEmployee">
		UPDATE PersonDependent
		SET    ActionStatus = '#st#' 
		FROM   PersonDependent 
		WHERE  PersonNo = '#Object.ObjectKeyValue1#'
		AND    DependentId IN 
		           (SELECT ActionSourceId FROM EmployeeActionSource
		            WHERE ActionSource='Dependent'
					AND ActionStatus!='9'
		            AND PersonNo='#Object.ObjectKeyValue1#'
		            AND ActionDocumentNo IN (SELECT ActionDocumentNo 
					                         FROM   EmployeeAction 
											 WHERE  ActionSourceId='#Object.ObjectKeyValue4#')
		)
		AND ActionStatus!='9'
	</cfquery>
	
	<cfquery name="two" datasource="AppsPayroll">
		UPDATE PersonDependentEntitlement
		SET    Status = '#st#'
		FROM   PersonDependentEntitlement
		WHERE  DependentId IN (
		          SELECT ActionSourceId 
				  FROM   Employee.dbo.EmployeeActionSource
		          WHERE  ActionSource='Dependent'
				  AND    ActionStatus!='9'
		          AND    PersonNo='#Object.ObjectKeyValue1#'
		          AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                              FROM   Employee.dbo.EmployeeAction
											  WHERE  ActionSourceId='#Object.ObjectKeyValue4#')
		)
		AND Status  != '9'
		AND PersonNo = '#Object.ObjectKeyValue1#'
	</cfquery>

</cfif>
