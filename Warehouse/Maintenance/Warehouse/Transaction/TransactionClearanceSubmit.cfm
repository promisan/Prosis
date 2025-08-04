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

<cfquery name="types" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM   	Ref_TransactionType
	WHERE   TransactionType NOT IN ('1','7')
</cfquery>

<cftransaction>

	<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   	DELETE
		FROM   	WarehouseTransaction
		WHERE	Warehouse = '#url.warehouse#'		
	</cfquery>
	
	<cfloop query="types">
	
		<cfparam name="Form.EntityClass_#TransactionType#" default="">
		<cfparam name="Form.Operational_#TransactionType#" default="0">
		<cfset entcls = evaluate("Form.EntityClass_#TransactionType#")>
	
		<cfif isDefined('form.TransactionType_#TransactionType#')>
			
			<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO WarehouseTransaction (
							Warehouse,							
							TransactionType,
							ClearanceMode,		
							PreparationMode,				
							EntityClass,						
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
						'#url.warehouse#',						
						'#Evaluate("Form.TransactionType_#TransactionType#")#',
						'#Evaluate("Form.ClearanceMode_#TransactionType#")#',
						'#Evaluate("Form.PreparationMode_#TransactionType#")#',
						<cfif (evaluate("Form.ClearanceMode_#TransactionType#") eq "3" or evaluate("Form.ClearanceMode_#TransactionType#") eq "2") and entcls neq "">
						'#entcls#',
						<cfelse>						
						'',
						</cfif>
						#Evaluate("Form.Operational_#TransactionType#")#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
		
		</cfif>
	
	</cfloop>

</cftransaction>

<cfinclude template="TransactionClearance.cfm">