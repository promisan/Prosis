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
<cfswitch expression="#url.action#">
	
	<cfcase value="delete">
			<cfquery name="Update" 
				 datasource="AppsPurchase" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 DELETE FROM PurchaseExecutionRequest	
				 WHERE RequestId = '#URL.Id#'	
			</cfquery>	
			
			<cf_compression>
			
	</cfcase>
	
	<cfcase value="cancel">

		<!--- Added by Jorge Mazariegos on 10/4/2010 as CMP request for reason for cancellation
		on purchase requests --->
		<cftransaction>
		<cfquery name="Options" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_StatusReason
			WHERE     Status      = '9'
			AND       StatusClass = 'Execution'		 		
			AND       Operational = 1
		</cfquery>		
			
		<cfloop query="Options">
			
				<cfparam name="FORM.f1_#code#"         default="">
				<cfparam name="FORM.f1_#code#_remarks" default="">
				
				<cfset cde = evaluate("FORM.f1_#code#")>

				<cfif cde neq "">
				
					<cfset memo = evaluate("form.f1_#code#_remarks")>
									
					<cfif Len(memo) gt 400>
						 <cfset memo = left(memo,400)>
					</cfif>
				
					<cfquery name="DeleteReason" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						DELETE PurchaseExecutionRequestReason
						WHERE RequestId = '#URL.ID#'
						AND ReasonCode  = '#cde#'
					</cfquery>	 

					<cfquery name="InsertReason" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     INSERT INTO PurchaseExecutionRequestReason
						 (RequestId, 
						  ReasonCode, 
						  Remarks, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
						 VALUES  
						 ('#URL.ID#', 
						  '#cde#', 
						  '#memo#', 					 
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#')						
					</cfquery>					
				
				</cfif>				
			
			</cfloop>	
		    
	
			<cfquery name="Update" 
				 datasource="AppsPurchase" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE PurchaseExecutionRequest	
				 SET    ActionStatus = '9'
				 WHERE  RequestId    = '#URL.Id#'	
			</cfquery>	
		</cftransaction>	
			
			<cfquery name="Update" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 UPDATE OrganizationObject
				 SET    Operational = 0
				 WHERE  EntityCode = 'ProcExecution'
				 AND    ObjectKeyValue4 IN (SELECT RequestId 
				                            FROM   Purchase.dbo.PurchaseExecutionRequest 
							     	        WHERE  ActionStatus = '9')
			</cfquery>
			
			<cf_compression>
				
	</cfcase>	

</cfswitch>

<script>
	 try {	
			parent.opener.applyfilter('','','content');
	} catch(e) {}   
		
	parent.window.close();
</script>

