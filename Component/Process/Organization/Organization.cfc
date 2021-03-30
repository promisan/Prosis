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
		
</cfcomponent>	