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
   Name : /Component/qAccess.cfc
   Description : Test access rights
--->   

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Global User authorization">
		
	<!--- Roster Candidate information administrator --->
	
	<cffunction access="public" name="global" output="true" returntype="string" displayname="Verify Candidate Access">
    	<cfargument name="Role" type="string" required="true">
		<cfargument name="Parameter" type="string" required="false" default="">
		<cfargument name="Access" type="string" required="true" default="9">
				
		<cfif SESSION.isAdministrator eq "Yes">
		
          <CFSET AccessLevel = '2'>
		        
        <cfelse>
						
           <cfquery name="qAccess" 
            datasource="AppsOrganization" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
            SELECT Max(AccessLevel) as AccessLevel
	        FROM   OrganizationAuthorization 
			WHERE  UserAccount = '#SESSION.acc#' 
			  AND  Role    = '#Role#'
			  <cfif #Parameter# neq "">
			  AND  ClassParameter = '#Parameter#'   
			  </cfif>
			</cfquery>
   
            <cfif #qAccess.RecordCount# eq "0">
              <CFSET AccessLevel = '9'>
            <cfelse>
              <CFSET AccessLevel = '#qAccess.AccessLevel#'>
	        </cfif>	  
			
		 </cfif>
		 
		 <cfswitch expression="#AccessLevel#">
		 <cfcase value="0">
		      <CFSET AccessRight = 'READ'>
		 </cfcase>
		 <cfcase value="1">
		      <CFSET AccessRight = 'EDIT'>
		 </cfcase>
		 <cfcase value="2">
		      <CFSET AccessRight = 'ALL'>
		 </cfcase>
		 <cfcase value="8">
		      <CFSET AccessRight = 'NONE'>
		 </cfcase>
		 <cfcase value="9">
		      <CFSET AccessRight = 'NONE'>
		 </cfcase>
		 <cfdefaultcase>
		      <CFSET AccessRight = 'NONE'>
		 </cfdefaultcase>
		 </cfswitch>	
				
		 <cfreturn AccessRight>
		 
	</cffunction>
	

</cfcomponent>