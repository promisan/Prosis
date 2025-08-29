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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Roster authorization">
	
	<!--- 1.0 GENERAL ACCESS TO A FUNCTION --->
	
	<cffunction access="public" name="RosterStep" output="true" returntype="string" displayname="Verify Roster Access">
	
		<cfargument name="Role"         type="string" required="false" default="'RosterClear','AdminRoster'">
		<cfargument name="Owner"        type="string" required="true"  default="">
		<cfargument name="Process"      type="string" required="true"  default="Process">
		<cfargument name="Status"       type="string" required="true"  default="1">
		
		<!--- only for process listing relevant in the From - TO access --->
		<cfargument name="StatusTo"     type="string" required="false" default="">
				
		<cfargument name="FunctionId"   type="string" required="false" default="">
		<cfargument name="SearchId"     type="string" required="false" default="">
										   
	    <!--- check if person show see this by defining the next step, 
		                                               to which he/she has access or not --->		   
		   <cfquery name="getStep"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			    SELECT  *
				FROM    Ref_StatusCode
	            WHERE   Status = '#Status#' 
				 AND    Id     = 'FUN' 
				 AND    Owner  = '#Owner#' 
			</cfquery>	
			
		    <!--- get user access levels --->			
			                                            	   
		   <cfquery name="getUserAccess"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			    SELECT  DISTINCT AccessLevel
				FROM    RosterAccessAuthorization
				WHERE   1=1  
				
				        <cfif FunctionId neq "">				
							AND FunctionId = '#FunctionId#'  
						<cfelseif searchId neq "">
							AND FunctionId IN (SELECT Selectid 
						                       FROM   RosterSearchLine 
									           WHERE  SearchId    = '#SearchId#' 
									           AND    SearchClass = 'Function')  
						<cfelse>
						    AND FunctionId IN (
							                   SELECT FunctionId
							                   FROM   FunctionOrganization
											   WHERE  SubmissionEdition IN (SELECT SubmissionEdition 
											                                FROM   Ref_SubmissionEdition 
																		    WHERE  Owner = '#Owner#')	
											  )							   				   
						</cfif>
				 AND    UserAccount = '#SESSION.acc#' 
				 AND    Role IN (#preservesingleQuotes(role)#)								 
		   </cfquery>	
		   		   		   
		   <!--- --------------------------------------------------------- --->
		   <!--- get user access level that have a denial prevention ----- --->
		   <!--- --------------------------------------------------------- --->
		   
		   <cfquery name="getUserAccessLimited"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			    SELECT  DISTINCT AccessLevel
				FROM    RosterAccessAuthorization
				WHERE   			
				        <cfif FunctionId neq "">				
							FunctionId = '#FunctionId#' 
						<cfelseif searchId neq "">
							FunctionId IN (SELECT SelectId 
						                   FROM   RosterSearchLine 
									       WHERE  SearchId    = '#SearchId#' 
									       AND    SearchClass = 'Function')  
						<cfelse>
						    FunctionId IN (
							               SELECT FunctionId
							               FROM   FunctionOrganization
										   WHERE  SubmissionEdition IN (SELECT SubmissionEdition 
											                            FROM   Ref_SubmissionEdition 
																		WHERE  Owner = '#Owner#')	
											  )							   							   
						</cfif>
				 AND    UserAccount = '#SESSION.acc#' 
				 AND    Role IN (#preservesingleQuotes(role)#)		
				 AND    AccessCondition = 'limited'						 
		   </cfquery>	
		   
		   <cfif Process eq "Process" and StatusTo eq "">
		   		       		   
		   	   <cfif SESSION.isAdministrator eq "Yes" or (owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator))>
			   
			   	  <cfquery name="getStatusToShow"
				   datasource="AppsSelection"
				   username="#SESSION.login#"
				   password="#SESSION.dbpw#">
					    SELECT  *
						FROM    Ref_StatusCode
			            WHERE   Id     = 'FUN' 
						 AND    Owner  = '#Owner#' 
					</cfquery>		
					
					<cfset accesslist = "#ValueList(getStatusToShow.Status)#"> 	
			   
			   <cfelse>
			   			   		   
				   <cfquery name="getStatusToShow"
					  	datasource="AppsSelection"
					   username="#SESSION.login#"
					   password="#SESSION.dbpw#">
					   
					   <!--- get the to list excl 9 deny --->
					   
					   SELECT  DISTINCT StatusTo 
					   FROM    Ref_StatusCodeProcess
					   WHERE   Owner   = '#Owner#' 
					   AND     Id      = 'FUN'
					   <!--- status from --->
					   AND     Status  = '#Status#'
					   AND     Process = 'Process'	
					   AND     Role IN (#preservesingleQuotes(role)#)	
					   <cfif getUserAccess.AccessLevel neq "">					  
					   AND     AccessLevel IN (#QuotedValueList(getUserAccess.AccessLevel)#)				   
					   </cfif>	
					   AND   StatusTo != '9'
					   					   
					   UNION
					   
					   <!--- get the to list for 9 deny but only if this was not expliclity denied --->
					   
					   SELECT  DISTINCT StatusTo 
					   FROM    Ref_StatusCodeProcess
					   WHERE   Owner   = '#Owner#' 
					   AND     Id      = 'FUN'
					   <!--- status from --->
					   AND     Status  = '#Status#'
					   AND     Process = 'Process'	
					   AND     Role IN (#preservesingleQuotes(role)#)	
					   <cfif getUserAccess.AccessLevel neq "">	
					   AND     AccessLevel IN (#QuotedValueList(getUserAccess.AccessLevel)#)		
					   </cfif>
					   
					   <cfif getUserAccessLimited.AccessLevel neq "">					 
					   <!--- is not overruled to be hidden --->
					   AND     AccessLevel NOT IN (#QuotedValueList(getUserAccessLimited.AccessLevel)#)				   
					   </cfif>						   
					   AND   StatusTo = '9'						   					   
					   				   					   					   
				   </cfquery>					 
				   
				   <cfif getStatusToShow.recordcount gte "1">				   
						<cfset accesslist = "#ValueList(getStatusToShow.StatusTo)#"> 
				   <cfelse>				   
						<cfset accesslist = ""> 
				   </cfif>
				   
			   </cfif>	   
			   
			   <cfreturn accesslist>
		   				   
		   <cfelse>		   		    
		   
		   		<!--- search and process to a specific level --->
		   
		   		<cfif SESSION.isAdministrator eq "Yes" or (owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator))>
				
					<cfset access = "1"> 
				
				<cfelse>
						   
			   		<cfquery name="getStatusToShow"
					   datasource="AppsSelection"
					   username="#SESSION.login#"
					   password="#SESSION.dbpw#">
					   SELECT  * 
					   FROM    Ref_StatusCodeProcess
					   WHERE   Owner   = '#Owner#' 
					   AND     Id      = 'FUN'
					   AND     Status  = '#Status#'
					   <cfif StatusTo neq "">
					   AND     StatusTo = '#StatusTo#'
					   </cfif>
					   AND     Role  IN (#preservesingleQuotes(role)#)	
					   <cfif getUserAccess.AccessLevel eq "">
					   AND   1=0
					   <cfelse>
					   AND     AccessLevel IN (#QuotedValueList(getUserAccess.AccessLevel)#)		
					   </cfif>
					   AND     Process = '#Process#'	
					 					   
				   </cfquery>		
				   				  
				   <cfif getStatusToShow.recordcount gte "1">				  
					   	<cfset access = "1">  					
				   <cfelse>				  
					   	<cfset access = "0">  					
				   </cfif>
				   
				 </cfif>  
			   
			     <cfreturn access>
		   
		   </cfif>
		 
		 			
	</cffunction>		
	
</cfcomponent>			