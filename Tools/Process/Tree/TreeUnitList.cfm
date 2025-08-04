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

<cfset accesslist = "">
<cfparam name="attributes.Mission"   default="">
<cfparam name="attributes.MandateNo" default="">
<cfparam name="attributes.Role"      default="">
<cfparam name="attributes.Tree"      default="1">

<!--- check for full mission access check --->

<cfquery name="Check" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT TOP 1 *
		  FROM   OrganizationAuthorization
		  WHERE  UserAccount = '#SESSION.acc#' 
		  AND    Mission     = '#attributes.Mission#'
		  AND    Role IN (#preservesinglequotes(attributes.role)#) 
		  AND    (OrgUnit is NULL or OrgUnit = '')
 </cfquery>
 	
<cfif Check.recordcount eq "0" 
		AND SESSION.isAdministrator eq "No" 
		AND not findNoCase(attributes.mission,SESSION.isLocalAdministrator)>	 
	
	<cfquery name="Access" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT DISTINCT OrgUnit
		  FROM   OrganizationAuthorization
	   	  WHERE  UserAccount = '#SESSION.acc#'
		  AND    Mission = '#attributes.Mission#'
		  AND    OrgUnit IN (SELECT OrgUnit 
		                     FROM   Organization 
							 WHERE  Mission   = '#attributes.Mission#'
							 <cfif attributes.mandateno neq "">
		                     AND    MandateNo = '#attributes.MandateNo#'
							 </cfif>
							 )
		  AND    Role IN (#preservesinglequotes(attributes.role)#) 
	</cfquery>
	
	<cfloop query="Access">
	
	    <cfif accessList eq "">
			<cfset accessList = "'#access.OrgUnit#'">
		<cfelse>
			<cfset accessList = "#accessList#,'#access.OrgUnit#'">
	    </cfif>
		 
		<cfif attributes.tree eq "1">
	
		    <cfquery name="Check" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT DISTINCT OrgUnitCode, ParentOrgUnit, Mission, MandateNo
			  FROM   Organization
		   	  WHERE  OrgUnit = '#OrgUnit#' 
		    </cfquery>
			
			<cfset Parent = Check.ParentOrgUnit>
			<cfset Miss   = Check.Mission>
			<cfset Mand   = Check.MandateNo>
			
			<cfloop condition="Parent neq ''">
			   	  
			   <cfquery name="LevelUp" 
				datasource="AppsOrganization" 
				maxrows=1 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		          SELECT OrgUnit, ParentOrgUnit 
		          FROM   Organization
		          WHERE  OrgUnitCode = '#Parent#'
				  AND    Mission     = '#Miss#'
				  AND    MandateNo   = '#Mand#' 
		  	   </cfquery>
			   
			   <!--- check if record exists and add 
			   
			   I removed this 18/7/2011 
			   
			   <cfquery name= "Exist" 
		        datasource  = "AppsOrganization" 
		        username    = "#SESSION.login#" 
		        password    = "#SESSION.dbpw#">
				    SELECT  * 
					FROM    OrganizationAuthorization
					WHERE   OrgUnit = '#LevelUp.OrgUnit#'
			   </cfquery>
			   
			   <cfif exist.recordcount eq "0" and LevelUp.recordcount eq "1">
			   
			   --->
			   
			   <cfif LevelUp.recordcount eq "1">
			   
			   	   <cfif accessList eq "">
				   
						<cfset accessList = "'#LevelUp.OrgUnit#'">
						
				   <cfelse>
				   
				   		<cfif not find(LevelUp.OrgUnit,accesslist)>
					       <cfset accessList = "#accessList#,'#LevelUp.OrgUnit#'">
						</cfif>	   
						
				   </cfif>
			       		
				</cfif>
			     
			   <cfset Parent = LevelUp.ParentOrgUnit>
			   
			   </cfloop>
		   
	     </cfif>
			
	</cfloop>	
	
<cfelse>

	<cfset accesslist = "full">
	
</cfif>	   

<cfset caller.accesslist = accesslist>