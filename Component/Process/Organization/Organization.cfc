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
    <cfset this.name = "Organizatio component">
	
	<cffunction name="getUnitScope"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Obtain from an orgunit all the units of its parent">
		
		<cfargument name="Mode" type="string" default="Parent" required="yes">
	    <cfargument name="OrgUnit"   type="string" required="true">
		
		<cfif Mode eq "Parent">
		
			<!--- get all units of the parent of the passed orgunit --->
				
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   Org.OrgUnit, Org.OrgUnitCode, Org.OrgUnitName, Org.OrgUnitNameShort, Org.HierarchyCode
				FROM     Organization Unit INNER JOIN
	            	     Organization Org 
					 ON  Unit.Mission           = Org.Mission 
					 AND Unit.MandateNo         = Org.MandateNo 
					 AND Unit.HierarchyRootUnit = Org.HierarchyRootUnit
				WHERE    Unit.OrgUnit = '#OrgUnit#'				
			</cfquery>	
		
		<cfelseif Mode eq "Children"> 
		
			<!--- get all units in the hierarchy tree of this orgunit --->
		
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			    SELECT    Org.OrgUnit, Org.OrgUnitCode, Org.OrgUnitName, Org.OrgUnitNameShort, Org.HierarchyCode
				FROM      Organization Unit INNER JOIN Organization Org 
				     ON   Unit.Mission = Org.Mission 
				     AND  Unit.MandateNo = Org.MandateNo
				     AND  Org.HierarchyCode LIKE Unit.HierarchyCode + '%'
				WHERE     Unit.OrgUnit = '#OrgUnit#'
			</cfquery>
			
		</cfif>				
		
		<cfset scope = quotedValueList(get.OrgUnit)>
		
		<cfreturn scope>	
						
	</cffunction>	
	
	<cffunction name="getUnit"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Obtain from an orgunit specific information">	
		
		<cfargument name="OrgUnit" type="string" required="true">
		<cfargument name="Action"  type="string"  default="getrecord" required="yes">
		<cfargument name="Level"   type="string" required="true" default="2">						
				
		<cfswitch expression="#Action#">
		
			<cfcase value="getrecord">
			
				<cfquery name="get" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
						FROM     Organization 				
						WHERE    OrgUnit = '#OrgUnit#'				
					</cfquery>	
				
				<cfset lvl = "1">
				
				<cfloop index="itm" list="#get.HierarchyCode#" delimiters=".">		
					<cfset lvl = lvl + 1>		
				</cfloop>
				
				<cfif lvl lte level>
				
					<cfset orgresult = get>
					
				<cfelse>
				
					<cfset up = lvl - level>
									
					<cfloop index="itm" from="1" to="#up#">
					
						<cfset par = get.parentOrgUnit>
						
						<cfquery name="get" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     Organization 				
							WHERE    Mission     = '#get.Mission#'				
							AND      MandateNo   = '#get.MandateNo#'
							AND      OrgUnitCode = '#par#'
						</cfquery>					
					
					</cfloop>
					
					<cfset orgresult = get>						
				
				</cfif>		
					
			</cfcase>
				
		</cfswitch>
		 		
		<cfreturn orgresult>	
		
	</cffunction>		
	
	
	<!--- ------------------------------------------------------------------------------------------ --->
<!--- Component to serve requests that relate to the provisioing of a service based workorder -- ---> 
<!--- ------------------------------------------------------------------------------------------ --->
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Organizatio component">
	
	<cffunction name="getUnitScope"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Obtain from an orgunit all the units of its parent">
		
		<cfargument name="Mode" type="string" default="Parent" required="yes">
	    <cfargument name="OrgUnit"   type="string" required="true">
		
		<cfif Mode eq "Parent">
		
			<!--- get all units of the parent of the passed orgunit --->
				
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   Org.OrgUnit, Org.OrgUnitCode, Org.OrgUnitName, Org.OrgUnitNameShort, Org.HierarchyCode
				FROM     Organization Unit INNER JOIN
	            	     Organization Org 
					 ON  Unit.Mission           = Org.Mission 
					 AND Unit.MandateNo         = Org.MandateNo 
					 AND Unit.HierarchyRootUnit = Org.HierarchyRootUnit
				WHERE    Unit.OrgUnit = '#OrgUnit#'				
			</cfquery>	
		
		<cfelseif Mode eq "Children"> 
		
			<!--- get all units in the hierarchy tree of this orgunit --->
		
			<cfquery name="get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			    SELECT    Org.OrgUnit, Org.OrgUnitCode, Org.OrgUnitName, Org.OrgUnitNameShort, Org.HierarchyCode
				FROM      Organization Unit INNER JOIN Organization Org 
				     ON   Unit.Mission = Org.Mission 
				     AND  Unit.MandateNo = Org.MandateNo
				     AND  Org.HierarchyCode LIKE Unit.HierarchyCode + '%'
				WHERE     Unit.OrgUnit = '#OrgUnit#'
			</cfquery>
			
		</cfif>				
		
		<cfset scope = quotedValueList(get.OrgUnit)>
		
		<cfreturn scope>	
						
	</cffunction>	
	
	<cffunction name="getUnit"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Obtain from an orgunit specific information">	
		
		<cfargument name="OrgUnit" type="string" required="true">
		<cfargument name="Action"  type="string"  default="getrecord" required="yes">
		<cfargument name="Level"   type="string" required="true" default="2">						
				
		<cfswitch expression="#Action#">
		
			<cfcase value="getrecord">
			
				<cfquery name="get" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
						FROM     Organization 				
						WHERE    OrgUnit = '#OrgUnit#'				
					</cfquery>	
				
				<cfset lvl = "1">
				
				<cfloop index="itm" list="#get.HierarchyCode#" delimiters=".">		
					<cfset lvl = lvl + 1>		
				</cfloop>
				
				<cfif lvl lte level>
				
					<cfset orgresult = get>
					
				<cfelse>
				
					<cfset up = lvl - level>
									
					<cfloop index="itm" from="1" to="#up#">
					
						<cfset par = get.parentOrgUnit>
						
						<cfquery name="get" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
							FROM     Organization 				
							WHERE    Mission     = '#get.Mission#'				
							AND      MandateNo   = '#get.MandateNo#'
							AND      OrgUnitCode = '#par#'
						</cfquery>					
					
					</cfloop>
					
					<cfset orgresult = get>						
				
				</cfif>		
					
			</cfcase>
				
		</cfswitch>
		 		
		<cfreturn orgresult>	
		
	</cffunction>		
	
	
	<cffunction name="getPersonScope"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Obtain from a person or users relevant current information">	
		
		<cfargument name="Mode" type="string" default="Assignment" required="yes">
	    <cfargument name="Mission"   type="string" required="true">	
		<cfargument name="PersonNo"  type="string" required="true">	
		
		<!--- we get the current unit and job of this person within the organization --->
						
		<cfquery name="PersonScope" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   P.PersonNo,
			          P.Gender,
			          P.LastName,
					  P.FirstName,
					  Po.SourcePostNumber,
					  <cfif mode eq "Position">
					  Po.FunctionNo,Po.FunctionDescription, 
					  <cfelse>
			          PA.FunctionNo, PA.FunctionDescription,
					  </cfif>
			          O.OrgUnitName, O.OrgUnitNameShort
			 FROM     PersonAssignment PA 
			          INNER JOIN Position Po ON PA.PositionNo = Po.PositionNo 
					  <cfif mode eq "Position">
					  INNER JOIN Organization.dbo.Organization O ON Po.OrgUnitOperational = O.OrgUnit
					  <cfelse>
					  INNER JOIN Organization.dbo.Organization O ON PA.OrgUnit = O.OrgUnit
					  </cfif>
					  INNER JOIN Person P ON PA.PersonNo = P.PersonNo
			 WHERE    P.PersonNo         = '#PersonNo#' 
			 AND      PA.DateEffective    <= getdate()	 	
			 AND      Po.Mission          = '#mission#'						
			 AND      PA.DateExpiration   >= getDate()						 
			 AND      PA.AssignmentStatus IN ('0','1')
			 <!---
			 AND      PA.AssignmentClass = 'Regular'
			 --->
			 AND      PA.AssignmentType  = 'Actual'
			 ORDER BY Incumbency DESC		<!--- first 100% then 0% --->				
		 </cfquery> 
		 
		 <cfreturn personscope>	 
		
		
	</cffunction>		
		
</cfcomponent>			
		
</cfcomponent>	