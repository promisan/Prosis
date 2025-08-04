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

<!--- 
   Name : /Component/Access.cfc
   Description : Test access rights
--->   

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "User authorization">
	<cfparam name="SESSION.acc" default="fodnyhv1">
	
	<!--- GENERAL MODULE ACCESS --->
	
	<cffunction access="public" name="Report" output="true" returntype="string" displayname="Verify Function Access">
		<cfargument name="ControlId" type="string" required="yes">
		<cfargument name="Owner"       type="string" default="">
		<cfargument name="UserAccount" type="string" required="no" default="#SESSION.acc#">
		
		<cfif SESSION.isAdministrator eq "Yes" or SESSION.isLocalAdministrator neq "No">
		
   			  <CFSET AccessRight = "GRANTED">
				  
		<cfelse>
		
		  <cfquery name="Access" datasource="AppsSystem">
		   SELECT   *
		   FROM     Ref_ReportControl
		   WHERE    ControlId = '#ControlId#'
          </cfquery>
			
		  <cfif Access.EnableAnonymous eq "1">
		 	   
			   <CFSET AccessRight = "GRANTED">
		  
		  <cfelse>
		  
			   <cfquery name="Parameter" datasource="AppsSystem">
				   SELECT   *
				   FROM     Parameter 
			   </cfquery>
		  		  
		       <cfif UserAccount eq Parameter.AnonymousUserId>
			   
					   <CFSET AccessRight = "NONE">
			   
			   <cfelse>
			   		  
				  <cfquery name="Access" 
				  datasource="AppsSystem">
				  
				   SELECT   DISTINCT R.ControlId
				   FROM     Organization.dbo.OrganizationAuthorization A INNER JOIN
							Ref_ReportControlRole R ON A.Role = R.Role
				   WHERE    AccessLevel IN ('0', '1', '2')
					 AND    UserAccount = '#UserAccount#'
					 AND    R.ControlId = '#ControlId#'		
					 AND    R.Operational = 1			
					 AND    (R.ClassParameter is NULL or R.ClassParameter = '')					 
					 AND    R.Role NOT IN (SELECT Role 
					                       FROM   Ref_ReportControlRoleMission 
										   WHERE  ControlId = '#ControlId#'
										   AND    Mission <> 'Any')
										   
					<!--- --------------------------------------------------------- --->
				    <!--- limit access to report on the per role + defined mission- --->
					<!--- --------------------------------------------------------- ---> 
				
				   UNION 
				   
				    SELECT  DISTINCT R.ControlId
				    FROM    Organization.dbo.OrganizationAuthorization A INNER JOIN
						    Ref_ReportControlRoleMission R ON A.Role = R.Role AND A.Mission = R.Mission
				    WHERE   AccessLevel IN ('0', '1', '2')
					AND     UserAccount = '#UserAccount#'
					AND     R.ControlId = '#ControlId#'									
					AND     R.Role IN (SELECT Role 
					                   FROM   Ref_ReportControlRoleMission 
								       WHERE  ControlId = '#ControlId#')					   
					 
				   UNION
				   
				    <!--- ------------------------------------------------------ --->
				    <!--- limit access to report on the per role + defined owner --->
					<!--- ------------------------------------------------------ --->
				   
				    SELECT  DISTINCT R.ControlId
				    FROM    Organization.dbo.OrganizationAuthorization A INNER JOIN
							Ref_ReportControlRole R ON A.Role = R.Role AND A.ClassParameter = R.ClassParameter
				    WHERE   AccessLevel IN ('0', '1', '2')
					 AND    UserAccount      = '#UserAccount#'
					 AND    R.ControlId      = '#ControlId#'
					 AND    R.Operational = 1	
					 AND    R.ClassParameter = '#Owner#'
									   	 					 
				   UNION
				   
				    SELECT   DISTINCT G.ControlId
				    FROM     Ref_ReportControlUserGroup G INNER JOIN
					 		 UserNamesGroup U ON G.Account = U.AccountGroup
				    WHERE    U.account = '#SESSION.acc#'	
					AND      G.Operational = 1								
				    AND      G.ControlId = '#ControlId#'
					
				  </cfquery>
				 			  
				  				 
		
				  <cfif Access.RecordCount eq "0">
					  <CFSET AccessRight = "DENIED">
				  <cfelse>
					  <CFSET AccessRight = "GRANTED">
				  </cfif>	  
										 
				</cfif>	 
			 
			 </cfif>		  
							 
		</cfif>
			
		<cfreturn AccessRight>
		 
	</cffunction>
	
	<!--- edit report settings, also used for report delegation --->
			
	<cffunction access="public" name="editreport" output="true" returntype="string" displayname="Verify Employee Access">
	
		<cfargument name="ControlId" type="string" required="yes">
		<cfargument name="UserAccount" type="string" required="no" default="#SESSION.acc#">
		
		<!--- check the mode --->
				
		<cfif SESSION.isAdministrator eq "Yes">

          <CFSET AccessLevel = "2">
		        
        <cfelse>
		
		   <cfquery name="Report" datasource="AppsSystem">
		   SELECT   *
		   FROM     Ref_ReportControl
		   WHERE    ControlId = '#ControlId#'
		   </cfquery>
				  
	  	   <cfquery name="Access" 
            datasource="AppsOrganization" 
            maxrows=1 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
	            SELECT MAX(AccessLevel) as AccessLevel
		        FROM   OrganizationAuthorization Aut
	            WHERE  Aut.UserAccount = '#SESSION.acc#' 
		      	AND    Aut.Role IN ('AdminSystem')
				AND    Aut.ClassParameter = '#Report.Owner#'
		   </cfquery>
         		   
		   <cfif Access.AccessLevel eq "" and Report.operational eq "1">
		   
		   	   <!--- check if user has access for security settings only --->
			   
			    <cfquery name="Delegate" datasource="AppsSystem">
				   SELECT   ControlId
				   FROM     Ref_ReportControlRole
				   WHERE    ControlId = '#ControlId#'
				   AND      Delegation = 1
				   AND      Role IN (SELECT Role 
				                     FROM   Organization.dbo.OrganizationAuthorization
									 WHERE  UserAccount = '#SESSION.acc#')
				   UNION	
					
				   SELECT   ControlId
				   FROM     Ref_ReportControlUserGroup
				   WHERE    ControlId = '#ControlId#'
				   AND      Delegation = 1
				   AND      Account IN (SELECT AccountGroup 
				                        FROM   UserNamesGroup
									    WHERE  Account = '#SESSION.acc#')				 
									 
			   </cfquery>			   
		   				
				<cfif Delegate.recordcount gte "1">
				
					<CFSET AccessLevel = "1">
				
				<cfelse>
				
					<CFSET AccessLevel = "9">
				
				</cfif>
		                
           <cfelse>
           
		      <CFSET AccessLevel = Access.AccessLevel>
			  
	       </cfif>	  
					
		 </cfif>
		 
		 <cfinclude template="AccessSub.cfm">
		 <cfreturn AccessRight>
		 
	</cffunction>
	
</cfcomponent>