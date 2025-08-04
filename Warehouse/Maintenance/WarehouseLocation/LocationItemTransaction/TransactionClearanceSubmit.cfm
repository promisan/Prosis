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
	   	DELETE	FROM   	ItemWarehouseLocationTransaction
		WHERE	Warehouse = '#url.warehouse#'
		AND		Location = '#url.location#'
		AND		ItemNo = '#url.itemno#'
		AND		UoM = '#url.uom#'		
	</cfquery>
	
	<cfloop query="types">
	
		<cfparam name="Form.EntityClass_#TransactionType#" default="">
		<cfset entcls = evaluate("Form.EntityClass_#TransactionType#")>
		<cfset mail   = evaluate("Form.Notification_#TransactionType#")>
		
		<cfif isDefined('form.TransactionType_#TransactionType#')>
					
			<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			    INSERT INTO ItemWarehouseLocationTransaction (
							Warehouse,
							Location,
							ItemNo,
							UoM,
							TransactionType,							
							Source,			
							Notification,	
							ClearanceMode,		
							EntityClass,						
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES (
						'#url.warehouse#',
						'#url.location#',
						'#url.itemno#',
						'#url.uom#',
						'#Evaluate("Form.TransactionType_#TransactionType#")#', 
						'#Evaluate("Form.Source_#TransactionType#")#',
						'#mail#',
						'#Evaluate("Form.ClearanceMode_#TransactionType#")#',
						<cfif (evaluate("Form.ClearanceMode_#TransactionType#") eq "3"  or  evaluate("Form.TransactionType_#TransactionType#") eq "2") and entcls neq "">
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