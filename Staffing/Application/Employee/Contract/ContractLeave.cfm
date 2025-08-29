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
<!--- ------------------ --->
		
<cfquery name="Ent" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Ref_LeaveType
		WHERE    LeaveAccrual = '3'
</cfquery>		
				
<cfloop query="Ent">
			
		<cfparam name="Form.#LeaveType#" default="0">
		<cfset val = evaluate("Form.#LeaveType#")>
						  	   
	    <cfquery name="ClearPrior" 
		     datasource="AppsEmployee" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 DELETE  PersonLeaveEntitlement 
			 WHERE   ContractId   = '#ctid#'
			 AND     LeaveType    = '#LeaveType#'
	    </cfquery>  
		
		<cfif val neq "0">
										      			  
			<cfquery name="Insert" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO PersonLeaveEntitlement 
					 
		             (PersonNo,
					  ContractId,							  
					  DateEffective,
					  LeaveType,
					  DaysEntitlement,							 
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
							  
				 VALUES
						  
				  	('#Form.PersonNo#',
					 '#ctid#',
				     #STR#,
					 '#LeaveType#',
					 '#val#',							
					 '#SESSION.acc#',
				     '#SESSION.last#',		  
					 '#SESSION.first#' )
								 
			  </cfquery>	
		  
		  </cfif>							  
						
</cfloop>	