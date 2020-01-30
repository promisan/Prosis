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
		
</cfcomponent>	