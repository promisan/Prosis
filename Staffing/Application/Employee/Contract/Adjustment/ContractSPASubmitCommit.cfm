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

<!--- from workflow --->
<cfparam name="Object.ObjectKeyValue4" default="">

<cfparam name="attributes.PostAdjustmentId" default="#Object.ObjectKeyValue4#">

<cfquery name="SPA" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    SELECT   * 		  
	FROM     PersonContractAdjustment
	WHERE    PostAdjustmentId = '#attributes.PostAdjustmentId#'		
</cfquery>	

<cfif SPA.recordcount eq "1">
	
	<cfquery name="Confirm" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	 	UPDATE   Employee.dbo.PersonContractAdjustment
		SET      ActionStatus = '1'
		WHERE    PersonNo           = '#SPA.PersonNo#'
		AND       PostAdjustmentId  = '#SPA.PostAdjustmentId#'
	</cfquery>
		
	<!--- these are contract releated dependent record to prevent double workflow --->
	
	<cfquery name="ConfirmDependents" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE   PersonDependent
		SET      ActionStatus = '2'
	    FROM     PersonDependent
	    WHERE    DependentId IN (
		
		                       SELECT ActionSourceId 
		                       FROM   EmployeeActionSource
					           WHERE  PersonNo     = '#SPA.PersonNo#'
							   AND    ActionStatus = '1'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#SPA.PostAdjustmentId#')
	                            )
	</cfquery>
	
	<cfquery name="ConfirmDependentsEntitlement" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE   Payroll.dbo.PersonDependentEntitlement
		SET      Status = '2'
		FROM     Payroll.dbo.PersonDependentEntitlement
	    WHERE    DependentId IN (
		                       SELECT ActionSourceId 
		                       FROM   EmployeeActionSource
					           WHERE  PersonNo     = '#SPA.PersonNo#'
							   AND    ActionStatus = '1'
	                           AND    ActionDocumentNo IN (SELECT ActionDocumentNo 
				                                           FROM   EmployeeAction 
										                   WHERE  ActionSourceId = '#SPA.PostAdjustmentId#')
	                            )
	</cfquery>

</cfif>	