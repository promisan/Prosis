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

<cfparam name="attributes.EntitlementId" default="#Object.ObjectKeyValue4#">

<cfquery name="ActionSource" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">   
      SELECT * 		  
	  FROM   Employee.dbo.EmployeeActionSource
	  WHERE  ActionDocumentNo IN (SELECT ActionDocumentNo 
		                          FROM   Employee.dbo.EmployeeAction 
								  WHERE  ActionSourceId = '#attributes.EntitlementId#')		
</cfquery>	

<cfset PANo = ActionSource.ActionDocumentNo>

<cfif ActionSource.recordcount gt "0">

	<cfquery name="getAction" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Employee.dbo.EmployeeAction     
		   WHERE  ActionDocumentNo  = '#actionsource.ActionDocumentNo#'  
	</cfquery>
			
	<cfloop query="ActionSource">
				 
			<cfif ActionStatus eq "9">
			    <cfset contractstatus = "9">
			<cfelse>
			    <cfset contractstatus = "2">
			</cfif>
	
			<cfquery name="RevokeContract" 
			   datasource="AppsOrganization" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
		    	  UPDATE Payroll.dbo.PersonEntitlement
			      SET    Status    = '#contractstatus#'
			      WHERE  EntitlementId   = '#ActionSourceId#'  								  				  
			</cfquery>
			
	</cfloop>		

</cfif>