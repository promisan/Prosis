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

<!--- ------------------------------------------------------------------------------------------ --->
<!--- Component to serve requests that relate to the provisioing of a service based workorder -- ---> 
<!--- ------------------------------------------------------------------------------------------ --->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name  = "syncCustomer"
        access        = "remote"
        returntype    = "any" 
		returnformat  = "plain" 
		output        = "yes"
        displayname   = "syncs customer from warehouse to workorder">
		
			<cfargument name="CustomerId"    type="string" required="true">
			
			<cfquery name="customer"
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">			
				   SELECT * FROM Customer
				   WHERE CustomerId = '#customerid#'			   
			</cfquery>
			
			<cfif customer.recordcount eq "0">
			
				<cfquery name="get"
				   datasource="AppsMaterials" 
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">			
				   SELECT * FROM Customer
				   WHERE CustomerId = '#customerid#'			   
				</cfquery>
			
			     <cfset resultid = "">
			
				<cfif get.PersonNo neq "">
				
					<cfquery name="check"
					   datasource="AppsWorkOrder" 
					   username="#SESSION.login#"
					   password="#SESSION.dbpw#">			
					   SELECT * 
					   FROM   Customer
					   WHERE  PersonNo = '#get.PersonNo#'			   
					   AND    Mission = '#get.Mission#'
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfset resultid = check.Customerid>				
					
					<cfelseif get.OrgUnit neq "">
					
						<cfquery name="check"
						   datasource="AppsWorkOrder" 
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">			
						   SELECT * 
						   FROM   Customer
						   WHERE  OrgUnit = '#get.OrgUnit#'			   
						   AND    Mission = '#get.Mission#'
						</cfquery>
						
						<cfif check.recordcount eq "1">
						
							<cfset resultid = check.Customerid>
						
						</cfif>
						
					</cfif>								
				
				</cfif>
			
				<cfif resultid eq "">
				
					<cfquery name="customer" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						INSERT INTO Workorder.dbo.Customer
							    (CustomerId, 
								 Mission, OrgUnit, PersonNo, 
								 CustomerName, Reference, PhoneNumber, MobileNumber, eMailAddress, PostalCode, 
								 Memo, TaxExemption, Terms, Operational, 
								 OfficerUserId, OfficerLastName, OfficerFirstName)
						SELECT   CustomerId, Mission, OrgUnit, PersonNo, 
						         CustomerName,  Reference, PhoneNumber, MobileNumber, eMailAddress, PostalCode, 
								 Memo, TaxExemption, Terms, Operational, 
								 '#session.acc#', '#session.last#','#session.first#'
						FROM     Materials.dbo.Customer
						WHERE    CustomerId = '#customerid#'
				    </cfquery>
					
					<cfquery name="customer"
						   datasource="AppsWorkOrder" 
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">			
						   SELECT * 
						   FROM   Customer
						   WHERE  CustomerId = '#customerid#'			   					   
						</cfquery>			
													
				<cfelse>
				
				       <cfquery name="customer"
						   datasource="AppsWorkOrder" 
						   username="#SESSION.login#"
						   password="#SESSION.dbpw#">			
						   SELECT * 
						   FROM   Customer
						   WHERE  CustomerId = '#resultid#'			   					   
						</cfquery>			
							
				</cfif>
				
			</cfif>	
			
			<cfreturn customer>						
						
	</cffunction>		
			
</cfcomponent>	