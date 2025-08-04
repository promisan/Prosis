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


<!--- revert a personnel action --->

<cftransaction>

	<cfquery name="RevertPA" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	 UPDATE EmployeeAction 
		 SET    ActionStatus      = '9', 		       
				ActionDescription = 'Denied [per]'
		 WHERE  ActionDocumentNo  = '#url.actiondocumentno#'		
	</cfquery>
	
	<!--- Hanno 20/4/2018 pending to remove the workflow --->
	
	
	<cfquery name="ActionSource" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   EmployeeActionSource
		  WHERE  ActionDocumentNo = '#url.actiondocumentno#'	
	</cfquery>		
	
	<cfloop query = "ActionSource">
	
	    <cfif ActionStatus eq "9">
		
		<!--- check field --->
		
		<cfquery name="Check" 
		   datasource="AppsEmployee" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		      SELECT * 
			  FROM   Ref_PersonGroup
			  WHERE  Code = '#ActionField#'			  
		</cfquery>		
		
		<cfif Check.recordcount eq "1">
		
			<cfquery name="CheckList" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      SELECT *
				  FROM   Ref_PersonGroupList
				  WHERE  GroupCode = '#ActionField#'		
				  AND    Description = '#ActionFieldValue#'	  
			</cfquery>	
			
			<cfif CheckList.recordcount eq "1">	
					
		     <cfquery name="ResetValue" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			      UPDATE PersonGroup 
				  SET    GroupListCode = '#CheckList.GroupListCode#'		  
				  WHERE  PersonNo = '#PersonNo#'
				  AND    GroupCode = '#ActionField#'
			</cfquery>	
			
			<cfelse>
			
				<script>
				 alert("Recorded could not be reverted. Cancellation aborted.")				 
				</script>
				
				<cfabort>
			
			</cfif>			
			
		<cfelse>
		
			<cftry>
		
				<cfquery name="ResetValue" 
				   datasource="AppsEmployee" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				      UPDATE Person 
					  SET    #ActionField# = '#ActionFieldValue#'		  
					  WHERE  PersonNo = '#PersonNo#'
				</cfquery>	
						
				<cfcatch>
				
				    <cfoutput>
						<script>
							 alert("Employee Information for #ActionField# could not be reverted. Cancellation aborted")				 
						</script>	
					</cfoutput>			
					
					<cfabort>
							
				</cfcatch>			
			
			</cftry>
		
		</cfif>		
		  		
		</cfif>	
	
	</cfloop>
	
</cftransaction>

<script>
	 window.close()
</script>
	
	